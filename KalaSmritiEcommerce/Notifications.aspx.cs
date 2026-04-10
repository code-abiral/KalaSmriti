using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class Notifications : Page
{
    private int _customerId;

    protected void Page_Load(object sender, EventArgs e)
    {
        // 1. Force Login if not authenticated
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        // 2. Resolve Customer ID
        _customerId = GetCustomerId();
        if (_customerId == 0)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadNotifications();
        }
    }

    /// <summary>
    /// Fetches CustomerID based on the logged-in user's identity email
    /// </summary>
    private int GetCustomerId()
    {
        try
        {
            string email = HttpContext.Current.User.Identity.Name;
            string query = "SELECT CustomerID FROM Customer WHERE Email = @Email";
            SqlParameter[] parameters = { new SqlParameter("@Email", email) };

            object result = KalaSmriti.DBHelper.ExecuteScalar(query, parameters);
            return result == null ? 0 : Convert.ToInt32(result);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error resolving CustomerID: " + ex.Message);
            return 0;
        }
    }

    /// <summary>
    /// Binds data to the repeater and toggles the empty state panel
    /// </summary>
    private void LoadNotifications()
    {
        try
        {
            DataTable dt = KalaSmriti.NotificationService.GetUserNotifications(_customerId);

            if (dt != null)
            {
                rptNotifications.DataSource = dt;
                rptNotifications.DataBind();
                pnlEmpty.Visible = (dt.Rows.Count == 0);
            }
            else
            {
                pnlEmpty.Visible = true;
            }
        }
        catch (Exception ex)
        {
            ShowMessage("An error occurred while loading updates.", true);
            System.Diagnostics.Debug.WriteLine("LoadNotifications Error: " + ex.Message);
        }
    }

    /// <summary>
    /// Event handler to clear all unread statuses
    /// </summary>
    protected void btnMarkRead_Click(object sender, EventArgs e)
    {
        try
        {
            KalaSmriti.NotificationService.MarkAllAsRead(_customerId);

            // UI Feedback
            ShowMessage("All notifications have been cleared.", false);

            // Refresh the list
            LoadNotifications();
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to update notifications: " + ex.Message, true);
        }
    }

    /// <summary>
    /// Standardized message display logic
    /// </summary>
    private void ShowMessage(string message, bool isError)
    {
        pnlMessage.Visible = true;
        lblMessage.Text = message;

        if (isError)
        {
            pnlMessage.CssClass = "mb-6 p-4 rounded-sm text-[10px] font-bold uppercase tracking-widest shadow-sm bg-red-50 text-red-700 border border-red-100";
        }
        else
        {
            pnlMessage.CssClass = "mb-6 p-4 rounded-sm text-[10px] font-bold uppercase tracking-widest shadow-sm bg-amber-50 text-amber-800 border border-amber-100";
        }
    }
}