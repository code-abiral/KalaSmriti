using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.IO;
using System.Web;

namespace KalaSmriti
{
    public static class NotificationService
    {
        private const string ForgotPasswordSubject = "Reset your KalaSmriti password";

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
            SendOrderNotification(customerId, email, title, message, string.Empty);
        }

        public static void SendOrderNotification(int customerId, string email, string title, string message, string htmlBody)
        {
            try
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
            }
            catch (Exception ex)
            {
                LogSmtpIssue("Order notification DB insert failed: " + ex.Message);
            }

            string finalHtmlBody = string.IsNullOrWhiteSpace(htmlBody)
                ? BuildEmailTemplate(title, "<p style='margin:0;font-size:14px;line-height:1.7;color:#44403c;'>" + HttpUtility.HtmlEncode(message) + "</p>")
                : htmlBody;

            if (!TrySendEmail(email, title, finalHtmlBody, true))
            {
                LogSmtpIssue("Order email send returned false for recipient: " + email);
            }
        }

        public static bool SendPasswordResetLinkEmail(string email, string firstName, string resetLink)
        {
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(resetLink))
            {
                return false;
            }

            string safeName = string.IsNullOrWhiteSpace(firstName) ? "Collector" : firstName.Trim();
            string htmlBody = BuildEmailTemplate(
                "Reset Your Password",
                "<p style='margin:0 0 12px 0;font-size:14px;line-height:1.7;color:#44403c;'>Hello " + HttpUtility.HtmlEncode(safeName) + ",</p>"
                + "<p style='margin:0 0 14px 0;font-size:14px;line-height:1.7;color:#44403c;'>A request was received to reset your KalaSmriti account password.</p>"
                + "<p style='margin:0 0 16px 0;font-size:14px;line-height:1.7;color:#44403c;'>Use the button below to continue:</p>"
                + "<p style='margin:0 0 20px 0;'><a href='" + HttpUtility.HtmlAttributeEncode(resetLink) + "' style='display:inline-block;background:#1a140f;color:#ffffff;text-decoration:none;padding:12px 18px;font-size:12px;font-weight:700;letter-spacing:1px;text-transform:uppercase;'>Reset Password</a></p>"
                + "<p style='margin:0 0 12px 0;font-size:13px;line-height:1.7;color:#57534e;'>If the button does not work, copy and paste this link into your browser:</p>"
                + "<p style='margin:0 0 14px 0;font-size:12px;line-height:1.6;color:#a16207;word-break:break-all;'>" + HttpUtility.HtmlEncode(resetLink) + "</p>"
                + "<p style='margin:0;font-size:12px;line-height:1.7;color:#78716c;'>This link expires in 30 minutes and can be used only once.</p>");

            return TrySendEmail(email, ForgotPasswordSubject, htmlBody, true);
        }

        public static bool SendEmail(string email, string subject, string body)
        {
            return TrySendEmail(email, subject, body, false);
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

        private static bool TrySendEmail(string email, string subject, string body, bool isBodyHtml)
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                LogSmtpIssue("Email send skipped because recipient email is empty.");
                return false;
            }

            string enabledValue = EnvConfig.Get("ENABLE_SMTP_NOTIFICATIONS", ConfigurationManager.AppSettings["EnableSmtpNotifications"]);
            bool isEnabled = string.Equals(enabledValue, "true", StringComparison.OrdinalIgnoreCase);
            if (!isEnabled)
            {
                LogSmtpIssue("Email send skipped because EnableSmtpNotifications is false.");
                return false;
            }

            string host = EnvConfig.Get("SMTP_HOST", ConfigurationManager.AppSettings["SmtpHost"]);
            string portText = EnvConfig.Get("SMTP_PORT", ConfigurationManager.AppSettings["SmtpPort"]);
            string username = EnvConfig.Get("SMTP_USERNAME", ConfigurationManager.AppSettings["SmtpUsername"]);
            string password = EnvConfig.Get("SMTP_PASSWORD", ConfigurationManager.AppSettings["SmtpPassword"]);
            string fromEmail = EnvConfig.Get("SMTP_FROM_EMAIL", ConfigurationManager.AppSettings["SmtpFromEmail"]);
            string fromName = EnvConfig.Get("SMTP_FROM_NAME", ConfigurationManager.AppSettings["SmtpFromName"]);
            string sslValue = EnvConfig.Get("SMTP_ENABLE_SSL", ConfigurationManager.AppSettings["SmtpEnableSsl"]);
            bool enableSsl = !string.Equals(sslValue, "false", StringComparison.OrdinalIgnoreCase);

            int port;
            if (string.IsNullOrWhiteSpace(host) || string.IsNullOrWhiteSpace(fromEmail) || !int.TryParse(portText, out port))
            {
                LogSmtpIssue("Email send skipped due to invalid SMTP settings (host/fromEmail/port).");
                return false;
            }

            try
            {
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(fromEmail, string.IsNullOrWhiteSpace(fromName) ? "KalaSmriti" : fromName);
                    mail.To.Add(email);
                    mail.Subject = subject;
                    mail.Body = body;
                    mail.IsBodyHtml = isBodyHtml;

                    using (SmtpClient client = new SmtpClient(host, port))
                    {
                        client.DeliveryMethod = SmtpDeliveryMethod.Network;
                        client.UseDefaultCredentials = false;
                        client.EnableSsl = enableSsl;
                        client.Timeout = 20000;

                        if (!string.IsNullOrWhiteSpace(username))
                        {
                            client.Credentials = new NetworkCredential(username.Trim(), (password ?? string.Empty).Trim());
                        }

                        client.Send(mail);
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                // Email failures should not block checkout/order flow.
                LogSmtpIssue("SMTP send failed: " + ex.Message);
                return false;
            }

            return false;
        }

        private static string BuildEmailTemplate(string heading, string contentHtml)
        {
            return "<!DOCTYPE html><html><head><meta charset='utf-8'></head><body style='margin:0;padding:24px;background:#f5f5f4;font-family:Segoe UI,Arial,sans-serif;color:#1c1917;'>"
                + "<table role='presentation' cellpadding='0' cellspacing='0' border='0' width='100%' style='max-width:640px;margin:0 auto;background:#ffffff;border:1px solid #e7e5e4;'>"
                + "<tr><td style='background:#1a140f;color:#ffffff;padding:20px 24px;'><div style='font-size:11px;letter-spacing:1.8px;text-transform:uppercase;opacity:0.85;'>KalaSmriti</div><div style='margin-top:8px;font-size:20px;line-height:1.3;font-weight:700;'>" + HttpUtility.HtmlEncode(heading) + "</div></td></tr>"
                + "<tr><td style='padding:24px;'>" + contentHtml + "</td></tr>"
                + "<tr><td style='padding:16px 24px;border-top:1px solid #e7e5e4;font-size:11px;color:#78716c;'>This is an automated message from KalaSmriti.</td></tr>"
                + "</table></body></html>";
        }

        private static void LogSmtpIssue(string message)
        {
            try
            {
                string mappedPath = HttpContext.Current == null
                    ? null
                    : HttpContext.Current.Server.MapPath("~/App_Data/SmtpErrors.log");

                if (string.IsNullOrWhiteSpace(mappedPath))
                {
                    return;
                }

                string line = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " | " + message + Environment.NewLine;
                File.AppendAllText(mappedPath, line);
            }
            catch
            {
                // Avoid throwing from logger.
            }
        }
    }
}

