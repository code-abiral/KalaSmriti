using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_ManageUsers : Page
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
            LoadUsers();
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

    private void LoadUsers()
    {
        string query = @"SELECT CustomerID, FirstName, LastName, FirstName + ' ' + LastName AS FullName, Email, Phone, IsAdmin, CreatedDate
                         FROM Customer
                         ORDER BY CreatedDate DESC";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query);
        gvUsers.DataSource = dt;
        gvUsers.DataBind();
    }

    protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
            return;

        DropDownList ddlIsAdmin = e.Row.FindControl("ddlIsAdmin") as DropDownList;
        HiddenField hfIsAdmin = e.Row.FindControl("hfIsAdmin") as HiddenField;

        if (ddlIsAdmin != null && hfIsAdmin != null)
        {
            ListItem item = ddlIsAdmin.Items.FindByValue(hfIsAdmin.Value);
            if (item != null)
            {
                ddlIsAdmin.ClearSelection();
                item.Selected = true;
            }
        }
    }

    protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int rowIndex;
        if (!int.TryParse(e.CommandArgument.ToString(), out rowIndex))
            return;

        int customerId = Convert.ToInt32(gvUsers.DataKeys[rowIndex].Value);

        if (e.CommandName == "EditUser")
        {
            BeginEditUser(customerId);
            return;
        }

        if (e.CommandName == "UpdateUserRole")
        {
            GridViewRow row = gvUsers.Rows[rowIndex];
            DropDownList ddlIsAdmin = row.FindControl("ddlIsAdmin") as DropDownList;

            if (ddlIsAdmin == null)
                return;

            try
            {
                bool isAdmin = ddlIsAdmin.SelectedValue == "1";
                string query = "UPDATE Customer SET IsAdmin = @IsAdmin WHERE CustomerID = @CustomerID";
                SqlParameter[] parameters = {
                    new SqlParameter("@IsAdmin", isAdmin),
                    new SqlParameter("@CustomerID", customerId)
                };

                KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);
                ShowMessage("User role updated.", false);
                LoadUsers();
            }
            catch (Exception ex)
            {
                ShowMessage("Unable to update user role: " + ex.Message, true);
            }

            return;
        }

        if (e.CommandName == "DeleteUser")
        {
            try
            {
                string ownUserQuery = "SELECT CustomerID FROM Customer WHERE Email = @Email";
                object ownIdObj = KalaSmriti.DBHelper.ExecuteScalar(ownUserQuery, new[] { new SqlParameter("@Email", HttpContext.Current.User.Identity.Name) });
                if (ownIdObj != null && Convert.ToInt32(ownIdObj) == customerId)
                {
                    ShowMessage("You cannot delete your own account while logged in.", true);
                    return;
                }

                int orderCount = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar("SELECT COUNT(*) FROM [Order] WHERE CustomerID = @CustomerID", new[] { new SqlParameter("@CustomerID", customerId) }));
                if (orderCount > 0)
                {
                    ShowMessage("Cannot delete this user because they have orders.", true);
                    return;
                }

                KalaSmriti.DBHelper.ExecuteNonQuery(@"IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notification]') AND type in (N'U'))
DELETE FROM Notification WHERE CustomerID = @CustomerID", new[] { new SqlParameter("@CustomerID", customerId) });
                KalaSmriti.DBHelper.ExecuteNonQuery("DELETE FROM Review WHERE CustomerID = @CustomerID", new[] { new SqlParameter("@CustomerID", customerId) });
                KalaSmriti.DBHelper.ExecuteNonQuery("DELETE FROM Cart WHERE CustomerID = @CustomerID", new[] { new SqlParameter("@CustomerID", customerId) });
                KalaSmriti.DBHelper.ExecuteNonQuery("DELETE FROM Customer WHERE CustomerID = @CustomerID", new[] { new SqlParameter("@CustomerID", customerId) });

                ShowMessage("User deleted successfully.", false);
                LoadUsers();
            }
            catch (Exception ex)
            {
                ShowMessage("Unable to delete user: " + ex.Message, true);
            }
        }
    }

    protected void btnAddUser_Click(object sender, EventArgs e)
    {
        if (!ValidateForm(isNewUser: true))
        {
            return;
        }

        try
        {
            string existingQuery = "SELECT COUNT(*) FROM Customer WHERE Email = @Email";
            int exists = Convert.ToInt32(KalaSmriti.DBHelper.ExecuteScalar(existingQuery, new[] { new SqlParameter("@Email", txtEmail.Text.Trim()) }));
            if (exists > 0)
            {
                ShowMessage("An account with this email already exists.", true);
                return;
            }

            string query = @"INSERT INTO Customer (FirstName, LastName, Email, Password, Phone, IsAdmin, CreatedDate)
                             VALUES (@FirstName, @LastName, @Email, @Password, @Phone, @IsAdmin, GETDATE())";
            SqlParameter[] parameters = {
                new SqlParameter("@FirstName", txtFirstName.Text.Trim()),
                new SqlParameter("@LastName", txtLastName.Text.Trim()),
                new SqlParameter("@Email", txtEmail.Text.Trim()),
                new SqlParameter("@Password", txtPassword.Text.Trim()),
                new SqlParameter("@Phone", txtPhone.Text.Trim()),
                new SqlParameter("@IsAdmin", ddlFormRole.SelectedValue == "1")
            };

            KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);
            ClearForm();
            LoadUsers();
            ShowMessage("User created successfully.", false);
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to create user: " + ex.Message, true);
        }
    }

    protected void btnUpdateUser_Click(object sender, EventArgs e)
    {
        int customerId;
        if (!int.TryParse(hfEditingCustomerId.Value, out customerId) || customerId <= 0)
        {
            ShowMessage("No user selected for update.", true);
            return;
        }

        if (!ValidateForm(isNewUser: false))
        {
            return;
        }

        try
        {
            string query = @"UPDATE Customer
                             SET FirstName = @FirstName,
                                 LastName = @LastName,
                                 Email = @Email,
                                 Phone = @Phone,
                                 IsAdmin = @IsAdmin
                             WHERE CustomerID = @CustomerID";
            SqlParameter[] parameters = {
                new SqlParameter("@FirstName", txtFirstName.Text.Trim()),
                new SqlParameter("@LastName", txtLastName.Text.Trim()),
                new SqlParameter("@Email", txtEmail.Text.Trim()),
                new SqlParameter("@Phone", txtPhone.Text.Trim()),
                new SqlParameter("@IsAdmin", ddlFormRole.SelectedValue == "1"),
                new SqlParameter("@CustomerID", customerId)
            };

            KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);

            if (!string.IsNullOrWhiteSpace(txtPassword.Text.Trim()))
            {
                KalaSmriti.DBHelper.ExecuteNonQuery("UPDATE Customer SET Password = @Password WHERE CustomerID = @CustomerID",
                    new[] {
                        new SqlParameter("@Password", txtPassword.Text.Trim()),
                        new SqlParameter("@CustomerID", customerId)
                    });
            }

            ExitEditMode();
            LoadUsers();
            ShowMessage("User updated successfully.", false);
        }
        catch (Exception ex)
        {
            ShowMessage("Unable to update user: " + ex.Message, true);
        }
    }

    protected void btnCancelUserEdit_Click(object sender, EventArgs e)
    {
        ExitEditMode();
    }

    private bool ValidateForm(bool isNewUser)
    {
        if (string.IsNullOrWhiteSpace(txtFirstName.Text) ||
            string.IsNullOrWhiteSpace(txtLastName.Text) ||
            string.IsNullOrWhiteSpace(txtEmail.Text))
        {
            ShowMessage("First name, last name, and email are required.", true);
            return false;
        }

        if (isNewUser && string.IsNullOrWhiteSpace(txtPassword.Text))
        {
            ShowMessage("Password is required for a new user.", true);
            return false;
        }

        return true;
    }

    private void BeginEditUser(int customerId)
    {
        string query = "SELECT CustomerID, FirstName, LastName, Email, Phone, IsAdmin FROM Customer WHERE CustomerID = @CustomerID";
        DataTable dt = KalaSmriti.DBHelper.ExecuteQuery(query, new[] { new SqlParameter("@CustomerID", customerId) });
        if (dt.Rows.Count == 0)
        {
            ShowMessage("User not found.", true);
            return;
        }

        DataRow row = dt.Rows[0];
        hfEditingCustomerId.Value = row["CustomerID"].ToString();
        txtFirstName.Text = row["FirstName"].ToString();
        txtLastName.Text = row["LastName"].ToString();
        txtEmail.Text = row["Email"].ToString();
        txtPhone.Text = row["Phone"] == DBNull.Value ? string.Empty : row["Phone"].ToString();
        ddlFormRole.SelectedValue = Convert.ToBoolean(row["IsAdmin"]) ? "1" : "0";
        txtPassword.Text = string.Empty;

        btnAddUser.Visible = false;
        btnUpdateUser.Visible = true;
        btnCancelUserEdit.Visible = true;
    }

    private void ExitEditMode()
    {
        hfEditingCustomerId.Value = string.Empty;
        ClearForm();
        btnAddUser.Visible = true;
        btnUpdateUser.Visible = false;
        btnCancelUserEdit.Visible = false;
    }

    private void ClearForm()
    {
        txtFirstName.Text = string.Empty;
        txtLastName.Text = string.Empty;
        txtEmail.Text = string.Empty;
        txtPhone.Text = string.Empty;
        txtPassword.Text = string.Empty;
        ddlFormRole.SelectedValue = "0";
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

