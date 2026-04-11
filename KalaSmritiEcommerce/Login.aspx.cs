using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;
using System.Web;

public partial class Login : Page
{
    private void SafeRedirect(string url)
    {
        Response.Redirect(url, false);
        Context.ApplicationInstance.CompleteRequest();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // If user is already logged in, redirect to home
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                SafeRedirect("~/Default.aspx");
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        try
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Query to check user credentials
            string query = @"SELECT CustomerID, FirstName, LastName, IsAdmin, Password 
                           FROM Customer 
                           WHERE Email = @Email";

            SqlParameter[] parameters = {
                new SqlParameter("@Email", email)
            };

            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                string storedPassword = row["Password"].ToString();

                if (KalaSmriti.PasswordSecurity.VerifyPassword(password, storedPassword))
                {
                    // Update last login
                    string updateQuery = "UPDATE Customer SET LastLogin = GETDATE() WHERE Email = @Email";
                    SqlParameter[] updateParameters = {
                        new SqlParameter("@Email", email)
                    };
                    KalaSmriti.DBHelper.ExecuteNonQuery(updateQuery, updateParameters);

                    // Create authentication cookie
                    FormsAuthentication.SetAuthCookie(email, chkRememberMe.Checked);

                    // Store user info in session
                    Session["CustomerID"] = row["CustomerID"];
                    Session["FirstName"] = row["FirstName"];
                    Session["LastName"] = row["LastName"];
                    Session["IsAdmin"] = Convert.ToBoolean(row["IsAdmin"]);

                    // Redirect based on user role
                    string returnUrl = Request.QueryString["ReturnUrl"];
                    
                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        SafeRedirect(returnUrl);
                    }
                    else if (Convert.ToBoolean(row["IsAdmin"]))
                    {
                        SafeRedirect("~/Admin/Dashboard.aspx");
                    }
                    else
                    {
                        SafeRedirect("~/Default.aspx");
                    }
                }
                else
                {
                    ShowError("Invalid email or password. Please try again.");
                }
            }
            else
            {
                ShowError("Invalid email or password. Please try again.");
            }
        }
        catch (Exception ex)
        {
            ShowError("An error occurred during login. Please try again later.");
            System.Diagnostics.Debug.WriteLine("Login error: " + ex.Message);
        }
    }

    protected void btnForgotPassword_Click(object sender, EventArgs e)
    {
        string email = txtEmail.Text.Trim();

        if (string.IsNullOrWhiteSpace(email))
        {
            ShowError("Please enter your Registry Email first.");
            return;
        }

        try
        {
            string query = @"SELECT TOP 1 CustomerID, FirstName
                             FROM Customer
                             WHERE Email = @Email";

            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] { new SqlParameter("@Email", email) });

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                int customerId = Convert.ToInt32(row["CustomerID"]);
                string firstName = row["FirstName"] == DBNull.Value ? string.Empty : row["FirstName"].ToString();
                string token = KalaSmriti.PasswordResetService.CreateResetToken(customerId);
                string resetUrl = Request.Url.GetLeftPart(UriPartial.Authority)
                    + ResolveUrl("~/ResetPassword.aspx?token=")
                    + Server.UrlEncode(token);

                KalaSmriti.NotificationService.SendPasswordResetLinkEmail(email, firstName, resetUrl);
            }

            // Neutral message prevents account discovery by email probing.
            ShowInfo("If the email is registered, recovery instructions were sent.");
        }
        catch (Exception ex)
        {
            ShowError("Unable to process the request right now. Please try again later.");
            System.Diagnostics.Debug.WriteLine("Forgot password error: " + ex.Message);
        }
    }

    private void ShowError(string message)
    {
        lblError.Text = message;
        pnlError.Visible = true;
        pnlInfo.Visible = false;
    }

    private void ShowInfo(string message)
    {
        lblInfo.Text = message;
        pnlInfo.Visible = true;
        pnlError.Visible = false;
    }
}

