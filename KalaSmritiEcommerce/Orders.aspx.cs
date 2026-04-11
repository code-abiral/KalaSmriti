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
            pnlOrdersContent.Visible = false;
            pnlNoOrders.Visible = true;
            return;
        }

        string query = @"SELECT OrderID, OrderDate, TotalAmount, OrderStatus, PaymentStatus
                         FROM [Order]
                         WHERE CustomerID = @CustomerID
                         ORDER BY OrderDate DESC";
        SqlParameter[] parameters = { new SqlParameter("@CustomerID", Convert.ToInt32(customerIdObj)) };
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);

        bool hasOrders = dt != null && dt.Rows.Count > 0;
        pnlOrdersContent.Visible = hasOrders;
        pnlNoOrders.Visible = !hasOrders;

        gvOrders.DataSource = dt;
        gvOrders.DataBind();

        rptOrdersMobile.DataSource = dt;
        rptOrdersMobile.DataBind();
    }

    public string GetOrderStatusCss(object statusValue)
    {
        string status = Convert.ToString(statusValue).Trim().ToLower();

        if (status == "delivered")
            return "inline-flex px-3 py-1 text-[9px] font-bold uppercase tracking-widest bg-emerald-50 text-emerald-700 border border-emerald-200";

        if (status == "cancelled")
            return "inline-flex px-3 py-1 text-[9px] font-bold uppercase tracking-widest bg-red-50 text-red-700 border border-red-200";

        if (status == "shipped")
            return "inline-flex px-3 py-1 text-[9px] font-bold uppercase tracking-widest bg-blue-50 text-blue-700 border border-blue-200";

        return "inline-flex px-3 py-1 text-[9px] font-bold uppercase tracking-widest bg-amber-50 text-amber-800 border border-amber-200";
    }

    public string GetPaymentStatusCss(object statusValue)
    {
        string status = Convert.ToString(statusValue).Trim().ToLower();

        if (status == "paid" || status == "completed" || status == "success")
            return "inline-flex px-3 py-1 text-[9px] font-bold uppercase tracking-widest bg-emerald-50 text-emerald-700 border border-emerald-200";

        if (status == "failed" || status == "refunded")
            return "inline-flex px-3 py-1 text-[9px] font-bold uppercase tracking-widest bg-red-50 text-red-700 border border-red-200";

        return "inline-flex px-3 py-1 text-[9px] font-bold uppercase tracking-widest bg-stone-50 text-stone-600 border border-stone-200";
    }
}

