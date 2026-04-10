using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class ProfilePage : Page
{
    private int customerId;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        customerId = GetCustomerId();
        if (customerId == 0)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadProfile();
        }
    }

    private int GetCustomerId()
    {
        string email = HttpContext.Current.User.Identity.Name;
        string query = "SELECT CustomerID FROM Customer WHERE Email = @Email";
        SqlParameter[] parameters = { new SqlParameter("@Email", email) };
        object result = KalaSmriti.DBHelper.ExecuteScalar(query, parameters);
        return result == null ? 0 : Convert.ToInt32(result);
    }

    private void LoadProfile()
    {
        string query = @"SELECT FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country
                         FROM Customer WHERE CustomerID = @CustomerID";
        SqlParameter[] parameters = { new SqlParameter("@CustomerID", customerId) };
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);
        if (dt.Rows.Count == 0) return;

        DataRow row = dt.Rows[0];
        txtFirstName.Text = row["FirstName"].ToString();
        txtLastName.Text = row["LastName"].ToString();
        txtEmail.Text = row["Email"].ToString();
        txtPhone.Text = row["Phone"] == DBNull.Value ? string.Empty : row["Phone"].ToString();
        txtAddress.Text = row["Address"] == DBNull.Value ? string.Empty : row["Address"].ToString();
        txtCity.Text = row["City"] == DBNull.Value ? string.Empty : row["City"].ToString();
        txtState.Text = row["State"] == DBNull.Value ? string.Empty : row["State"].ToString();
        txtZip.Text = row["ZipCode"] == DBNull.Value ? string.Empty : row["ZipCode"].ToString();
        txtCountry.Text = row["Country"] == DBNull.Value ? string.Empty : row["Country"].ToString();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            string query = @"UPDATE Customer SET
                             FirstName = @FirstName,
                             LastName = @LastName,
                             Phone = @Phone,
                             Address = @Address,
                             City = @City,
                             State = @State,
                             ZipCode = @ZipCode,
                             Country = @Country
                             WHERE CustomerID = @CustomerID";

            SqlParameter[] parameters = {
                new SqlParameter("@FirstName", txtFirstName.Text.Trim()),
                new SqlParameter("@LastName", txtLastName.Text.Trim()),
                new SqlParameter("@Phone", txtPhone.Text.Trim()),
                new SqlParameter("@Address", txtAddress.Text.Trim()),
                new SqlParameter("@City", txtCity.Text.Trim()),
                new SqlParameter("@State", txtState.Text.Trim()),
                new SqlParameter("@ZipCode", txtZip.Text.Trim()),
                new SqlParameter("@Country", txtCountry.Text.Trim()),
                new SqlParameter("@CustomerID", customerId)
            };

            KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);
            ShowMessage("Profile updated successfully.", false);
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to update profile: " + ex.Message, true);
        }
    }

    private void ShowMessage(string message, bool isError)
    {
        pnlMessage.Visible = true;
        lblMessage.Text = message;
        pnlMessage.CssClass = isError
            ? "mb-4 p-3 rounded-lg bg-red-100 text-red-700"
            : "mb-4 p-3 rounded-lg bg-green-100 text-green-700";
    }
}

