using System;
using System.Web.UI;

public partial class ResetPassword : Page
{
    private string ResetToken
    {
        get
        {
            return (ViewState["ResetToken"] as string) ?? string.Empty;
        }
        set
        {
            ViewState["ResetToken"] = value ?? string.Empty;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            return;
        }

        string token = Request.QueryString["token"];
        if (string.IsNullOrWhiteSpace(token) || !KalaSmriti.PasswordResetService.IsTokenValid(token))
        {
            pnlForm.Visible = false;
            ShowMessage("This reset link is invalid or expired.", true);
            return;
        }

        ResetToken = token;
    }

    protected void btnResetPassword_Click(object sender, EventArgs e)
    {
        string token = ResetToken;
        if (string.IsNullOrWhiteSpace(token))
        {
            pnlForm.Visible = false;
            ShowMessage("This reset link is invalid or expired.", true);
            return;
        }

        string newPassword = txtNewPassword.Text.Trim();
        string confirmPassword = txtConfirmPassword.Text.Trim();

        if (newPassword.Length < 8)
        {
            ShowMessage("Password must be at least 8 characters.", true);
            return;
        }

        if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
        {
            ShowMessage("Passwords do not match.", true);
            return;
        }

        bool resetDone = KalaSmriti.PasswordResetService.TryResetPassword(token, newPassword);
        if (!resetDone)
        {
            pnlForm.Visible = false;
            ShowMessage("This reset link is invalid, expired, or already used.", true);
            return;
        }

        pnlForm.Visible = false;
        ShowMessage("Password reset successful. You can now log in.", false);
    }

    private void ShowMessage(string message, bool isError)
    {
        pnlMessage.Visible = true;
        lblMessage.Text = message;
        pnlMessage.CssClass = isError
            ? "p-4 bg-red-50 border-l-2 border-red-700 text-red-800 text-[10px] font-bold uppercase tracking-widest"
            : "p-4 bg-emerald-50 border-l-2 border-emerald-700 text-emerald-800 text-[10px] font-bold uppercase tracking-widest";
    }
}
