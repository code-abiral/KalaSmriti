using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace KalaSmriti
{
    public static class PasswordResetService
    {
        private const int DefaultTokenExpiryMinutes = 30;

        public static void EnsureResetTokenTable()
        {
            string query = @"IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PasswordResetToken]') AND type in (N'U'))
BEGIN
    CREATE TABLE PasswordResetToken (
        PasswordResetTokenID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        TokenHash NVARCHAR(128) NOT NULL,
        ExpiresAt DATETIME NOT NULL,
        IsUsed BIT NOT NULL DEFAULT 0,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        UsedAt DATETIME NULL,
        CONSTRAINT FK_PasswordResetToken_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    );
    CREATE UNIQUE INDEX IX_PasswordResetToken_TokenHash ON PasswordResetToken(TokenHash);
END";

            DBHelper.ExecuteNonQuery(query);
        }

        public static string CreateResetToken(int customerId)
        {
            EnsureResetTokenTable();

            string token = GenerateToken();
            string tokenHash = ComputeSha256Hex(token);

            string query = @"INSERT INTO PasswordResetToken (CustomerID, TokenHash, ExpiresAt, IsUsed, CreatedAt)
VALUES (@CustomerID, @TokenHash, DATEADD(MINUTE, @ExpiryMinutes, GETDATE()), 0, GETDATE())";

            SqlParameter[] parameters = {
                new SqlParameter("@CustomerID", customerId),
                new SqlParameter("@TokenHash", tokenHash),
                new SqlParameter("@ExpiryMinutes", DefaultTokenExpiryMinutes)
            };

            DBHelper.ExecuteNonQuery(query, parameters);
            return token;
        }

        public static bool IsTokenValid(string token)
        {
            int customerId;
            return TryGetCustomerIdFromToken(token, out customerId);
        }

        public static bool TryResetPassword(string token, string newPlainPassword)
        {
            if (string.IsNullOrWhiteSpace(token) || string.IsNullOrWhiteSpace(newPlainPassword))
            {
                return false;
            }

            string tokenHash = ComputeSha256Hex(token);
            string hashedPassword = PasswordSecurity.HashPassword(newPlainPassword);

            string query = @"DECLARE @CustomerID INT;
SELECT TOP 1 @CustomerID = CustomerID
FROM PasswordResetToken
WHERE TokenHash = @TokenHash AND IsUsed = 0 AND ExpiresAt > GETDATE();

IF @CustomerID IS NULL
BEGIN
    SELECT 0;
END
ELSE
BEGIN
    UPDATE Customer SET Password = @Password WHERE CustomerID = @CustomerID;
    UPDATE PasswordResetToken SET IsUsed = 1, UsedAt = GETDATE() WHERE TokenHash = @TokenHash;
    SELECT 1;
END";

            SqlParameter[] parameters = {
                new SqlParameter("@TokenHash", tokenHash),
                new SqlParameter("@Password", hashedPassword)
            };

            object result = DBHelper.ExecuteScalar(query, parameters);
            return result != null && Convert.ToInt32(result) == 1;
        }

        public static bool TryGetCustomerIdFromToken(string token, out int customerId)
        {
            customerId = 0;
            if (string.IsNullOrWhiteSpace(token))
            {
                return false;
            }

            EnsureResetTokenTable();

            string tokenHash = ComputeSha256Hex(token);
            string query = @"SELECT TOP 1 CustomerID
FROM PasswordResetToken
WHERE TokenHash = @TokenHash AND IsUsed = 0 AND ExpiresAt > GETDATE()";

            object result = DBHelper.ExecuteScalar(query, new[] { new SqlParameter("@TokenHash", tokenHash) });
            if (result == null)
            {
                return false;
            }

            customerId = Convert.ToInt32(result);
            return customerId > 0;
        }

        private static string GenerateToken()
        {
            byte[] tokenBytes = new byte[32];
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(tokenBytes);
            }

            string token = Convert.ToBase64String(tokenBytes)
                .Replace("+", "-")
                .Replace("/", "_")
                .TrimEnd('=');

            return token;
        }

        private static string ComputeSha256Hex(string input)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(input ?? string.Empty);
            using (SHA256 sha = SHA256.Create())
            {
                byte[] hash = sha.ComputeHash(bytes);
                StringBuilder sb = new StringBuilder(hash.Length * 2);
                for (int i = 0; i < hash.Length; i++)
                {
                    sb.Append(hash[i].ToString("x2"));
                }

                return sb.ToString();
            }
        }
    }
}
