using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_ManageOrders : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
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
            LoadOrders();
        }
    }

    private bool IsUserAdmin()
    {
        try
        {
            string email = HttpContext.Current.User.Identity.Name;
            string query = "SELECT IsAdmin FROM Customer WHERE Email = @Email";
            SqlParameter[] parameters = { new SqlParameter("@Email", email) };
            object result = KalaSmriti.DBHelper.ExecuteScalar(query, parameters);
            return result != null && Convert.ToBoolean(result);
        }
        catch
        {
            return false;
        }
    }

    private void LoadOrders()
    {
        string query = @"SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName, o.OrderDate, o.TotalAmount, o.OrderStatus, o.PaymentStatus
                         FROM [Order] o
                         INNER JOIN Customer c ON o.CustomerID = c.CustomerID
                         ORDER BY o.OrderDate DESC";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
        gvOrders.DataSource = dt;
        gvOrders.DataBind();
    }

    protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
            return;

        DropDownList ddlOrderStatus = e.Row.FindControl("ddlOrderStatus") as DropDownList;
        DropDownList ddlPaymentStatus = e.Row.FindControl("ddlPaymentStatus") as DropDownList;
        HiddenField hfOrderStatus = e.Row.FindControl("hfOrderStatus") as HiddenField;
        HiddenField hfPaymentStatus = e.Row.FindControl("hfPaymentStatus") as HiddenField;

        if (ddlOrderStatus != null && hfOrderStatus != null)
        {
            string normalizedStatus = hfOrderStatus.Value;
            if (string.Equals(normalizedStatus, "Shipped", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(normalizedStatus, "Processing", StringComparison.OrdinalIgnoreCase))
            {
                normalizedStatus = "Out for Delivery";
            }
            else if (string.Equals(normalizedStatus, "Cancelled", StringComparison.OrdinalIgnoreCase))
            {
                normalizedStatus = "Canceled";
            }

            ListItem orderStatusItem = ddlOrderStatus.Items.FindByValue(normalizedStatus);
            if (orderStatusItem != null)
            {
                ddlOrderStatus.ClearSelection();
                orderStatusItem.Selected = true;
            }
        }

        if (ddlPaymentStatus != null && hfPaymentStatus != null)
        {
            ListItem paymentStatusItem = ddlPaymentStatus.Items.FindByValue(hfPaymentStatus.Value);
            if (paymentStatusItem != null)
            {
                ddlPaymentStatus.ClearSelection();
                paymentStatusItem.Selected = true;
            }
        }
    }

    protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "UpdateOrder")
            return;

        int rowIndex = Convert.ToInt32(e.CommandArgument);
        int orderId = Convert.ToInt32(gvOrders.DataKeys[rowIndex].Value);
        GridViewRow row = gvOrders.Rows[rowIndex];
        DropDownList ddlOrderStatus = row.FindControl("ddlOrderStatus") as DropDownList;
        DropDownList ddlPaymentStatus = row.FindControl("ddlPaymentStatus") as DropDownList;

        if (ddlOrderStatus == null || ddlPaymentStatus == null)
            return;

        try
        {
            string query = "UPDATE [Order] SET OrderStatus = @OrderStatus, PaymentStatus = @PaymentStatus WHERE OrderID = @OrderID";
            SqlParameter[] parameters = {
                new SqlParameter("@OrderStatus", ddlOrderStatus.SelectedValue),
                new SqlParameter("@PaymentStatus", ddlPaymentStatus.SelectedValue),
                new SqlParameter("@OrderID", orderId)
            };

            KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);

            int customerId = GetOrderCustomerId(orderId);
            if (customerId > 0)
            {
                string email = GetCustomerEmail(customerId);
                string message = "Order #" + orderId + " updated. Status: " + ddlOrderStatus.SelectedValue + ", Payment: " + ddlPaymentStatus.SelectedValue + ".";
                KalaSmriti.NotificationService.SendOrderNotification(customerId, email, "Order status updated", message);
            }

            ShowMessage("Order updated successfully.", false);
            LoadOrders();
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to update order: " + ex.Message, true);
        }
    }

    private int GetOrderCustomerId(int orderId)
    {
        string query = "SELECT CustomerID FROM [Order] WHERE OrderID = @OrderID";
        object result = KalaSmriti.DBHelper.ExecuteScalar(query, new[] { new SqlParameter("@OrderID", orderId) });
        return result == null ? 0 : Convert.ToInt32(result);
    }

    private string GetCustomerEmail(int customerId)
    {
        string query = "SELECT Email FROM Customer WHERE CustomerID = @CustomerID";
        object result = KalaSmriti.DBHelper.ExecuteScalar(query, new[] { new SqlParameter("@CustomerID", customerId) });
        return result == null ? string.Empty : result.ToString();
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

