using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web;

public partial class Register : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (HttpContext.Current.User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Default.aspx");
            }
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        if (!chkTerms.Checked)
        {
            ShowError("Agreement to terms is required.");
            return;
        }

        try
        {
            string email = txtEmail.Text.Trim();

            if (KalaSmriti.DBHelper.RecordExists("Customer", "Email", email))
            {
                ShowError("This email is already registered.");
                return;
            }

            // --- Handle Profile Image Upload ---
            string profileImagePath = "~/Uploads/Profiles/default-user.png"; // Fallback image

            if (fuProfileImage.HasFile)
            {
                try
                {
                    string extension = Path.GetExtension(fuProfileImage.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png" };

                    if (Array.IndexOf(allowedExtensions, extension) != -1)
                    {
                        // Create directory if missing
                        string folderPath = Server.MapPath("~/Uploads/Profiles/");
                        if (!Directory.Exists(folderPath))
                        {
                            Directory.CreateDirectory(folderPath);
                        }

                        // Generate unique filename
                        string uniqueName = Guid.NewGuid().ToString() + extension;
                        fuProfileImage.SaveAs(folderPath + uniqueName);
                        profileImagePath = "~/Uploads/Profiles/" + uniqueName;
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("File upload error: " + ex.Message);
                    // We continue even if upload fails, just using the default image
                }
            }

            // Insert Query including ProfileImage column
            string query = @"INSERT INTO Customer 
                (FirstName, LastName, Email, Password, Phone, Address, City, State, ZipCode, Country, ProfileImage, IsAdmin, CreatedDate) 
                VALUES 
                (@FirstName, @LastName, @Email, @Password, @Phone, @Address, @City, @State, @ZipCode, @Country, @ProfileImage, 0, GETDATE())";

            SqlParameter[] parameters = {
                new SqlParameter("@FirstName", txtFirstName.Text.Trim()),
                new SqlParameter("@LastName", txtLastName.Text.Trim()),
                new SqlParameter("@Email", email),
                new SqlParameter("@Password", KalaSmriti.PasswordSecurity.HashPassword(txtPassword.Text.Trim())),
                new SqlParameter("@Phone", string.IsNullOrEmpty(txtPhone.Text) ? (object)DBNull.Value : txtPhone.Text.Trim()),
                new SqlParameter("@Address", string.IsNullOrEmpty(txtAddress.Text) ? (object)DBNull.Value : txtAddress.Text.Trim()),
                new SqlParameter("@City", string.IsNullOrEmpty(txtCity.Text) ? (object)DBNull.Value : txtCity.Text.Trim()),
                new SqlParameter("@State", string.IsNullOrEmpty(txtState.Text) ? (object)DBNull.Value : txtState.Text.Trim()),
                new SqlParameter("@ZipCode", string.IsNullOrEmpty(txtZipCode.Text) ? (object)DBNull.Value : txtZipCode.Text.Trim()),
                new SqlParameter("@Country", string.IsNullOrEmpty(txtCountry.Text) ? "Nepal" : txtCountry.Text.Trim()),
                new SqlParameter("@ProfileImage", profileImagePath)
            };

            int result = KalaSmriti.DBHelper.ExecuteNonQuery(query, parameters);

            if (result > 0)
            {
                ShowSuccess("Registry created successfully. Redirecting...");
                ClearForm();
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
            else
            {
                ShowError("Registration failed. Please try again.");
            }
        }
        catch (Exception ex)
        {
            ShowError("A connection error occurred.");
            System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
        }
    }

    private void ShowError(string message)
    {
        lblError.Text = message;
        pnlError.Visible = true;
        pnlSuccess.Visible = false;
    }

    private void ShowSuccess(string message)
    {
        lblSuccess.Text = message;
        pnlSuccess.Visible = true;
        pnlError.Visible = false;
    }

    private void ClearForm()
    {
        txtFirstName.Text = "";
        txtLastName.Text = "";
        txtEmail.Text = "";
        txtPhone.Text = "";
        txtPassword.Text = "";
        txtConfirmPassword.Text = "";
        txtAddress.Text = "";
        txtCity.Text = "";
        txtState.Text = "";
        txtZipCode.Text = "";
        txtCountry.Text = "Nepal";
        chkTerms.Checked = false;
    }
}