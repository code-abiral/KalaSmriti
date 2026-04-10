using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;

public partial class Admin_ManageProducts : Page
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
            LoadCategories();
            LoadProducts();
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

    private void LoadProducts()
    {
        string query = @"SELECT p.ProductID, p.ProductName, p.Description, p.CategoryID, c.CategoryName, p.Price, p.DiscountPrice, p.StockQuantity, p.ImageUrl, p.IsActive
                         FROM Product p
                         INNER JOIN Category c ON p.CategoryID = c.CategoryID
                         ORDER BY p.CreatedDate DESC";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
        gvProducts.DataSource = dt;
        gvProducts.DataBind();
    }

    private void LoadCategories()
    {
        string query = "SELECT CategoryID, CategoryName FROM Category ORDER BY CategoryName";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
        ddlCategory.DataSource = dt;
        ddlCategory.DataTextField = "CategoryName";
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataBind();
        ddlCategory.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Category", ""));
    }

    protected void btnAddProduct_Click(object sender, EventArgs e)
    {
        try
        {
            ProductFormData formData;
            if (!TryBuildFormData(out formData))
            {
                return;
            }

            string query = @"INSERT INTO Product
                             (ProductName, Description, Price, DiscountPrice, CategoryID, StockQuantity, ImageUrl, IsActive, IsFeatured, CreatedDate)
                             VALUES
                             (@ProductName, @Description, @Price, @DiscountPrice, @CategoryID, @StockQuantity, @ImageUrl, 1, 0, GETDATE())";

            SqlParameter[] parameters = {
                new SqlParameter("@ProductName", formData.ProductName),
                new SqlParameter("@Description", formData.Description),
                new SqlParameter("@Price", formData.Price),
                new SqlParameter("@DiscountPrice", formData.DiscountPrice > 0 ? (object)formData.DiscountPrice : DBNull.Value),
                new SqlParameter("@CategoryID", formData.CategoryId),
                new SqlParameter("@StockQuantity", formData.StockQuantity),
                new SqlParameter("@ImageUrl", formData.ImageUrl)
            };

            KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);
            ClearForm();
            LoadProducts();
            ShowMessage("Product added successfully.", false);
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to add product: " + ex.Message, true);
        }
    }

    protected void btnUpdateProduct_Click(object sender, EventArgs e)
    {
        int productId;
        if (!int.TryParse(hfEditingProductId.Value, out productId) || productId <= 0)
        {
            ShowMessage("No product selected for update.", true);
            return;
        }

        try
        {
            ProductFormData formData;
            if (!TryBuildFormData(out formData))
            {
                return;
            }

            string query = @"UPDATE Product
                             SET ProductName = @ProductName,
                                 Description = @Description,
                                 Price = @Price,
                                 DiscountPrice = @DiscountPrice,
                                 CategoryID = @CategoryID,
                                 StockQuantity = @StockQuantity,
                                 ImageUrl = @ImageUrl,
                                 ModifiedDate = GETDATE()
                             WHERE ProductID = @ProductID";

            SqlParameter[] parameters = {
                new SqlParameter("@ProductName", formData.ProductName),
                new SqlParameter("@Description", formData.Description),
                new SqlParameter("@Price", formData.Price),
                new SqlParameter("@DiscountPrice", formData.DiscountPrice > 0 ? (object)formData.DiscountPrice : DBNull.Value),
                new SqlParameter("@CategoryID", formData.CategoryId),
                new SqlParameter("@StockQuantity", formData.StockQuantity),
                new SqlParameter("@ImageUrl", formData.ImageUrl),
                new SqlParameter("@ProductID", productId)
            };

            KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);
            ExitEditMode();
            LoadProducts();
            ShowMessage("Product updated successfully.", false);
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to update product: " + ex.Message, true);
        }
    }

    protected void btnCancelEdit_Click(object sender, EventArgs e)
    {
        ExitEditMode();
    }

    protected void gvProducts_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int rowIndex;
        if (!int.TryParse(e.CommandArgument.ToString(), out rowIndex))
        {
            return;
        }

        int productId = Convert.ToInt32(gvProducts.DataKeys[rowIndex].Value);

        if (e.CommandName == "EditProduct")
        {
            BeginEdit(productId);
            return;
        }

        try
        {
            if (e.CommandName == "DeleteProduct")
            {
                string cartCheck = "SELECT COUNT(*) FROM Cart WHERE ProductID = @ProductID";
                int cartRefs = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(cartCheck, new[] { new SqlParameter("@ProductID", productId) }));
                if (cartRefs > 0)
                {
                    KalaSmriti.DBHelper.ExecuteNonQuery("DELETE FROM Cart WHERE ProductID = @ProductID", new[] { new SqlParameter("@ProductID", productId) });
                }

                string orderItemCheck = "SELECT COUNT(*) FROM Order_Item WHERE ProductID = @ProductID";
                int orderRefs = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(orderItemCheck, new[] { new SqlParameter("@ProductID", productId) }));
                if (orderRefs > 0)
                {
                    ShowMessage("This product is used in orders and cannot be deleted. Set it inactive instead.", true);
                    return;
                }

                KalaSmriti.DBHelper.ExecuteNonQuery("DELETE FROM Review WHERE ProductID = @ProductID", new[] { new SqlParameter("@ProductID", productId) });
                KalaSmriti.DBHelper.ExecuteNonQuery("DELETE FROM Product WHERE ProductID = @ProductID", new[] { new SqlParameter("@ProductID", productId) });
                ShowMessage("Product deleted successfully.", false);
            }
            else if (e.CommandName == "ToggleProductActive")
            {
                string query = "UPDATE Product SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE ProductID = @ProductID";
                KalaSmriti.DBHelper.ExecuteNonQuery(query, new[] { new SqlParameter("@ProductID", productId) });
                ShowMessage("Product active status updated.", false);
            }

            LoadProducts();
        }
        catch (Exception ex)
        {
            ShowMessage("Operation failed: " + ex.Message, true);
        }
    }

    private void BeginEdit(int productId)
    {
        string query = @"SELECT ProductID, ProductName, Description, Price, DiscountPrice, CategoryID, StockQuantity
                         FROM Product WHERE ProductID = @ProductID";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] { new SqlParameter("@ProductID", productId) });
        if (dt.Rows.Count == 0)
        {
            ShowMessage("Product not found.", true);
            return;
        }

        DataRow row = dt.Rows[0];
        hfEditingProductId.Value = row["ProductID"].ToString();
        txtProductName.Text = row["ProductName"].ToString();
        txtDescription.Text = row["Description"] == DBNull.Value ? string.Empty : row["Description"].ToString();
        txtPrice.Text = Convert.ToDecimal(row["Price"]).ToString("0.##");
        txtDiscountPrice.Text = row["DiscountPrice"] == DBNull.Value ? string.Empty : Convert.ToDecimal(row["DiscountPrice"]).ToString("0.##");
        txtStockQuantity.Text = row["StockQuantity"].ToString();
        ddlCategory.SelectedValue = row["CategoryID"].ToString();

        btnAddProduct.Visible = false;
        btnUpdateProduct.Visible = true;
        btnCancelEdit.Visible = true;
    }

    private void ExitEditMode()
    {
        hfEditingProductId.Value = string.Empty;
        ClearForm();
        btnAddProduct.Visible = true;
        btnUpdateProduct.Visible = false;
        btnCancelEdit.Visible = false;
    }

    private bool TryBuildFormData(out ProductFormData data)
    {
        data = null;

        string productName = txtProductName.Text.Trim();
        string description = txtDescription.Text.Trim();

        if (string.IsNullOrEmpty(productName) || string.IsNullOrEmpty(ddlCategory.SelectedValue) ||
            string.IsNullOrEmpty(txtPrice.Text.Trim()) || string.IsNullOrEmpty(txtStockQuantity.Text.Trim()))
        {
            ShowMessage("Product name, category, price, and stock are required.", true);
            return false;
        }

        decimal price;
        if (!decimal.TryParse(txtPrice.Text.Trim(), out price) || price < 0)
        {
            ShowMessage("Enter a valid price.", true);
            return false;
        }

        int stockQuantity;
        if (!int.TryParse(txtStockQuantity.Text.Trim(), out stockQuantity) || stockQuantity < 0)
        {
            ShowMessage("Enter a valid stock quantity.", true);
            return false;
        }

        decimal discountPrice = 0;
        if (!string.IsNullOrEmpty(txtDiscountPrice.Text.Trim()))
        {
            if (!decimal.TryParse(txtDiscountPrice.Text.Trim(), out discountPrice) || discountPrice < 0)
            {
                ShowMessage("Enter a valid discount price.", true);
                return false;
            }
        }

        string imageUrl = GetCurrentImageIfEditing();
        if (string.IsNullOrWhiteSpace(imageUrl))
        {
            imageUrl = "/Images/placeholder.jpg";
        }

        if (fuProductImage.HasFile)
        {
            string extension = Path.GetExtension(fuProductImage.FileName).ToLowerInvariant();
            if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".webp")
            {
                ShowMessage("Only JPG, JPEG, PNG, and WEBP images are allowed.", true);
                return false;
            }

            string productsFolder = Server.MapPath("~/Images/products/");
            if (!Directory.Exists(productsFolder))
            {
                Directory.CreateDirectory(productsFolder);
            }

            string fileName = "product_" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + extension;
            string fullPath = Path.Combine(productsFolder, fileName);
            fuProductImage.SaveAs(fullPath);
            imageUrl = "/Images/products/" + fileName;
        }

        data = new ProductFormData
        {
            ProductName = productName,
            Description = description,
            Price = price,
            DiscountPrice = discountPrice,
            CategoryId = Convert.ToInt32(ddlCategory.SelectedValue),
            StockQuantity = stockQuantity,
            ImageUrl = imageUrl
        };

        return true;
    }

    private string GetCurrentImageIfEditing()
    {
        int productId;
        if (!int.TryParse(hfEditingProductId.Value, out productId) || productId <= 0)
        {
            return string.Empty;
        }

        string query = "SELECT ImageUrl FROM Product WHERE ProductID = @ProductID";
        object result = KalaSmriti.DBHelper.ExecuteScalar(query, new[] { new SqlParameter("@ProductID", productId) });
        return result == null || result == DBNull.Value ? string.Empty : result.ToString();
    }

    private class ProductFormData
    {
        public string ProductName { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public decimal DiscountPrice { get; set; }
        public int CategoryId { get; set; }
        public int StockQuantity { get; set; }
        public string ImageUrl { get; set; }
    }

    private void ClearForm()
    {
        txtProductName.Text = string.Empty;
        txtDescription.Text = string.Empty;
        txtPrice.Text = string.Empty;
        txtDiscountPrice.Text = string.Empty;
        txtStockQuantity.Text = string.Empty;
        ddlCategory.SelectedIndex = 0;
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

