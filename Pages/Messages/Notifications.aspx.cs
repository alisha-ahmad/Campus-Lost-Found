using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Messages
{
    public partial class Notifications : Page
    {
        private readonly NotificationService _svc = new NotificationService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) 
            { 
                Response.Redirect("~/Pages/Auth/Login.aspx"); 
                return; 
            }
            if (!IsPostBack) 
            {
                LoadNotifications();
            }
        }

        private void LoadNotifications()
        {
            int userId = (int)Session["UserID"];
            DataTable dt = _svc.GetUserNotifications(userId, 50);
            
            if (dt != null && dt.Rows.Count > 0)
            {
                rptNotifications.DataSource = dt;
                rptNotifications.DataBind();
                pnlNoNotifs.Visible = false;
                btnMarkAll.Visible = true;
            }
            else
            {
                rptNotifications.DataSource = null;
                rptNotifications.DataBind();
                pnlNoNotifs.Visible = true;
                btnMarkAll.Visible = false;
            }
        }

        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            int userId = (int)Session["UserID"];
            _svc.MarkAllRead(userId);
            LoadNotifications();
        }

        protected void rptNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ProcessNotification")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int notificationId = Convert.ToInt32(args[0]);
                string entityType = args[1].ToLower().Trim();

                // Advanced high-fidelity runtime UX router
                switch (entityType)
                {
                    case "messages":
                    case "message":
                        Response.Redirect("~/Pages/Messages/Messages.aspx");
                        break;
                    default:
                        Response.Redirect("~/UserDashboard.aspx");
                        break;
                }
            }
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        protected string GetNotifIconClass(string type)
        {
            switch (type?.ToLower())
            {
                case "claim":   return "claim";
                case "match":   return "match";
                case "message": return "message";
                case "system":  return "system";
                default:        return "default";
            }
        }

        protected string GetNotifIcon(string type)
        {
            switch (type?.ToLower())
            {
                case "claim":   return "fa-solid fa-hand-holding-heart";
                case "match":   return "fa-solid fa-circle-check";
                case "message": return "fa-solid fa-comments";
                case "system":  return "fa-solid fa-shield-halved";
                default:        return "fa-solid fa-bell";
            }
        }
    }
}