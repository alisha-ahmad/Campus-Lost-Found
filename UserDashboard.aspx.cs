using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound
{
    public partial class UserDashboard : Page
    {
        private readonly ItemService _itemSvc = new ItemService();
        private readonly NotificationService _notifSvc = new NotificationService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/Auth/Login.aspx");
                return;
            }
            if (Session["UserRole"]?.ToString() == "admin")
            {
                Response.Redirect("~/AdminDashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int userId = (int)Session["UserID"];
                string name = Session["UserName"]?.ToString() ?? "User";
                litUserName.Text = Server.HtmlEncode(name);
                litGreet.Text = Server.HtmlEncode(name.Split(' ')[0]);

                // Populate User metrics
                DataRow stats = _itemSvc.GetUserStats(userId);
                if (stats != null)
                {
                    litLostCount.Text = stats["LostCount"]?.ToString() ?? "0";
                    litFoundCount.Text = stats["FoundCount"]?.ToString() ?? "0";
                    litClaimCount.Text = stats["ClaimCount"]?.ToString() ?? "0";
                    litRecoveredCount.Text = stats["RecoveredCount"]?.ToString() ?? "0";
                }

                // Bind user specific reports
                DataTable reports = _itemSvc.GetUserReports(userId);
                if (reports != null && reports.Rows.Count > 0)
                {
                    rptMyReports.DataSource = reports.AsEnumerable().Take(5).CopyToDataTable();
                    rptMyReports.DataBind();
                    pnlNoReports.Visible = false;
                }
                else
                {
                    pnlNoReports.Visible = true;
                }

                // Safely bind notifications avoiding raw evaluation crashes
                DataTable notifs = _notifSvc.GetUserNotifications(userId, 5);
                if (notifs != null && notifs.Rows.Count > 0)
                {
                    var secureProjections = notifs.AsEnumerable().Select(row => new
                    {
                        Message = row.Field<string>("message"),
                        Icon = GetNotificationIcon(row["notification_type"]),
                        TimeAgo = CalculateRelativeTime(row["created_at"])
                    }).ToList();

                    rptNotifications.DataSource = secureProjections;
                    rptNotifications.DataBind();
                    pnlNoNotifs.Visible = false;
                }
                else
                {
                    pnlNoNotifs.Visible = true;
                }
            }
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        protected string GetStatusBadgeClass(string status)
        {
            switch ((status ?? "").ToLower().Trim())
            {
                case "pending": return "badge bg-warning text-dark rounded-pill px-3";
                case "matched": return "badge bg-info text-dark rounded-pill px-3";
                case "recovered":
                case "returned": return "badge bg-success rounded-pill px-3";
                case "available": return "badge bg-primary rounded-pill px-3";
                case "claimed": return "badge bg-secondary rounded-pill px-3";
                default: return "badge bg-dark rounded-pill px-3";
            }
        }

        private string GetNotificationIcon(object typeObj)
        {
            string type = (typeObj ?? "").ToString().ToLower();
            switch (type)
            {
                case "new_item": return "fa-box-open";
                case "claim": return "fa-file-invoice";
                case "claim_approved": return "fa-check-circle";
                case "message": return "fa-envelope";
                default: return "fa-bell";
            }
        }

        private string CalculateRelativeTime(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value) return "Recently";
            DateTime dt = Convert.ToDateTime(dateObj);
            TimeSpan ts = DateTime.Now - dt;

            if (ts.TotalMinutes < 1) return "Just now";
            if (ts.TotalMinutes < 60) return $"{(int)ts.TotalMinutes}m ago";
            if (ts.TotalHours < 24) return $"{(int)ts.TotalHours}h ago";
            return dt.ToString("dd MMM yyyy");
        }
    }
}