using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;

namespace KalaSmriti
{
    public static class NotificationService
    {
        public static void EnsureNotificationsTable()
        {
            string query = @"IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notification]') AND type in (N'U'))
BEGIN
    CREATE TABLE Notification (
        NotificationID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        Title NVARCHAR(150) NOT NULL,
        Message NVARCHAR(MAX) NOT NULL,
        IsRead BIT NOT NULL DEFAULT 0,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Notification_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    );
END";

            DBHelper.ExecuteNonQuery(query);
        }

        public static void SendOrderNotification(int customerId, string email, string title, string message)
        {
            EnsureNotificationsTable();

            string insertQuery = @"INSERT INTO Notification (CustomerID, Title, Message, IsRead, CreatedDate)
VALUES (@CustomerID, @Title, @Message, 0, GETDATE())";

            SqlParameter[] insertParams = {
                new SqlParameter("@CustomerID", customerId),
                new SqlParameter("@Title", title),
                new SqlParameter("@Message", message)
            };

            DBHelper.ExecuteNonQuery(insertQuery, insertParams);

            TrySendEmail(email, title, message);
        }

        public static DataTable GetUserNotifications(int customerId)
        {
            EnsureNotificationsTable();

            string query = @"SELECT TOP 20 NotificationID, Title, Message, IsRead, CreatedDate
FROM Notification
WHERE CustomerID = @CustomerID
ORDER BY CreatedDate DESC";

            return DBHelper.ExecuteQuery(query, new[] { new SqlParameter("@CustomerID", customerId) });
        }

        public static int GetUnreadCount(int customerId)
        {
            EnsureNotificationsTable();

            string query = "SELECT COUNT(*) FROM Notification WHERE CustomerID = @CustomerID AND IsRead = 0";
            object result = DBHelper.ExecuteScalar(query, new[] { new SqlParameter("@CustomerID", customerId) });
            return result == null ? 0 : Convert.ToInt32(result);
        }

        public static void MarkAllAsRead(int customerId)
        {
            EnsureNotificationsTable();

            string query = "UPDATE Notification SET IsRead = 1 WHERE CustomerID = @CustomerID AND IsRead = 0";
            DBHelper.ExecuteNonQuery(query, new[] { new SqlParameter("@CustomerID", customerId) });
        }

        private static void TrySendEmail(string email, string subject, string body)
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                return;
            }

            bool isEnabled = string.Equals(ConfigurationManager.AppSettings["EnableSmtpNotifications"], "true", StringComparison.OrdinalIgnoreCase);
            if (!isEnabled)
            {
                return;
            }

            string host = ConfigurationManager.AppSettings["SmtpHost"];
            string portText = ConfigurationManager.AppSettings["SmtpPort"];
            string username = ConfigurationManager.AppSettings["SmtpUsername"];
            string password = ConfigurationManager.AppSettings["SmtpPassword"];
            string fromEmail = ConfigurationManager.AppSettings["SmtpFromEmail"];
            string fromName = ConfigurationManager.AppSettings["SmtpFromName"];
            bool enableSsl = !string.Equals(ConfigurationManager.AppSettings["SmtpEnableSsl"], "false", StringComparison.OrdinalIgnoreCase);

            int port;
            if (string.IsNullOrWhiteSpace(host) || string.IsNullOrWhiteSpace(fromEmail) || !int.TryParse(portText, out port))
            {
                return;
            }

            try
            {
                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(fromEmail, string.IsNullOrWhiteSpace(fromName) ? "KalaSmriti" : fromName);
                    mail.To.Add(email);
                    mail.Subject = subject;
                    mail.Body = body;
                    mail.IsBodyHtml = false;

                    using (SmtpClient client = new SmtpClient(host, port))
                    {
                        client.EnableSsl = enableSsl;

                        if (!string.IsNullOrWhiteSpace(username))
                        {
                            client.Credentials = new NetworkCredential(username, password ?? string.Empty);
                        }

                        client.Send(mail);
                    }
                }
            }
            catch
            {
                // Email failures should not block checkout/order flow.
            }
        }
    }
}

