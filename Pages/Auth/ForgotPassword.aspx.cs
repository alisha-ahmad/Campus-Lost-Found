using System;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Auth
{
    public partial class ForgotPassword : Page
    {
        readonly UserService _svc = new UserService();

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnSendLink_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            if (string.IsNullOrEmpty(email))
            {
                lblMessage.Text = "Please enter your email.";
                lblMessage.CssClass = "text-danger d-block mb-3";
                lblMessage.Visible = true;
                return;
            }

            bool exists = _svc.CheckEmailExists(email);

            if (!exists)
            {
                lblMessage.Text = "No account found with this email.";
                lblMessage.CssClass = "text-danger d-block mb-3";
                lblMessage.Visible = true;
                return;
            }

            string token = Guid.NewGuid().ToString();

            bool success = _svc.SaveResetToken(email, token);

            if (success)
            {
                pnlEmailStep.Visible = false;
                pnlSuccess.Visible = true;
            }
            else
            {
                lblMessage.Text = "Something went wrong. Please try again.";
                lblMessage.CssClass = "text-danger d-block mb-3";
                lblMessage.Visible = true;
            }
        }
    }
}