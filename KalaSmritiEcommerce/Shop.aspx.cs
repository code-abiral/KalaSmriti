using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;

public partial class Shop : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategories();
            ApplyQueryStringFilters();
            LoadProducts();
        }
    }

    private void ApplyQueryStringFilters()
    {
        string search = Request.QueryString["search"];

        if (!string.IsNullOrWhiteSpace(search))
        {
            txtSearch.Text = search.Trim();
        }
    }

    /// <summary>
    /// Load categories for filter dropdown
    /// </summary>
    private void LoadCategories()
    {
        try
        {
            System.Diagnostics.Debug.WriteLine("[Shop] Loading categories...");
            string query = "SELECT CategoryID, CategoryName FROM Category WHERE IsActive = 1 ORDER BY CategoryName";
            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
            
            System.Diagnostics.Debug.WriteLine("[Shop] Categories loaded: " + dt.Rows.Count);

            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "CategoryName";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("All Categories", ""));

            // Check if category parameter exists in URL
            if (!string.IsNullOrEmpty(Request.QueryString["category"]))
            {
                ddlCategory.SelectedValue = Request.QueryString["category"];
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("[Shop] ERROR loading categories: " + ex.Message);
            // Show error on page
            if (pnlNoResults != null)
            {
                pnlNoResults.Visible = true;
            }
        }
    }

    /// <summary>
    /// Load products with filters
    /// </summary>
    private void LoadProducts()
    {
        try
        {
            // Build inner query that ensures one row per ProductID using ROW_NUMBER().
            StringBuilder inner = new StringBuilder();
            inner.Append(@"SELECT p.ProductID, p.ProductName, p.Description, p.Price, ISNULL(p.DiscountPrice, 0) AS DiscountPrice, 
                          p.ImageUrl, p.IsFeatured, p.StockQuantity, c.CategoryName, p.CreatedDate,
                          ROW_NUMBER() OVER (PARTITION BY p.ProductID ORDER BY ");

            // Prefer newest rows by CreatedDate, fallback to ProductID
            string rowNumberOrder = "p.CreatedDate DESC, p.ProductID DESC";
            inner.Append(rowNumberOrder + ") AS rn FROM Product p INNER JOIN Category c ON p.CategoryID = c.CategoryID WHERE p.IsActive = 1");

            // Apply search filter inside inner query
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                inner.Append(" AND (p.ProductName LIKE @Search OR p.Description LIKE @Search)");
            }

            // Apply category filter inside inner query
            if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
            {
                inner.Append(" AND p.CategoryID = @CategoryID");
            }

            // Apply price range filter inside inner query
            if (!string.IsNullOrEmpty(ddlPriceRange.SelectedValue))
            {
                string[] priceRange = ddlPriceRange.SelectedValue.Split('-');
                if (priceRange.Length == 2)
                {
                    inner.Append(" AND (CASE WHEN p.DiscountPrice > 0 THEN p.DiscountPrice ELSE p.Price END) BETWEEN @MinPrice AND @MaxPrice");
                }
            }

            // Build outer query selecting only rn = 1
            StringBuilder finalQuery = new StringBuilder();
            finalQuery.Append("SELECT ProductID, ProductName, Description, Price, DiscountPrice, ImageUrl, IsFeatured, StockQuantity, CategoryName FROM (");
            finalQuery.Append(inner.ToString());
            finalQuery.Append(") t WHERE rn = 1");

            // Apply sorting on outer query
            switch (ddlSortBy.SelectedValue)
            {
                case "price_asc":
                    finalQuery.Append(" ORDER BY CASE WHEN DiscountPrice > 0 THEN DiscountPrice ELSE Price END ASC");
                    break;
                case "price_desc":
                    finalQuery.Append(" ORDER BY CASE WHEN DiscountPrice > 0 THEN DiscountPrice ELSE Price END DESC");
                    break;
                case "name_asc":
                    finalQuery.Append(" ORDER BY ProductName ASC");
                    break;
                default: // newest
                    finalQuery.Append(" ORDER BY CreatedDate DESC");
                    break;
            }

            // Create parameters
            System.Collections.Generic.List<SqlParameter> parameters = new System.Collections.Generic.List<SqlParameter>();

            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                parameters.Add(new SqlParameter("@Search", "%" + txtSearch.Text.Trim() + "%"));
            }

            if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
            {
                parameters.Add(new SqlParameter("@CategoryID", ddlCategory.SelectedValue));
            }

            if (!string.IsNullOrEmpty(ddlPriceRange.SelectedValue))
            {
                string[] priceRange = ddlPriceRange.SelectedValue.Split('-');
                if (priceRange.Length == 2)
                {
                    parameters.Add(new SqlParameter("@MinPrice", decimal.Parse(priceRange[0])));
                    parameters.Add(new SqlParameter("@MaxPrice", decimal.Parse(priceRange[1])));
                }
            }

            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(finalQuery.ToString(), parameters.ToArray());

            if (dt.Rows.Count > 0)
            {
                rptProducts.DataSource = dt;
                rptProducts.DataBind();
                pnlNoResults.Visible = false;

                lblResultsCount.Text = string.Format("Showing {0} product{1}", dt.Rows.Count, (dt.Rows.Count != 1 ? "s" : ""));
            }
            else
            {
                rptProducts.DataSource = null;
                rptProducts.DataBind();
                pnlNoResults.Visible = true;
                lblResultsCount.Text = "No products found";
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("[Shop] ERROR loading products: " + ex.Message);
            System.Diagnostics.Debug.WriteLine("[Shop] Stack trace: " + ex.StackTrace);
            pnlNoResults.Visible = true;
            lblResultsCount.Text = "Unable to load products right now.";
        }
    }

    /// <summary>
    /// Apply filters when any filter changes
    /// </summary>
    protected void ApplyFilters(object sender, EventArgs e)
    {
        LoadProducts();
    }

    /// <summary>
    /// Reset all filters
    /// </summary>
    protected void ResetFilters_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        ddlCategory.SelectedIndex = 0;
        ddlPriceRange.SelectedIndex = 0;
        ddlSortBy.SelectedIndex = 0;
        LoadProducts();
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

                // Check stock
                string stockQuery = "SELECT StockQuantity FROM Product WHERE ProductID = @ProductID";
                SqlParameter[] stockParams = { new SqlParameter("@ProductID", productId) };
                int stock = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(stockQuery, stockParams));

                if (stock == 0)
                {
                    // Product out of stock
                    return;
                }

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
                    
                    // Check if adding one more exceeds stock
                    if (currentQty + 1 <= stock)
                    {
                        string updateQuery = "UPDATE Cart SET Quantity = @Quantity WHERE CustomerID = @CustomerID AND ProductID = @ProductID";
                        SqlParameter[] updateParams = {
                            new SqlParameter("@Quantity", currentQty + 1),
                            new SqlParameter("@CustomerID", customerId),
                            new SqlParameter("@ProductID", productId)
                        };
                        KalaSmriti.DBHelper.ExecuteNonQuery(updateQuery, updateParams);
                    }
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

                // Refresh page
                Response.Redirect(Request.RawUrl);
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error adding to cart: " + ex.Message);
        }
    }

    protected string GetProductImageUrl(object imageUrlValue)
    {
        string relativePath = Convert.ToString(imageUrlValue);

        if (string.IsNullOrWhiteSpace(relativePath))
        {
            return ResolveUrl("~/Images/placeholder.jpg");
        }

        return ResolveUrl(relativePath);
    }
}

