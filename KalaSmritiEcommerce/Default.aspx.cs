using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;

public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategories();
            LoadFeaturedProducts();
        }
    }

    /// <summary>
    /// Load categories for display
    /// </summary>
    private void LoadCategories()
    {
        try
        {
            System.Diagnostics.Debug.WriteLine("[Default] Loading categories...");
            string query = "SELECT TOP 6 CategoryID, CategoryName, ImageUrl FROM Category WHERE IsActive = 1 ORDER BY CategoryName";
            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
            
            System.Diagnostics.Debug.WriteLine("[Default] Categories loaded: " + dt.Rows.Count);
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("[Default] ERROR loading categories: " + ex.Message);
            System.Diagnostics.Debug.WriteLine("[Default] Stack trace: " + ex.StackTrace);
        }
    }

    /// <summary>
    /// Load featured products
    /// </summary>
    private void LoadFeaturedProducts()
    {
        try
        {
            System.Diagnostics.Debug.WriteLine("[Default] Loading featured products...");
            // Use a ROW_NUMBER() partition to ensure one row per ProductID in case the table
            // contains duplicate entries or there are multiple image rows joined elsewhere.
            string query = @"SELECT TOP 8 ProductID, ProductName, Description, Price, DiscountPrice, ImageUrl, IsFeatured, StockQuantity, CreatedDate
                        FROM (
                            SELECT ProductID, ProductName, Description, Price, ISNULL(DiscountPrice, 0) AS DiscountPrice, ImageUrl, IsFeatured, StockQuantity, CreatedDate,
                                   ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY CreatedDate DESC) AS rn
                            FROM Product
                            WHERE IsActive = 1 AND IsFeatured = 1 AND StockQuantity > 0
                        ) t
                        WHERE rn = 1
                        ORDER BY CreatedDate DESC";
            
            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
            
            System.Diagnostics.Debug.WriteLine("[Default] Featured products loaded: " + dt.Rows.Count);
            rptFeaturedProducts.DataSource = dt;
            rptFeaturedProducts.DataBind();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("[Default] ERROR loading featured products: " + ex.Message);
            System.Diagnostics.Debug.WriteLine("[Default] Stack trace: " + ex.StackTrace);
        }
    }

    /// <summary>
    /// Add product to cart
    /// </summary>
    protected void AddToCart_Command(object sender, CommandEventArgs e)
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        try
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            string email = HttpContext.Current.User.Identity.Name;

            // Get customer ID
            string customerQuery = "SELECT CustomerID FROM Customer WHERE Email = @Email";
            SqlParameter[] customerParams = { new SqlParameter("@Email", email) };
            object customerIdObj = KalaSmriti.DBHelper.ExecuteScalar(customerQuery, customerParams);

            if (customerIdObj != null)
            {
                int customerId = Convert.ToInt32(customerIdObj);

                // Check if product already in cart
                string checkQuery = "SELECT CartID, Quantity FROM Cart WHERE CustomerID = @CustomerID AND ProductID = @ProductID";
                SqlParameter[] checkParams = {
                    new SqlParameter("@CustomerID", customerId),
                    new SqlParameter("@ProductID", productId)
                };

                DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(checkQuery, checkParams);

                if (dt.Rows.Count > 0)
                {
                    // Update quantity
                    int currentQty = Convert.ToInt32(dt.Rows[0]["Quantity"]);
                    string updateQuery = "UPDATE Cart SET Quantity = @Quantity WHERE CustomerID = @CustomerID AND ProductID = @ProductID";
                    SqlParameter[] updateParams = {
                        new SqlParameter("@Quantity", currentQty + 1),
                        new SqlParameter("@CustomerID", customerId),
                        new SqlParameter("@ProductID", productId)
                    };
                    KalaSmriti.DBHelper.ExecuteNonQuery(updateQuery, updateParams);
                }
                else
                {
                    // Add new item to cart
                    string insertQuery = "INSERT INTO Cart (CustomerID, ProductID, Quantity, AddedDate) VALUES (@CustomerID, @ProductID, 1, GETDATE())";
                    SqlParameter[] insertParams = {
                        new SqlParameter("@CustomerID", customerId),
                        new SqlParameter("@ProductID", productId)
                    };
                    KalaSmriti.DBHelper.ExecuteNonQuery(insertQuery, insertParams);
                }

                // Show success message and refresh page
                Response.Redirect(Request.RawUrl);
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error adding to cart: " + ex.Message);
        }
    }
}

