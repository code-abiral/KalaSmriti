using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_ManageCategories : Page
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

    private void LoadCategories()
    {
        string query = "SELECT CategoryID, CategoryName, Description, IsActive, CreatedDate FROM Category ORDER BY CategoryName";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
        gvCategories.DataSource = dt;
        gvCategories.DataBind();
    }

    protected void btnAddCategory_Click(object sender, EventArgs e)
    {
        try
        {
            string categoryName = txtCategoryName.Text.Trim();
            string description = txtDescription.Text.Trim();
            string imageUrl = txtImageUrl.Text.Trim();

            if (string.IsNullOrEmpty(categoryName))
            {
                ShowMessage("Category name is required.", true);
                return;
            }

            if (string.IsNullOrEmpty(imageUrl))
            {
                imageUrl = "/Images/placeholder.jpg";
            }

            string query = @"INSERT INTO Category (CategoryName, Description, ImageUrl, IsActive, CreatedDate)
                             VALUES (@CategoryName, @Description, @ImageUrl, @IsActive, GETDATE())";

            SqlParameter[] parameters = {
                new SqlParameter("@CategoryName", categoryName),
                new SqlParameter("@Description", description),
                new SqlParameter("@ImageUrl", imageUrl),
                new SqlParameter("@IsActive", chkCategoryActive.Checked)
            };

            KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);
            txtCategoryName.Text = string.Empty;
            txtDescription.Text = string.Empty;
            txtImageUrl.Text = string.Empty;
            chkCategoryActive.Checked = true;
            LoadCategories();
            ShowMessage("Category added successfully.", false);
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to add category: " + ex.Message, true);
        }
    }

    protected void btnUpdateCategory_Click(object sender, EventArgs e)
    {
        int categoryId;
        if (!int.TryParse(hfEditingCategoryId.Value, out categoryId) || categoryId <= 0)
        {
            ShowMessage("No category selected for update.", true);
            return;
        }

        try
        {
            string categoryName = txtCategoryName.Text.Trim();
            if (string.IsNullOrEmpty(categoryName))
            {
                ShowMessage("Category name is required.", true);
                return;
            }

            string imageUrl = txtImageUrl.Text.Trim();
            if (string.IsNullOrEmpty(imageUrl))
            {
                imageUrl = "/Images/placeholder.jpg";
            }

            string query = @"UPDATE Category
                             SET CategoryName = @CategoryName,
                                 Description = @Description,
                                 ImageUrl = @ImageUrl,
                                 IsActive = @IsActive
                             WHERE CategoryID = @CategoryID";

            SqlParameter[] parameters = {
                new SqlParameter("@CategoryName", categoryName),
                new SqlParameter("@Description", txtDescription.Text.Trim()),
                new SqlParameter("@ImageUrl", imageUrl),
                new SqlParameter("@IsActive", chkCategoryActive.Checked),
                new SqlParameter("@CategoryID", categoryId)
            };

            KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);
            ExitEditMode();
            LoadCategories();
            ShowMessage("Category updated successfully.", false);
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to update category: " + ex.Message, true);
        }
    }

    protected void btnCancelCategoryEdit_Click(object sender, EventArgs e)
    {
        ExitEditMode();
    }

    protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "ToggleActive" && e.CommandName != "DeleteCategory" && e.CommandName != "EditCategory")
            return;

        int rowIndex = Convert.ToInt32(e.CommandArgument);
        int categoryId = Convert.ToInt32(gvCategories.DataKeys[rowIndex].Value);

        if (e.CommandName == "EditCategory")
        {
            BeginEdit(categoryId);
            return;
        }

        try
        {
            if (e.CommandName == "ToggleActive")
            {
                string toggleQuery = "UPDATE Category SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE CategoryID = @CategoryID";
                SqlParameter[] toggleParams = { new SqlParameter("@CategoryID", categoryId) };
                KalaSmriti.DBHelper.ExecuteNonQuery(toggleQuery, toggleParams);
                ShowMessage("Category status updated.", false);
            }
            else if (e.CommandName == "DeleteCategory")
            {
                string checkQuery = "SELECT COUNT(*) FROM Product WHERE CategoryID = @CategoryID";
                SqlParameter[] checkParams = { new SqlParameter("@CategoryID", categoryId) };
                int productCount = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(checkQuery, checkParams));

                if (productCount > 0)
                {
                    ShowMessage("Cannot delete category with existing products.", true);
                    return;
                }

                string deleteQuery = "DELETE FROM Category WHERE CategoryID = @CategoryID";
                SqlParameter[] deleteParams = { new SqlParameter("@CategoryID", categoryId) };
                KalaSmriti.DBHelper.ExecuteNonQuery(deleteQuery, deleteParams);
                ShowMessage("Category deleted.", false);
            }

            LoadCategories();
        }
        catch (Exception ex)
        {
            ShowMessage("Operation failed: " + ex.Message, true);
        }
    }

    private void BeginEdit(int categoryId)
    {
        string query = "SELECT CategoryID, CategoryName, Description, ImageUrl, IsActive FROM Category WHERE CategoryID = @CategoryID";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] { new SqlParameter("@CategoryID", categoryId) });
        if (dt.Rows.Count == 0)
        {
            ShowMessage("Category not found.", true);
            return;
        }

        DataRow row = dt.Rows[0];
        hfEditingCategoryId.Value = row["CategoryID"].ToString();
        txtCategoryName.Text = row["CategoryName"].ToString();
        txtDescription.Text = row["Description"] == DBNull.Value ? string.Empty : row["Description"].ToString();
        txtImageUrl.Text = row["ImageUrl"] == DBNull.Value ? string.Empty : row["ImageUrl"].ToString();
        chkCategoryActive.Checked = Convert.ToBoolean(row["IsActive"]);

        btnAddCategory.Visible = false;
        btnUpdateCategory.Visible = true;
        btnCancelCategoryEdit.Visible = true;
    }

    private void ExitEditMode()
    {
        hfEditingCategoryId.Value = string.Empty;
        txtCategoryName.Text = string.Empty;
        txtDescription.Text = string.Empty;
        txtImageUrl.Text = string.Empty;
        chkCategoryActive.Checked = true;

        btnAddCategory.Visible = true;
        btnUpdateCategory.Visible = false;
        btnCancelCategoryEdit.Visible = false;
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

