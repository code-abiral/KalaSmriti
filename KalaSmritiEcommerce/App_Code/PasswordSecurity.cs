using System;
using System.Security.Cryptography;

namespace KalaSmriti
{
    public static class PasswordSecurity
    {
        private const int SaltSize = 16;
        private const int HashSize = 32;
        private const int Iterations = 100000;
        private const string Prefix = "PBKDF2";

        public static string HashPassword(string password)
        {
            if (string.IsNullOrWhiteSpace(password))
            {
                throw new ArgumentException("Password cannot be empty.", "password");
            }

            byte[] salt = new byte[SaltSize];
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            byte[] hash;
            using (Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
            {
                hash = pbkdf2.GetBytes(HashSize);
            }

            return Prefix + "$" + Iterations + "$" + Convert.ToBase64String(salt) + "$" + Convert.ToBase64String(hash);
        }

        public static bool VerifyPassword(string inputPassword, string storedPassword)
        {
            if (string.IsNullOrEmpty(storedPassword) || inputPassword == null)
            {
                return false;
            }

            if (!storedPassword.StartsWith(Prefix + "$", StringComparison.Ordinal))
            {
                // Legacy fallback for old plaintext records.
                return string.Equals(inputPassword, storedPassword, StringComparison.Ordinal);
            }

            string[] parts = storedPassword.Split('$');
            if (parts.Length != 4)
            {
                return false;
            }

            int iterations;
            if (!int.TryParse(parts[1], out iterations) || iterations <= 0)
            {
                return false;
            }

            byte[] salt;
            byte[] expectedHash;
            try
            {
                salt = Convert.FromBase64String(parts[2]);
                expectedHash = Convert.FromBase64String(parts[3]);
            }
            catch
            {
                return false;
            }

            byte[] actualHash;
            using (Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(inputPassword, salt, iterations, HashAlgorithmName.SHA256))
            {
                actualHash = pbkdf2.GetBytes(expectedHash.Length);
            }

            return AreEqualConstantTime(expectedHash, actualHash);
        }

        private static bool AreEqualConstantTime(byte[] left, byte[] right)
        {
            if (left == null || right == null || left.Length != right.Length)
            {
                return false;
            }

            int diff = 0;
            for (int i = 0; i < left.Length; i++)
            {
                diff |= left[i] ^ right[i];
            }

            return diff == 0;
        }
    }
}
