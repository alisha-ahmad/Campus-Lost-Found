using System;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Auth
{
    public partial class Register : Page
    {
        readonly UserService _svc = new UserService();

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = (txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim()).Trim();
            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text;
            string confirm = txtConfirmPassword.Text;
            string role = ddlRole.SelectedValue;

            if (!email.EndsWith("@lhr.nu.edu.pk"))
            {
                ShowError("Only FAST university emails (@lhr.nu.edu.pk) are allowed.");
                return;
            }
            if (password != confirm)
            {
                ShowError("Passwords do not match.");
                return;
            }
            if (password.Length < 8)
            {
                ShowError("Password must be at least 8 characters.");
                return;
            }
            if (_svc.CheckEmailExists(email))
            {
                ShowError("An account with this email already exists.");
                return;
            }
            bool ok = _svc.RegisterUser(fullName, email, password, role);
            if (ok)
            {
                var user = _svc.LoginUser(email, password);
                if (user != null)
                {
                    Session["UserID"] = (int)user["user_id"];
                    Session["UserName"] = fullName;
                    Session["UserEmail"] = email;
                    Session["UserRole"] = user["user_type"].ToString();
                }
                Response.Redirect("~/UserDashboard.aspx");
            }
            else
            {
                ShowError("Registration failed. Please try again.");
            }
        }

        private void ShowError(string msg)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = "text-danger d-block mb-3";
            lblMessage.Visible = true;
        }
    }
}