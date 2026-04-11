using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;
using System.Web;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                if (HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    UpdateCartCount();
                    LoadUserProfileImage(); // Added this call
                }
                else
                {
                    if (lblCartCount != null) lblCartCount.Text = "0";
                    if (lblCartCountMobile != null) lblCartCountMobile.Text = "0";
                }
            }

            if (txtHeaderSearch != null && btnHeaderSearch != null)
            {
                txtHeaderSearch.Attributes["onkeydown"] = "if(event.key==='Enter'){event.preventDefault();document.getElementById('" + btnHeaderSearch.ClientID + "').click();}";
            }

            if (txtMobileSearch != null && btnMobileSearch != null)
            {
                txtMobileSearch.Attributes["onkeydown"] = "if(event.key==='Enter'){event.preventDefault();document.getElementById('" + btnMobileSearch.ClientID + "').click();}";
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("[SiteMaster] ERROR in Page_Load: " + ex.Message);
        }
    }

    /// <summary>
    /// Loads the user's profile image from the database for the header and mobile menu
    /// </summary>
    private void LoadUserProfileImage()
    {
        try
        {
            string email = HttpContext.Current.User.Identity.Name;
            string query = "SELECT ProfileImage FROM Customer WHERE Email = @Email";
            SqlParameter[] parameters = { new SqlParameter("@Email", email) };

            object imgPath = KalaSmriti.DBHelper.ExecuteScalar(query, parameters);

            // If an image exists in the DB, update the controls. 
            // Otherwise, they stay at the default defined in the .aspx
            if (imgPath != null && !string.IsNullOrWhiteSpace(imgPath.ToString()))
            {
                string finalPath = imgPath.ToString();

                if (imgHeaderProfile != null)
                    imgHeaderProfile.ImageUrl = finalPath;

                if (imgMobileProfile != null)
                    imgMobileProfile.ImageUrl = finalPath;
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error loading profile image: " + ex.Message);
        }
    }

    /// <summary>
    /// Update cart item count in header
    /// </summary>
    public void UpdateCartCount()
    {
        try
        {
            string email = HttpContext.Current.User.Identity.Name;

            if (string.IsNullOrWhiteSpace(email))
            {
                if (lblCartCount != null) lblCartCount.Text = "0";
                if (lblCartCountMobile != null) lblCartCountMobile.Text = "0";
                return;
            }

            string customerQuery = "SELECT CustomerID FROM Customer WHERE Email = @Email";
            SqlParameter[] customerParams = { new SqlParameter("@Email", email) };

            object customerIdObj = KalaSmriti.DBHelper.ExecuteScalar(customerQuery, customerParams);

            if (customerIdObj != null)
            {
                int customerId = Convert.ToInt32(customerIdObj);
                string cartQuery = "SELECT ISNULL(SUM(Quantity), 0) FROM Cart WHERE CustomerID = @CustomerID";
                SqlParameter[] cartParams = { new SqlParameter("@CustomerID", customerId) };

                int cartCount = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(cartQuery, cartParams));
                string countText = cartCount.ToString();
                if (lblCartCount != null) lblCartCount.Text = countText;
                if (lblCartCountMobile != null) lblCartCountMobile.Text = countText;
            }
            else
            {
                if (lblCartCount != null) lblCartCount.Text = "0";
                if (lblCartCountMobile != null) lblCartCountMobile.Text = "0";
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error updating cart count: " + ex.Message);
            if (lblCartCount != null) lblCartCount.Text = "0";
            if (lblCartCountMobile != null) lblCartCountMobile.Text = "0";
        }
    }

    protected bool IsUserAdmin()
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
            return false;

        try
        {
            string email = HttpContext.Current.User.Identity.Name;
            string query = "SELECT IsAdmin FROM Customer WHERE Email = @Email";
            SqlParameter[] parameters = { new SqlParameter("@Email", email) };

            object result = KalaSmriti.DBHelper.ExecuteScalar(query, parameters);
            return result != null && Convert.ToBoolean(result);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error checking admin status: " + ex.Message);
            return false;
        }
    }

    protected void Logout_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        Session.Clear();
        Session.Abandon();

        HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, "");
        cookie.Expires = DateTime.Now.AddYears(-1);
        Response.Cookies.Add(cookie);

        Response.Redirect("~/Default.aspx");
    }

    protected void HeaderSearch_Click(object sender, EventArgs e)
    {
        string searchTerm = string.Empty;

        if (txtHeaderSearch != null && !string.IsNullOrWhiteSpace(txtHeaderSearch.Text))
        {
            searchTerm = txtHeaderSearch.Text.Trim();
        }

        if (string.IsNullOrWhiteSpace(searchTerm) && txtMobileSearch != null && !string.IsNullOrWhiteSpace(txtMobileSearch.Text))
        {
            searchTerm = txtMobileSearch.Text.Trim();
        }

        string targetUrl = "~/Shop.aspx";

        if (!string.IsNullOrWhiteSpace(searchTerm))
        {
            targetUrl += "?search=" + Server.UrlEncode(searchTerm);
        }

        Response.Redirect(targetUrl);
    }
}