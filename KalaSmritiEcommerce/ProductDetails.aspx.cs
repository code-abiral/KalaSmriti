using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class ProductDetails : Page
{
    private int ProductId
    {
        get
        {
            int productId;
            return int.TryParse(Request.QueryString["id"], out productId) ? productId : 0;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProduct();
        }
    }

    private void LoadProduct()
    {
        if (ProductId <= 0)
        {
            ShowNotFound();
            return;
        }

        try
        {
            string query = @"SELECT p.ProductID, p.ProductName, p.Description, p.Price, p.DiscountPrice,
                            p.ImageUrl, p.StockQuantity, c.CategoryName
                            FROM Product p
                            INNER JOIN Category c ON p.CategoryID = c.CategoryID
                            WHERE p.ProductID = @ProductID AND p.IsActive = 1";

            SqlParameter[] parameters = { new SqlParameter("@ProductID", ProductId) };
            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);

            if (dt.Rows.Count == 0)
            {
                ShowNotFound();
                return;
            }

            DataRow row = dt.Rows[0];
            decimal price = Convert.ToDecimal(row["Price"]);
            decimal discountPrice = row["DiscountPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(row["DiscountPrice"]);
            int stock = Convert.ToInt32(row["StockQuantity"]);

            lblProductName.Text = row["ProductName"].ToString();
            lblCategory.Text = row["CategoryName"].ToString();
            lblDescription.Text = row["Description"].ToString();
            imgProduct.ImageUrl = ResolveUrl(row["ImageUrl"].ToString());
            imgProduct.AlternateText = row["ProductName"].ToString();

            if (discountPrice > 0)
            {
                lblPrice.Text = "Rs. " + discountPrice.ToString("N2");
                lblOriginalPrice.Text = "Rs. " + price.ToString("N2");
            }
            else
            {
                lblPrice.Text = "Rs. " + price.ToString("N2");
                lblOriginalPrice.Text = string.Empty;
            }

            if (stock > 0)
            {
                lblStock.Text = "In stock (" + stock + ")";
                lblStock.CssClass = "ml-2 text-green-600 font-semibold";
                btnAddToCart.Enabled = true;
                btnAddToCart.CssClass = "bg-amber-600 text-white px-6 py-3 rounded-lg hover:bg-amber-700 transition font-semibold";
            }
            else
            {
                lblStock.Text = "Out of stock";
                lblStock.CssClass = "ml-2 text-red-600 font-semibold";
                btnAddToCart.Enabled = false;
                btnAddToCart.CssClass = "bg-gray-300 text-gray-500 px-6 py-3 rounded-lg cursor-not-allowed font-semibold";
            }

            LoadReviewSummary(ProductId);
            LoadReviews(ProductId);

            pnlProduct.Visible = true;
            pnlNotFound.Visible = false;
        }
        catch
        {
            ShowNotFound();
        }
    }

    protected void btnAddToCart_Click(object sender, EventArgs e)
    {
        if (ProductId <= 0)
        {
            ShowMessage("Invalid product.", true);
            return;
        }

        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        try
        {
            string email = HttpContext.Current.User.Identity.Name;

            string customerQuery = "SELECT CustomerID FROM Customer WHERE Email = @Email";
            SqlParameter[] customerParams = { new SqlParameter("@Email", email) };
            object customerIdObj = KalaSmriti.DBHelper.ExecuteScalar(customerQuery, customerParams);

            if (customerIdObj == null)
            {
                ShowMessage("User account not found.", true);
                return;
            }

            int customerId = Convert.ToInt32(customerIdObj);

            string stockQuery = "SELECT StockQuantity FROM Product WHERE ProductID = @ProductID";
            SqlParameter[] stockParams = { new SqlParameter("@ProductID", ProductId) };
            int stock = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(stockQuery, stockParams));

            if (stock <= 0)
            {
                ShowMessage("This product is out of stock.", true);
                return;
            }

            string checkQuery = "SELECT Quantity FROM Cart WHERE CustomerID = @CustomerID AND ProductID = @ProductID";
            SqlParameter[] checkParams = {
                new SqlParameter("@CustomerID", customerId),
                new SqlParameter("@ProductID", ProductId)
            };
            object quantityObj = KalaSmriti.DBHelper.ExecuteScalar(checkQuery, checkParams);

            if (quantityObj != null && quantityObj != DBNull.Value)
            {
                int quantity = Convert.ToInt32(quantityObj);
                if (quantity + 1 > stock)
                {
                    ShowMessage("Cannot add more items than available stock.", true);
                    return;
                }

                string updateQuery = "UPDATE Cart SET Quantity = @Quantity WHERE CustomerID = @CustomerID AND ProductID = @ProductID";
                SqlParameter[] updateParams = {
                    new SqlParameter("@Quantity", quantity + 1),
                    new SqlParameter("@CustomerID", customerId),
                    new SqlParameter("@ProductID", ProductId)
                };
                KalaSmriti.DBHelper.ExecuteNonQuery(updateQuery, updateParams);
            }
            else
            {
                string insertQuery = "INSERT INTO Cart (CustomerID, ProductID, Quantity, AddedDate) VALUES (@CustomerID, @ProductID, 1, GETDATE())";
                SqlParameter[] insertParams = {
                    new SqlParameter("@CustomerID", customerId),
                    new SqlParameter("@ProductID", ProductId)
                };
                KalaSmriti.DBHelper.ExecuteNonQuery(insertQuery, insertParams);
            }

            ShowMessage("Added to cart successfully.", false);
        }
        catch
        {
            ShowMessage("Unable to add product to cart.", true);
        }
    }

    private void ShowNotFound()
    {
        pnlProduct.Visible = false;
        pnlNotFound.Visible = true;
    }

    private void LoadReviewSummary(int productId)
    {
        string query = @"SELECT ISNULL(AVG(CAST(Rating AS DECIMAL(10,2))), 0) AS AverageRating,
                                COUNT(*) AS ReviewCount
                         FROM Review
                         WHERE ProductID = @ProductID AND IsApproved = 1";

        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] { new SqlParameter("@ProductID", productId) });
        if (dt.Rows.Count == 0)
        {
            lblAverageRating.Text = "No ratings yet";
            lblRatingSummary.Text = string.Empty;
            return;
        }

        decimal average = Convert.ToDecimal(dt.Rows[0]["AverageRating"]);
        int count = Convert.ToInt32(dt.Rows[0]["ReviewCount"]);

        lblAverageRating.Text = count > 0
            ? string.Format("{0:0.0}/5 {1}", average, GetStars((int)Math.Round(average)))
            : "No ratings yet";
        lblRatingSummary.Text = count > 0 ? count + " review" + (count == 1 ? string.Empty : "s") : string.Empty;
    }

    private void LoadReviews(int productId)
    {
        string query = @"SELECT TOP 10 r.Rating, r.ReviewText, r.ReviewDate, c.FirstName
                         FROM Review r
                         INNER JOIN Customer c ON c.CustomerID = r.CustomerID
                         WHERE r.ProductID = @ProductID AND r.IsApproved = 1
                         ORDER BY r.ReviewDate DESC";

        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] { new SqlParameter("@ProductID", productId) });
        rptReviews.DataSource = dt;
        rptReviews.DataBind();
        pnlNoReviews.Visible = dt.Rows.Count == 0;
    }

    protected string GetStars(int rating)
    {
        if (rating < 0) rating = 0;
        if (rating > 5) rating = 5;

        return new string('\u2605', rating) + new string('\u2606', 5 - rating);
    }

    private void ShowMessage(string message, bool isError)
    {
        pnlMessage.Visible = true;
        lblMessage.Text = message;
        pnlMessage.CssClass = isError
            ? "mt-4 p-3 rounded-lg bg-red-100 text-red-700"
            : "mt-4 p-3 rounded-lg bg-green-100 text-green-700";
    }
}

