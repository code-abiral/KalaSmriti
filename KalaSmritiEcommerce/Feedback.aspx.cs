using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Feedback : Page
{
    private int customerId;
    private int orderId;

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

        if (!int.TryParse(Request.QueryString["orderId"], out orderId) || orderId <= 0)
        {
            ShowMessage("Invalid order reference.", true);
            pnlFeedbackForm.Visible = false;
            return;
        }

        EnsureOrderFeedbackTable();

        if (!IsValidOrderForFeedback())
        {
            ShowMessage("Feedback is only available for your delivered orders.", true);
            pnlFeedbackForm.Visible = false;
            return;
        }

        if (!IsPostBack)
        {
            LoadProducts();
            LoadExistingTransactionFeedback();
        }
    }

    protected void btnSubmitFeedback_Click(object sender, EventArgs e)
    {
        try
        {
            int submittedProductRatings = SaveProductRatings();
            bool transactionSaved = SaveTransactionRating();

            if (submittedProductRatings == 0 && !transactionSaved)
            {
                ShowMessage("Please provide at least one rating before submitting.", true);
                return;
            }

            ShowMessage("Thank you. Your feedback has been submitted.", false);
            LoadProducts();
            LoadExistingTransactionFeedback();
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to submit feedback: " + ex.Message, true);
        }
    }

    private int GetCustomerId()
    {
        string email = HttpContext.Current.User.Identity.Name;
        string query = "SELECT CustomerID FROM Customer WHERE Email = @Email";
        object result = KalaSmriti.DBHelper.ExecuteScalar(query, new[] { new SqlParameter("@Email", email) });
        return result == null ? 0 : Convert.ToInt32(result);
    }

    private bool IsValidOrderForFeedback()
    {
        string query = @"SELECT COUNT(*)
FROM [Order]
WHERE OrderID = @OrderID
  AND CustomerID = @CustomerID
  AND OrderStatus = 'Delivered'";

        int count = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(query, new[] {
            new SqlParameter("@OrderID", orderId),
            new SqlParameter("@CustomerID", customerId)
        }));

        return count > 0;
    }

    private void LoadProducts()
    {
        string query = @"SELECT oi.ProductID, p.ProductName, oi.Quantity,
       r.Rating AS ExistingRating,
       r.ReviewText AS ExistingReview
FROM Order_Item oi
INNER JOIN Product p ON p.ProductID = oi.ProductID
LEFT JOIN Review r ON r.ProductID = oi.ProductID AND r.CustomerID = @CustomerID
WHERE oi.OrderID = @OrderID
ORDER BY p.ProductName";

        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] {
            new SqlParameter("@OrderID", orderId),
            new SqlParameter("@CustomerID", customerId)
        });

        rptProducts.DataSource = dt;
        rptProducts.DataBind();

        foreach (RepeaterItem item in rptProducts.Items)
        {
            DropDownList ddlRating = item.FindControl("ddlRating") as DropDownList;
            TextBox txtReview = item.FindControl("txtReview") as TextBox;
            HiddenField hfExistingRating = item.FindControl("hfExistingRating") as HiddenField;
            HiddenField hfExistingReview = item.FindControl("hfExistingReview") as HiddenField;
            if (ddlRating == null || txtReview == null)
            {
                continue;
            }

            if (hfExistingRating != null && !string.IsNullOrWhiteSpace(hfExistingRating.Value))
            {
                string ratingValue = hfExistingRating.Value;
                ListItem selected = ddlRating.Items.FindByValue(ratingValue);
                if (selected != null)
                {
                    ddlRating.ClearSelection();
                    selected.Selected = true;
                }
            }

            txtReview.Text = hfExistingReview == null ? string.Empty : hfExistingReview.Value;
        }
    }

    private int SaveProductRatings()
    {
        int count = 0;

        foreach (RepeaterItem item in rptProducts.Items)
        {
            HiddenField hfProductId = item.FindControl("hfProductId") as HiddenField;
            DropDownList ddlRating = item.FindControl("ddlRating") as DropDownList;
            TextBox txtReview = item.FindControl("txtReview") as TextBox;

            if (hfProductId == null || ddlRating == null || txtReview == null)
            {
                continue;
            }

            int productId;
            if (!int.TryParse(hfProductId.Value, out productId) || productId <= 0)
            {
                continue;
            }

            int rating;
            if (!int.TryParse(ddlRating.SelectedValue, out rating))
            {
                continue;
            }

            string reviewText = txtReview.Text.Trim();

            string existsQuery = "SELECT COUNT(*) FROM Review WHERE ProductID = @ProductID AND CustomerID = @CustomerID";
            int exists = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(existsQuery, new[] {
                new SqlParameter("@ProductID", productId),
                new SqlParameter("@CustomerID", customerId)
            }));

            if (exists > 0)
            {
                string update = @"UPDATE Review
SET Rating = @Rating,
    ReviewText = @ReviewText,
    ReviewDate = GETDATE(),
    IsApproved = 1
WHERE ProductID = @ProductID AND CustomerID = @CustomerID";

                KalaSmriti.DBHelper.ExecuteNonQuery(update, new[] {
                    new SqlParameter("@Rating", rating),
                    new SqlParameter("@ReviewText", reviewText),
                    new SqlParameter("@ProductID", productId),
                    new SqlParameter("@CustomerID", customerId)
                });
            }
            else
            {
                string insert = @"INSERT INTO Review (ProductID, CustomerID, Rating, ReviewText, ReviewDate, IsApproved)
VALUES (@ProductID, @CustomerID, @Rating, @ReviewText, GETDATE(), 1)";

                KalaSmriti.DBHelper.ExecuteNonQuery(insert, new[] {
                    new SqlParameter("@ProductID", productId),
                    new SqlParameter("@CustomerID", customerId),
                    new SqlParameter("@Rating", rating),
                    new SqlParameter("@ReviewText", reviewText)
                });
            }

            count++;
        }

        return count;
    }

    private bool SaveTransactionRating()
    {
        int rating;
        if (!int.TryParse(ddlTransactionRating.SelectedValue, out rating))
        {
            return false;
        }

        string comment = txtTransactionComment.Text.Trim();

        string existsQuery = "SELECT COUNT(*) FROM OrderFeedback WHERE OrderID = @OrderID AND CustomerID = @CustomerID";
        int exists = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(existsQuery, new[] {
            new SqlParameter("@OrderID", orderId),
            new SqlParameter("@CustomerID", customerId)
        }));

        if (exists > 0)
        {
            string update = @"UPDATE OrderFeedback
SET Rating = @Rating,
    FeedbackText = @FeedbackText,
    FeedbackDate = GETDATE()
WHERE OrderID = @OrderID AND CustomerID = @CustomerID";

            KalaSmriti.DBHelper.ExecuteNonQuery(update, new[] {
                new SqlParameter("@Rating", rating),
                new SqlParameter("@FeedbackText", comment),
                new SqlParameter("@OrderID", orderId),
                new SqlParameter("@CustomerID", customerId)
            });
        }
        else
        {
            string insert = @"INSERT INTO OrderFeedback (OrderID, CustomerID, Rating, FeedbackText, FeedbackDate)
VALUES (@OrderID, @CustomerID, @Rating, @FeedbackText, GETDATE())";

            KalaSmriti.DBHelper.ExecuteNonQuery(insert, new[] {
                new SqlParameter("@OrderID", orderId),
                new SqlParameter("@CustomerID", customerId),
                new SqlParameter("@Rating", rating),
                new SqlParameter("@FeedbackText", comment)
            });
        }

        return true;
    }

    private void LoadExistingTransactionFeedback()
    {
        string query = "SELECT Rating, FeedbackText FROM OrderFeedback WHERE OrderID = @OrderID AND CustomerID = @CustomerID";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] {
            new SqlParameter("@OrderID", orderId),
            new SqlParameter("@CustomerID", customerId)
        });

        if (dt.Rows.Count == 0)
        {
            return;
        }

        DataRow row = dt.Rows[0];
        string rating = row["Rating"].ToString();
        ListItem selected = ddlTransactionRating.Items.FindByValue(rating);
        if (selected != null)
        {
            ddlTransactionRating.ClearSelection();
            selected.Selected = true;
        }

        txtTransactionComment.Text = row["FeedbackText"] == DBNull.Value ? string.Empty : row["FeedbackText"].ToString();
    }

    private void EnsureOrderFeedbackTable()
    {
        string query = @"IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFeedback]') AND type in (N'U'))
BEGIN
    CREATE TABLE OrderFeedback (
        OrderFeedbackID INT PRIMARY KEY IDENTITY(1,1),
        OrderID INT NOT NULL,
        CustomerID INT NOT NULL,
        Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
        FeedbackText NVARCHAR(MAX) NULL,
        FeedbackDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_OrderFeedback_Order FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
        CONSTRAINT FK_OrderFeedback_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
        CONSTRAINT UQ_OrderFeedback_OrderCustomer UNIQUE (OrderID, CustomerID)
    );
END";

        KalaSmriti.DBHelper.ExecuteNonQuery(query);
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

