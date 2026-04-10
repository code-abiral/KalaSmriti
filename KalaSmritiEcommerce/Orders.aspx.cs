using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class Orders : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        if (!IsPostBack)
        {
            LoadOrders();
        }
    }

    private void LoadOrders()
    {
        string email = HttpContext.Current.User.Identity.Name;
        string customerQuery = "SELECT CustomerID FROM Customer WHERE Email = @Email";
        SqlParameter[] customerParams = { new SqlParameter("@Email", email) };
        object customerIdObj = KalaSmriti.DBHelper.ExecuteScalar(customerQuery, customerParams);

        if (customerIdObj == null)
        {
            gvOrders.DataSource = null;
            gvOrders.DataBind();
            return;
        }

        string query = @"SELECT OrderID, OrderDate, TotalAmount, OrderStatus, PaymentStatus
                         FROM [Order]
                         WHERE CustomerID = @CustomerID
                         ORDER BY OrderDate DESC";
        SqlParameter[] parameters = { new SqlParameter("@CustomerID", Convert.ToInt32(customerIdObj)) };
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);

        gvOrders.DataSource = dt;
        gvOrders.DataBind();
    }
}

