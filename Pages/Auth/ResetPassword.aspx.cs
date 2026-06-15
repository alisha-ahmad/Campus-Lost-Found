using System;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Auth
{
    public partial class ResetPassword : Page
    {
        private readonly UserService _userService = new UserService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Capture token parameter context from standard inbound request queries
                string token = Request.QueryString["token"];

                if (string.IsNullOrWhiteSpace(token) || !_userService.IsTokenValid(token))
                { 
                    // Render immediate rejection interface wrapper context
                    pnlInvalidToken.Visible = true;
                    pnlResetInputs.Visible = false;
                }
                else
                {
                    // Authenticated workflow context verified successfully
                    pnlInvalidToken.Visible = false;
                    pnlResetInputs.Visible = true;
                    inputFieldsContainer.Visible = true;
                }
            }
        }

        protected void btnExecuteReset_Click(object sender, EventArgs e)
        {
            pnlStatusAlert.Visible = false;
            string token = Request.QueryString["token"];

            // Defensive security boundary verification checks
            if (string.IsNullOrWhiteSpace(token) || !_userService.IsTokenValid(token))
            {
                pnlInvalidToken.Visible = true;
                pnlResetInputs.Visible = false;
                return;
            }
            string targetPass = txtNewPassword.Text;
            string confirmPass = txtConfirmPassword.Text;
            // Form validation parameters mapping
            if (string.IsNullOrWhiteSpace(targetPass) || targetPass.Length < 6)
            {
                lblStatusError.Text = "Password must be at least 6 characters in length.";
                pnlStatusAlert.Visible = true;
                return;
            }
            if (targetPass != confirmPass)
            {
                lblStatusError.Text = "Passwords do not match. Please try again.";
                pnlStatusAlert.Visible = true;
                return;
            }
            // Execute credential reset securely via UserService layers
            bool actionSuccess = _userService.UpdatePassword(token, targetPass);
            if (actionSuccess)
            {
                // Transition interface state visually to indicate operation finalization
                pnlStatusSuccess.Visible = true;
                inputFieldsContainer.Visible = false;
            }
            else
            {
                lblStatusError.Text = "An error occurred while writing your credentials. Please try again.";
                pnlStatusAlert.Visible = true;
            }
        }
    }
}