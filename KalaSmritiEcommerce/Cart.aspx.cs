using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;

public partial class Cart : Page
{
    private int customerId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
            return;
        }

        if (!IsPostBack)
        {
            GetCustomerId();
            LoadCart();
            LoadPurchaseHistory();
        }
    }

    /// <summary>
    /// Get customer ID from email
    /// </summary>
    private void GetCustomerId()
    {
        try
        {
            string email = HttpContext.Current.User.Identity.Name;
            string query = "SELECT CustomerID FROM Customer WHERE Email = @Email";
            SqlParameter[] parameters = { new SqlParameter("@Email", email) };
            
            object result = KalaSmriti.DBHelper.ExecuteScalar(query, parameters);
            if (result != null)
            {
                customerId = Convert.ToInt32(result);
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error getting customer ID: " + ex.Message);
        }
    }

    /// <summary>
    /// Load cart items
    /// </summary>
    private void LoadCart()
    {
        GetCustomerId();
        
        if (customerId == 0)
        {
            pnlPurchaseHistory.Visible = false;
            return;
        }

        try
        {
            string query = @"SELECT c.CartID, c.ProductID, c.Quantity, 
                           p.ProductName, p.ImageUrl,
                           CASE WHEN p.DiscountPrice > 0 THEN p.DiscountPrice ELSE p.Price END as UnitPrice,
                           p.StockQuantity
                           FROM Cart c
                           INNER JOIN Product p ON c.ProductID = p.ProductID
                           WHERE c.CustomerID = @CustomerID
                           ORDER BY c.AddedDate DESC";

            SqlParameter[] parameters = { new SqlParameter("@CustomerID", customerId) };
            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);

            if (dt.Rows.Count > 0)
            {
                rptCartItems.DataSource = dt;
                rptCartItems.DataBind();
                
                pnlCartItems.Visible = true;
                pnlEmptyCart.Visible = false;
                
                CalculateTotals(dt);
            }
            else
            {
                pnlCartItems.Visible = false;
                pnlEmptyCart.Visible = true;
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error loading cart: " + ex.Message);
        }

        LoadPurchaseHistory();
    }

    private void LoadPurchaseHistory()
    {
        if (customerId == 0)
        {
            pnlPurchaseHistory.Visible = false;
            return;
        }

        try
        {
            string query = @"SELECT TOP 5 OrderID, OrderDate, TotalAmount, OrderStatus
                             FROM [Order]
                             WHERE CustomerID = @CustomerID
                             ORDER BY OrderDate DESC";

            SqlParameter[] parameters = { new SqlParameter("@CustomerID", customerId) };
            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);

            rptPurchaseHistory.DataSource = dt;
            rptPurchaseHistory.DataBind();
            pnlPurchaseHistory.Visible = dt.Rows.Count > 0;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error loading purchase history: " + ex.Message);
            pnlPurchaseHistory.Visible = false;
        }
    }

    /// <summary>
    /// Calculate cart totals
    /// </summary>
    private void CalculateTotals(DataTable cartItems)
    {
        decimal subtotal = 0;
        
        foreach (DataRow row in cartItems.Rows)
        {
            decimal unitPrice = Convert.ToDecimal(row["UnitPrice"]);
            int quantity = Convert.ToInt32(row["Quantity"]);
            subtotal += unitPrice * quantity;
        }

        decimal shipping = subtotal > 5000 ? 0 : 200; // Free shipping over Rs. 5000
        decimal total = subtotal + shipping;

        lblSubtotal.Text = subtotal.ToString("N2");
        lblShipping.Text = shipping == 0 ? "FREE" : shipping.ToString("N2");
        lblTotal.Text = total.ToString("N2");
    }

    /// <summary>
    /// Update item quantity
    /// </summary>
    protected void UpdateQuantity_Command(object sender, CommandEventArgs e)
    {
        try
        {
            string[] args = e.CommandArgument.ToString().Split(',');
            int cartId = Convert.ToInt32(args[0]);
            int change = Convert.ToInt32(args[1]);

            // Get current quantity and stock
            string getQuery = @"SELECT c.Quantity, p.StockQuantity 
                              FROM Cart c 
                              INNER JOIN Product p ON c.ProductID = p.ProductID 
                              WHERE c.CartID = @CartID";
            SqlParameter[] getParams = { new SqlParameter("@CartID", cartId) };
            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(getQuery, getParams);

            if (dt.Rows.Count > 0)
            {
                int currentQty = Convert.ToInt32(dt.Rows[0]["Quantity"]);
                int stockQty = Convert.ToInt32(dt.Rows[0]["StockQuantity"]);
                int newQty = currentQty + change;

                if (newQty > 0 && newQty <= stockQty)
                {
                    string updateQuery = "UPDATE Cart SET Quantity = @Quantity WHERE CartID = @CartID";
                    SqlParameter[] updateParams = {
                        new SqlParameter("@Quantity", newQty),
                        new SqlParameter("@CartID", cartId)
                    };
                    KalaSmriti.DBHelper.ExecuteNonQuery(updateQuery, updateParams);
                }
                else if (newQty <= 0)
                {
                    // Remove item if quantity becomes 0
                    RemoveCartItem(cartId);
                }
            }

            LoadCart();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error updating quantity: " + ex.Message);
        }
    }

    /// <summary>
    /// Remove item from cart
    /// </summary>
    protected void RemoveItem_Command(object sender, CommandEventArgs e)
    {
        try
        {
            int cartId = Convert.ToInt32(e.CommandArgument);
            RemoveCartItem(cartId);
            LoadCart();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error removing item: " + ex.Message);
        }
    }

    /// <summary>
    /// Remove cart item helper
    /// </summary>
    private void RemoveCartItem(int cartId)
    {
        string query = "DELETE FROM Cart WHERE CartID = @CartID";
        SqlParameter[] parameters = { new SqlParameter("@CartID", cartId) };
        KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);
    }

    /// <summary>
    /// Proceed to checkout
    /// </summary>
    protected void Checkout_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Checkout.aspx");
    }
}

