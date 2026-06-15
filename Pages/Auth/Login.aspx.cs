using System;
using System.Web;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Auth
{
    public partial class Login : Page
    {
        readonly UserService _svc = new UserService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserID"] != null)
                RedirectByRole(Session["UserRole"]?.ToString());
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text.Trim();
            var user = _svc.LoginUser(email, password);
            if (user == null)
            {
                lblMessage.Text = "Invalid email or password.";
                lblMessage.Visible = true;
                return;
            }
            Session["UserID"] = (int)user["user_id"];
            Session["UserName"] = user["full_name"].ToString();
            Session["UserEmail"] = email;
            Session["UserRole"] = user["user_type"].ToString();

            if (chkRemember.Checked)
            {
                var cookie = new HttpCookie("CLF_User", email) { Expires = DateTime.Now.AddDays(14) };
                Response.Cookies.Add(cookie);
            }
            RedirectByRole(user["user_type"].ToString());
        }

        private void RedirectByRole(string role)
        {
            if (role == "user")
            {
                Response.Redirect("~/UserDashboard.aspx");
            }
            else if (role == "admin") { 
                Response.Redirect("~/Pages/Admin/AdminDashboard.aspx");
            }
        }
    }
}