using System;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Account
{
    public partial class AccountDetails : Page
    {
        readonly UserService _svc = new UserService(); 

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/Auth/Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadProfile();
        }

        private void LoadProfile()
        {
            int userId = (int)Session["UserID"];
            var row = _svc.GetUserById(userId);
            if (row == null) return;

            string fullName = row["full_name"].ToString();
            string[] parts = fullName.Trim().Split(new char[]{' '}, 2);
            txtFirstName.Text = parts[0];
            txtLastName.Text  = parts.Length > 1 ? parts[1] : "";
            txtEmail.Text     = row["email"].ToString();
            txtRole.Text      = row["user_type"].ToString();
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            int userId    = (int)Session["UserID"];
            string first  = txtFirstName.Text.Trim();
            string last   = txtLastName.Text.Trim();
            string full   = (first + " " + last).Trim();

            bool ok = _svc.UpdateUserName(userId, full);
            if (ok)
            {
                Session["UserName"] = full;
                ShowSuccess("Profile updated successfully.");
                LoadProfile();
            }
            else
            {
                ShowError("Could not update profile. Please try again.");
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            int userId      = (int)Session["UserID"];
            string current  = txtCurrentPassword.Text;
            string newPw    = txtNewPassword.Text;

            bool ok = _svc.ChangePassword(userId, current, newPw);
            if (ok)
            {
                txtCurrentPassword.Text = "";
                txtNewPassword.Text     = "";
                txtConfirmPassword.Text = "";
                ShowSuccess("Password changed successfully.");
            }
            else
            {
                ShowError("Current password is incorrect.");
            }
        }

        private void ShowSuccess(string msg)
        {
            litSuccess.Text    = msg;
            pnlSuccess.Visible = true;
            pnlError.Visible   = false;
        }

        private void ShowError(string msg)
        {
            litError.Text      = msg;
            pnlError.Visible   = true;
            pnlSuccess.Visible = false;
        }
    }
}