using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

public partial class Checkout : Page
{
    private const string EsewaSignedFields = "total_amount,transaction_uuid,product_code";

    private int customerId;
    private decimal subtotal;
    private decimal shipping;
    private decimal total;

    protected void Page_Load(object sender, EventArgs e)
    {
        // eSewa appends ?data=BASE64 to whatever success URL we provide.
        // So we use a clean success URL and detect the return by the presence of "data" + a session key.
        if (!string.IsNullOrWhiteSpace(Request["data"]) && Session["EsewaPendingOrderId"] != null)
        {
            HandleEsewaReturn();
            return;
        }

        if (string.Equals(Request["esewaReturn"], "failure", StringComparison.OrdinalIgnoreCase)
            && Session["EsewaPendingOrderId"] != null)
        {
            HandleEsewaReturn();
            return;
        }

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
            rblPaymentMethod.SelectedValue = "COD";
            TogglePaymentPanels();
            LoadCustomerAddress();
            LoadCartSummary();
        }
        else
        {
            LoadCartSummary();
        }
    }

    protected void btnPlaceOrder_Click(object sender, EventArgs e)
    {
        DataTable cartItems = LoadCartSummary();
        if (cartItems.Rows.Count == 0)
        {
            ShowMessage("Your cart is empty.", true);
            return;
        }

        if (string.IsNullOrWhiteSpace(txtAddress.Text) || string.IsNullOrWhiteSpace(txtCity.Text))
        {
            ShowMessage("Address and city are required.", true);
            return;
        }

        string selectedPaymentMethod = rblPaymentMethod.SelectedValue;

        try
        {
            string transactionUuid = selectedPaymentMethod == "ESEWA"
                ? "ORD-" + Guid.NewGuid().ToString("N").Substring(0, 12).ToUpperInvariant()
                : null;

            int orderId = CreateOrder(customerId, total, "Pending");
            CreateOrderItems(orderId, cartItems);
            CreatePaymentRecord(orderId, selectedPaymentMethod, total, "Pending", transactionUuid);

            if (selectedPaymentMethod == "COD")
            {
                UpdateStockFromOrder(orderId);
                ClearCart(customerId);
                SendOrderNotificationSafe(customerId, orderId, "Order placed successfully", "Your Cash on Delivery order has been placed and payment is pending until delivery.");
                ShowMessage("Order placed successfully. You can view it in My Orders.", false);
                LoadCartSummary();
                return;
            }

            SendOrderNotificationSafe(customerId, orderId, "eSewa payment initiated", "Your order was created. Complete eSewa payment to confirm your order.");

            RedirectToEsewa(orderId, transactionUuid, total);
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to place order: " + ex.Message, true);
        }
    }

    protected void rblPaymentMethod_SelectedIndexChanged(object sender, EventArgs e)
    {
        TogglePaymentPanels();
    }

    private int GetCustomerId()
    {
        string email = HttpContext.Current.User.Identity.Name;
        string query = "SELECT CustomerID FROM Customer WHERE Email = @Email";
        SqlParameter[] parameters = { new SqlParameter("@Email", email) };
        object result = KalaSmriti.DBHelper.ExecuteScalar(query, parameters);
        return result == null ? 0 : Convert.ToInt32(result);
    }

    private void LoadCustomerAddress()
    {
        string query = "SELECT Address, City, State, ZipCode, Country FROM Customer WHERE CustomerID = @CustomerID";
        SqlParameter[] parameters = { new SqlParameter("@CustomerID", customerId) };
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);
        if (dt.Rows.Count == 0) return;

        DataRow row = dt.Rows[0];
        txtAddress.Text = row["Address"] == DBNull.Value ? string.Empty : row["Address"].ToString();
        txtCity.Text = row["City"] == DBNull.Value ? string.Empty : row["City"].ToString();
        txtState.Text = row["State"] == DBNull.Value ? string.Empty : row["State"].ToString();
        txtZip.Text = row["ZipCode"] == DBNull.Value ? string.Empty : row["ZipCode"].ToString();
        txtCountry.Text = row["Country"] == DBNull.Value ? "Nepal" : row["Country"].ToString();
    }

    private DataTable LoadCartSummary()
    {
        string query = @"SELECT c.ProductID, p.ProductName, c.Quantity,
                         (CASE WHEN p.DiscountPrice > 0 THEN p.DiscountPrice ELSE p.Price END) AS UnitPrice,
                         c.Quantity * (CASE WHEN p.DiscountPrice > 0 THEN p.DiscountPrice ELSE p.Price END) AS LineTotal
                         FROM Cart c
                         INNER JOIN Product p ON p.ProductID = c.ProductID
                         WHERE c.CustomerID = @CustomerID";
        SqlParameter[] parameters = { new SqlParameter("@CustomerID", customerId) };
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, parameters);

        rptItems.DataSource = dt;
        rptItems.DataBind();

        subtotal = 0;
        foreach (DataRow row in dt.Rows)
        {
            subtotal += Convert.ToDecimal(row["LineTotal"]);
        }

        shipping = subtotal > 5000 ? 0 : 200;
        total = subtotal + shipping;

        lblSubtotal.Text = subtotal.ToString("N2");
        lblShipping.Text = shipping == 0 ? "FREE" : "Rs. " + shipping.ToString("N2");
        lblTotal.Text = total.ToString("N2");

        return dt;
    }

    private int CreateOrder(int localCustomerId, decimal orderTotal, string paymentStatus)
    {
        string orderQuery = @"INSERT INTO [Order]
                              (CustomerID, OrderDate, TotalAmount, OrderStatus, PaymentStatus, ShippingAddress, ShippingCity, ShippingState, ShippingZipCode, ShippingCountry)
                              VALUES
                              (@CustomerID, GETDATE(), @TotalAmount, 'Pending', @PaymentStatus, @ShippingAddress, @ShippingCity, @ShippingState, @ShippingZipCode, @ShippingCountry);
                              SELECT CAST(SCOPE_IDENTITY() AS INT);";

        SqlParameter[] orderParams = {
            new SqlParameter("@CustomerID", localCustomerId),
            new SqlParameter("@TotalAmount", orderTotal),
            new SqlParameter("@PaymentStatus", paymentStatus),
            new SqlParameter("@ShippingAddress", txtAddress.Text.Trim()),
            new SqlParameter("@ShippingCity", txtCity.Text.Trim()),
            new SqlParameter("@ShippingState", txtState.Text.Trim()),
            new SqlParameter("@ShippingZipCode", txtZip.Text.Trim()),
            new SqlParameter("@ShippingCountry", txtCountry.Text.Trim())
        };

        return Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(orderQuery, orderParams));
    }

    private void CreateOrderItems(int orderId, DataTable cartItems)
    {
        foreach (DataRow row in cartItems.Rows)
        {
            int productId = Convert.ToInt32(row["ProductID"]);
            int qty = Convert.ToInt32(row["Quantity"]);
            decimal unitPrice = Convert.ToDecimal(row["UnitPrice"]);
            decimal lineTotal = Convert.ToDecimal(row["LineTotal"]);

            string itemQuery = @"INSERT INTO Order_Item (OrderID, ProductID, Quantity, UnitPrice, TotalPrice)
                                 VALUES (@OrderID, @ProductID, @Quantity, @UnitPrice, @TotalPrice)";
            SqlParameter[] itemParams = {
                new SqlParameter("@OrderID", orderId),
                new SqlParameter("@ProductID", productId),
                new SqlParameter("@Quantity", qty),
                new SqlParameter("@UnitPrice", unitPrice),
                new SqlParameter("@TotalPrice", lineTotal)
            };
            KalaSmriti.DBHelper.ExecuteNonQuery(itemQuery, itemParams);
        }
    }

    private void CreatePaymentRecord(int orderId, string paymentMethod, decimal amount, string paymentStatus, string transactionId)
    {
        string paymentQuery = @"INSERT INTO Payment (OrderID, PaymentMethod, PaymentAmount, PaymentDate, PaymentStatus, TransactionID)
                                VALUES (@OrderID, @PaymentMethod, @PaymentAmount, GETDATE(), @PaymentStatus, @TransactionID)";
        SqlParameter[] paymentParams = {
            new SqlParameter("@OrderID", orderId),
            new SqlParameter("@PaymentMethod", paymentMethod == "ESEWA" ? "eSewa" : "Cash On Delivery"),
            new SqlParameter("@PaymentAmount", amount),
            new SqlParameter("@PaymentStatus", paymentStatus),
            new SqlParameter("@TransactionID", string.IsNullOrWhiteSpace(transactionId) ? (object)DBNull.Value : transactionId)
        };
        KalaSmriti.DBHelper.ExecuteNonQuery(paymentQuery, paymentParams);
    }

    private void RedirectToEsewa(int orderId, string transactionUuid, decimal amount)
    {
        string mode = GetSetting("EsewaMode", "Sandbox");
        bool isLive = string.Equals(mode, "Live", StringComparison.OrdinalIgnoreCase);

        string formUrl = isLive
            ? GetSetting("EsewaLiveFormUrl", "https://epay.esewa.com.np/api/epay/main/v2/form")
            : GetSetting("EsewaSandboxFormUrl", "https://rc-epay.esewa.com.np/api/epay/main/v2/form");

        string productCode = isLive
            ? GetSetting("EsewaLiveProductCode", string.Empty)
            : GetSetting("EsewaSandboxProductCode", "EPAYTEST");

        string secretKey = isLive
            ? GetSetting("EsewaLiveSecretKey", string.Empty)
            : GetSetting("EsewaSandboxSecretKey", "8gBm/:&EnhH.1/q");

        if (string.IsNullOrWhiteSpace(productCode) || string.IsNullOrWhiteSpace(secretKey))
        {
            throw new Exception("eSewa settings are incomplete. Please configure product code and secret key in Web.config.");
        }

        string amountString = amount.ToString("0.00", System.Globalization.CultureInfo.InvariantCulture);
        string signatureMessage = "total_amount=" + amountString + ",transaction_uuid=" + transactionUuid + ",product_code=" + productCode;
        string signature = GenerateEsewaSignature(signatureMessage, secretKey);

        // Store orderId in session so the callback page can retrieve it.
        // Success URL must have NO query params â€” eSewa always appends ?data=BASE64,
        // so any existing ? would create a broken double-? URL.
        Session["EsewaPendingOrderId"] = orderId;
        string baseUrl = Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl("~/Checkout.aspx");
        string successUrl = baseUrl;
        string failureUrl = baseUrl + "?esewaReturn=failure";

        Dictionary<string, string> formFields = new Dictionary<string, string>
        {
            { "amount", amountString },
            { "tax_amount", "0" },
            { "total_amount", amountString },
            { "transaction_uuid", transactionUuid },
            { "product_code", productCode },
            { "product_service_charge", "0" },
            { "product_delivery_charge", "0" },
            { "success_url", successUrl },
            { "failure_url", failureUrl },
            { "signed_field_names", EsewaSignedFields },
            { "signature", signature }
        };

        PostToUrl(formUrl, formFields);
    }

    private void HandleEsewaReturn()
    {
        int orderId = Session["EsewaPendingOrderId"] != null
            ? Convert.ToInt32(Session["EsewaPendingOrderId"])
            : 0;

        if (orderId <= 0)
        {
            ShowMessage("Payment session expired. Please contact support if you were charged.", true);
            return;
        }

        if (string.Equals(Request["esewaReturn"], "failure", StringComparison.OrdinalIgnoreCase))
        {
            Session.Remove("EsewaPendingOrderId");
            MarkPaymentFailed(orderId, "Payment canceled/failed at eSewa.");
            SendOrderNotificationSafe(GetCustomerIdFromOrder(orderId), orderId, "Payment failed", "Your eSewa payment was canceled or failed. You can retry from checkout.");
            ShowMessage("Payment was canceled or failed. You can retry from checkout.", true);
            return;
        }

        string encodedData = Request["data"];
        if (string.IsNullOrWhiteSpace(encodedData))
        {
            Session.Remove("EsewaPendingOrderId");
            MarkPaymentFailed(orderId, "Missing eSewa callback data.");
            ShowMessage("Missing payment verification data from eSewa.", true);
            return;
        }

        try
        {
            EsewaCallbackData callbackData = DecodeEsewaData(encodedData);
            if (callbackData == null)
            {
                throw new Exception("Unable to parse eSewa callback data.");
            }

            PaymentContext paymentContext = GetPaymentContext(orderId);
            if (paymentContext == null)
            {
                throw new Exception("Order not found for payment verification.");
            }

            if (string.Equals(paymentContext.PaymentStatus, "Paid", StringComparison.OrdinalIgnoreCase))
            {
                ShowMessage("Payment already completed for this order.", false);
                return;
            }

            string mode = GetSetting("EsewaMode", "Sandbox");
            bool isLive = string.Equals(mode, "Live", StringComparison.OrdinalIgnoreCase);
            string statusUrlBase = isLive
                ? GetSetting("EsewaLiveStatusUrl", "https://epay.esewa.com.np/api/epay/transaction/status/")
                : GetSetting("EsewaSandboxStatusUrl", "https://rc-epay.esewa.com.np/api/epay/transaction/status/");

            string productCode = isLive
                ? GetSetting("EsewaLiveProductCode", string.Empty)
                : GetSetting("EsewaSandboxProductCode", "EPAYTEST");

            string totalAmount = paymentContext.TotalAmount.ToString("0.00", System.Globalization.CultureInfo.InvariantCulture);
            string verificationUrl = statusUrlBase + "?product_code=" + Server.UrlEncode(productCode)
                + "&total_amount=" + Server.UrlEncode(totalAmount)
                + "&transaction_uuid=" + Server.UrlEncode(paymentContext.TransactionId);

            string apiResponse = ExecuteHttpGet(verificationUrl);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            EsewaStatusResponse statusResponse = serializer.Deserialize<EsewaStatusResponse>(apiResponse);

            if (statusResponse == null || !string.Equals(statusResponse.status, "COMPLETE", StringComparison.OrdinalIgnoreCase))
            {
                MarkPaymentFailed(orderId, "eSewa verification returned non-complete status.");
                ShowMessage("eSewa payment verification failed.", true);
                return;
            }

            Session.Remove("EsewaPendingOrderId");
            MarkPaymentSuccess(orderId, string.IsNullOrWhiteSpace(callbackData.transaction_code) ? paymentContext.TransactionId : callbackData.transaction_code);
            UpdateStockFromOrder(orderId);
            ClearCart(paymentContext.CustomerId);
            SendOrderNotificationSafe(paymentContext.CustomerId, orderId, "Payment successful", "Your eSewa payment was successful and your order is now confirmed.");
            ShowMessage("eSewa payment successful. Your order has been confirmed.", false);
        }
        catch (Exception ex)
        {
            Session.Remove("EsewaPendingOrderId");
            MarkPaymentFailed(orderId, "Exception during verification: " + ex.Message);
            SendOrderNotificationSafe(GetCustomerIdFromOrder(orderId), orderId, "Payment verification issue", "We could not verify your eSewa payment automatically. Please contact support with your order number.");
            ShowMessage("Unable to verify eSewa payment: " + ex.Message, true);
        }
    }

    private int GetCustomerIdFromOrder(int orderId)
    {
        if (orderId <= 0)
        {
            return 0;
        }

        string query = "SELECT CustomerID FROM [Order] WHERE OrderID = @OrderID";
        object result = KalaSmriti.DBHelper.ExecuteScalar(query, new[] { new SqlParameter("@OrderID", orderId) });
        return result == null ? 0 : Convert.ToInt32(result);
    }

    private string GetCustomerEmailById(int localCustomerId)
    {
        if (localCustomerId <= 0)
        {
            return string.Empty;
        }

        string query = "SELECT Email FROM Customer WHERE CustomerID = @CustomerID";
        object result = KalaSmriti.DBHelper.ExecuteScalar(query, new[] { new SqlParameter("@CustomerID", localCustomerId) });
        return result == null ? string.Empty : result.ToString();
    }

    private void SendOrderNotificationSafe(int localCustomerId, int orderId, string title, string body)
    {
        if (localCustomerId <= 0)
        {
            return;
        }

        try
        {
            string email = GetCustomerEmailById(localCustomerId);
            string fullBody = "Order #" + orderId + ": " + body;
            KalaSmriti.NotificationService.SendOrderNotification(localCustomerId, email, title, fullBody);
        }
        catch
        {
            // Do not block checkout flow for notification failures.
        }
    }

    private void MarkPaymentSuccess(int orderId, string gatewayTransactionCode)
    {
        string updateOrder = "UPDATE [Order] SET PaymentStatus = 'Paid', OrderStatus = 'Confirmed' WHERE OrderID = @OrderID";
        KalaSmriti.DBHelper.ExecuteNonQuery(updateOrder, new[] { new SqlParameter("@OrderID", orderId) });

        string updatePayment = @"UPDATE Payment
                                 SET PaymentStatus = 'Paid', PaymentDate = GETDATE(), TransactionID = @TransactionID
                                 WHERE OrderID = @OrderID";
        SqlParameter[] parameters = {
            new SqlParameter("@OrderID", orderId),
            new SqlParameter("@TransactionID", gatewayTransactionCode)
        };
        KalaSmriti.DBHelper.ExecuteNonQuery(updatePayment, parameters);
    }

    private void MarkPaymentFailed(int orderId, string note)
    {
        string updateOrder = "UPDATE [Order] SET PaymentStatus = 'Failed', Notes = @Note WHERE OrderID = @OrderID";
        SqlParameter[] orderParams = {
            new SqlParameter("@OrderID", orderId),
            new SqlParameter("@Note", note)
        };
        KalaSmriti.DBHelper.ExecuteNonQuery(updateOrder, orderParams);

        string updatePayment = "UPDATE Payment SET PaymentStatus = 'Failed' WHERE OrderID = @OrderID";
        KalaSmriti.DBHelper.ExecuteNonQuery(updatePayment, new[] { new SqlParameter("@OrderID", orderId) });
    }

    private PaymentContext GetPaymentContext(int orderId)
    {
        string query = @"SELECT o.OrderID, o.CustomerID, o.TotalAmount, o.PaymentStatus, p.TransactionID
                         FROM [Order] o
                         INNER JOIN Payment p ON p.OrderID = o.OrderID
                         WHERE o.OrderID = @OrderID";

        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] { new SqlParameter("@OrderID", orderId) });
        if (dt.Rows.Count == 0)
        {
            return null;
        }

        DataRow row = dt.Rows[0];
        return new PaymentContext
        {
            OrderId = Convert.ToInt32(row["OrderID"]),
            CustomerId = Convert.ToInt32(row["CustomerID"]),
            TotalAmount = Convert.ToDecimal(row["TotalAmount"]),
            PaymentStatus = row["PaymentStatus"].ToString(),
            TransactionId = row["TransactionID"] == DBNull.Value ? string.Empty : row["TransactionID"].ToString()
        };
    }

    private void UpdateStockFromOrder(int orderId)
    {
        string updateStock = @"UPDATE p
                               SET p.StockQuantity = p.StockQuantity - oi.Quantity
                               FROM Product p
                               INNER JOIN Order_Item oi ON oi.ProductID = p.ProductID
                               WHERE oi.OrderID = @OrderID";
        KalaSmriti.DBHelper.ExecuteNonQuery(updateStock, new[] { new SqlParameter("@OrderID", orderId) });
    }

    private void ClearCart(int localCustomerId)
    {
        string clearCart = "DELETE FROM Cart WHERE CustomerID = @CustomerID";
        KalaSmriti.DBHelper.ExecuteNonQuery(clearCart, new[] { new SqlParameter("@CustomerID", localCustomerId) });
    }

    private static string GenerateEsewaSignature(string message, string secretKey)
    {
        byte[] keyBytes = Encoding.UTF8.GetBytes(secretKey);
        byte[] messageBytes = Encoding.UTF8.GetBytes(message);
        using (HMACSHA256 hmac = new HMACSHA256(keyBytes))
        {
            byte[] hash = hmac.ComputeHash(messageBytes);
            return Convert.ToBase64String(hash);
        }
    }

    private static string ExecuteHttpGet(string url)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        request.Method = "GET";
        request.Timeout = 15000;

        using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
        using (Stream responseStream = response.GetResponseStream())
        using (StreamReader reader = new StreamReader(responseStream))
        {
            return reader.ReadToEnd();
        }
    }

    private EsewaCallbackData DecodeEsewaData(string encodedData)
    {
        byte[] bytes = Convert.FromBase64String(encodedData);
        string json = Encoding.UTF8.GetString(bytes);
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        return serializer.Deserialize<EsewaCallbackData>(json);
    }

    private void PostToUrl(string url, Dictionary<string, string> formFields)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<!DOCTYPE html><html><head><meta charset='utf-8'><title>Redirecting to eSewa...</title></head><body>");
        sb.Append("<p>Redirecting to eSewa for payment...</p>");
        sb.Append("<form id='esewaForm' method='post' action='").Append(HttpUtility.HtmlAttributeEncode(url)).Append("'>");

        foreach (KeyValuePair<string, string> item in formFields)
        {
            sb.Append("<input type='hidden' name='")
              .Append(HttpUtility.HtmlAttributeEncode(item.Key))
              .Append("' value='")
              .Append(HttpUtility.HtmlAttributeEncode(item.Value))
              .Append("' />");
        }

        sb.Append("</form><script>document.getElementById('esewaForm').submit();</script></body></html>");

        Response.Clear();
        Response.ContentType = "text/html";
        Response.Write(sb.ToString());
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }

    private string GetSetting(string key, string defaultValue)
    {
        string value = ConfigurationManager.AppSettings[key];
        return string.IsNullOrWhiteSpace(value) ? defaultValue : value;
    }

    private void TogglePaymentPanels()
    {
        pnlEsewaInfo.Visible = rblPaymentMethod.SelectedValue == "ESEWA";
    }

    private void ShowMessage(string message, bool isError)
    {
        pnlMessage.Visible = true;
        lblMessage.Text = message;
        pnlMessage.CssClass = isError
            ? "mb-4 p-3 rounded-lg bg-red-100 text-red-700"
            : "mb-4 p-3 rounded-lg bg-green-100 text-green-700";
    }

    private class PaymentContext
    {
        public int OrderId { get; set; }
        public int CustomerId { get; set; }
        public decimal TotalAmount { get; set; }
        public string PaymentStatus { get; set; }
        public string TransactionId { get; set; }
    }

    private class EsewaCallbackData
    {
        public string status { get; set; }
        public string signature { get; set; }
        public string transaction_code { get; set; }
        public decimal total_amount { get; set; }
        public string transaction_uuid { get; set; }
        public string product_code { get; set; }
        public string signed_field_names { get; set; }
    }

    private class EsewaStatusResponse
    {
        public string status { get; set; }
        public string product_code { get; set; }
        public string transaction_uuid { get; set; }
        public decimal total_amount { get; set; }
    }
}

