using System;
using System.Web.UI;

namespace CampusLostFound
{
    public partial class Main : MasterPage 
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Enforce centralized session verification checks
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/Auth/Login.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                // Dynamic display parameter mapping
                string fullUserName = Session["UserName"]?.ToString() ?? "Campus User";
                litNavbarUserName.Text = fullUserName;
                // Process first character token for localized profile placeholder visualization
                if (!string.IsNullOrWhiteSpace(fullUserName))
                {
                    string[] nameTokens = fullUserName.Trim().Split(' ');
                    if (nameTokens.Length > 0 && nameTokens[0].Length > 0)
                    {
                        litAvatarInitials.Text = nameTokens[0].Substring(0, 1).ToUpper();
                    }
                }
            }
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            // Secure destruction sequence clearing all system authentication variables
            Session.Clear();
            Session.Abandon();
            System.Web.Security.FormsAuthentication.SignOut();
            Response.Redirect("~/Pages/Auth/Login.aspx", true);
        }
    }
}