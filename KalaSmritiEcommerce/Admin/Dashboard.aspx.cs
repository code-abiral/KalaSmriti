using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web;

public partial class Admin_Dashboard : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is authenticated and is admin
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsUserAdmin())
        {
            Response.Redirect("~/Default.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadDashboardData();
        }
    }

    /// <summary>
    /// Check if user is admin
    /// </summary>
    private bool IsUserAdmin()
    {
        try
        {
            string email = HttpContext.Current.User.Identity.Name;
            string query = "SELECT IsAdmin FROM Customer WHERE Email = @Email";
            SqlParameter[] parameters = { new SqlParameter("@Email", email) };
            
            object result = KalaSmriti.DBHelper.ExecuteScalar(query, parameters);
            
            if (result != null)
            {
                return Convert.ToBoolean(result);
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error checking admin status: " + ex.Message);
        }
        
        return false;
    }

    /// <summary>
    /// Load all dashboard statistics and data
    /// </summary>
    private void LoadDashboardData()
    {
        LoadStatistics();
        LoadRecentOrders();
        LoadLowStockProducts();
    }

    /// <summary>
    /// Load statistics cards
    /// </summary>
    private void LoadStatistics()
    {
        try
        {
            // Total Products
            string productQuery = "SELECT COUNT(*) FROM Product WHERE IsActive = 1";
            lblTotalProducts.Text = KalaSmriti.DBHelper.ExecuteScalar(productQuery, null).ToString();

            // Total Orders
            string orderQuery = "SELECT COUNT(*) FROM [Order]";
            lblTotalOrders.Text = KalaSmriti.DBHelper.ExecuteScalar(orderQuery, null).ToString();

            // Total Users (non-admin)
            string userQuery = "SELECT COUNT(*) FROM Customer WHERE IsAdmin = 0";
            lblTotalUsers.Text = KalaSmriti.DBHelper.ExecuteScalar(userQuery, null).ToString();

            // Total Revenue (delivered orders only)
            string revenueQuery = "SELECT ISNULL(SUM(TotalAmount), 0) FROM [Order] WHERE OrderStatus = 'Delivered'";
            object revenue = KalaSmriti.DBHelper.ExecuteScalar(revenueQuery, null);
            lblTotalRevenue.Text = String.Format("{0:N2}", revenue);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error loading statistics: " + ex.Message);
        }
    }

    /// <summary>
    /// Load recent orders
    /// </summary>
    private void LoadRecentOrders()
    {
        try
        {
            string query = @"SELECT TOP 5 
                           o.OrderID, 
                           c.FirstName + ' ' + c.LastName as CustomerName,
                           o.TotalAmount,
                           o.OrderStatus,
                           o.OrderDate
                           FROM [Order] o
                           INNER JOIN Customer c ON o.CustomerID = c.CustomerID
                           ORDER BY o.OrderDate DESC";

            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
            gvRecentOrders.DataSource = dt;
            gvRecentOrders.DataBind();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error loading recent orders: " + ex.Message);
        }
    }

    /// <summary>
    /// Load low stock products
    /// </summary>
    private void LoadLowStockProducts()
    {
        try
        {
            string query = @"SELECT TOP 5
                           p.ProductName,
                           p.StockQuantity,
                           c.CategoryName
                           FROM Product p
                           INNER JOIN Category c ON p.CategoryID = c.CategoryID
                           WHERE p.IsActive = 1 AND p.StockQuantity <= 5
                           ORDER BY p.StockQuantity ASC";

            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
            gvLowStock.DataSource = dt;
            gvLowStock.DataBind();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error loading low stock products: " + ex.Message);
        }
    }
}

