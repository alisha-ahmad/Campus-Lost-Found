using System;
using System.Data;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Admin
{
    public partial class AdminDashboard : Page
    {
        readonly ClaimService _claimSvc = new ClaimService();
        readonly ItemService _itemSvc = new ItemService();

        protected void Page_Load(object sender, EventArgs e)
        {
            RequireAdmin();
            if (!IsPostBack)
            {
                LoadStats();
                LoadActivityLogs();
                LoadSuggestedDuplicates();
                LoadFlaggedItems();
            }
        }

        private void RequireAdmin()
        {
            if (Session["UserID"] == null || Session["UserRole"]?.ToString() != "admin")
                Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        private void LoadStats()
        {
            DataRow stats = _claimSvc.GetAdminStats();
            if (stats == null) return;
            lblTotalReports.Text = ((int)stats["TotalLost"] + (int)stats["TotalFound"]).ToString();
            lblRecoveredItems.Text = stats["RecoveredItems"].ToString();
            lblPendingClaims.Text = stats["PendingClaims"].ToString();
            lblFlaggedItems.Text = stats["FlaggedItems"].ToString();
            lblDuplicateItems.Text = stats["DuplicateItems"].ToString();
            lblTotalUsers.Text = stats["TotalUsers"].ToString();
        }

        private void LoadActivityLogs()
        {
            gvActivityLogs.DataSource = _claimSvc.GetActivityLogs();
            gvActivityLogs.DataBind();
        }

        private void LoadSuggestedDuplicates()
        {
            DataTable dt = _itemSvc.GetSuggestedDuplicates();
            rptDuplicates.DataSource = dt;
            rptDuplicates.DataBind();
            pnlDuplicates.Visible = dt.Rows.Count > 0;
        }

        private void LoadFlaggedItems()
        {
            DataTable dt = _itemSvc.GetAllItemsForAdmin("", true, false);
            gvFlaggedItems.DataSource = dt;
            gvFlaggedItems.DataBind();
        }

        // admin confirms suggested duplicate
        protected void rptDuplicates_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ConfirmDuplicate")
            {
                string[] args = e.CommandArgument.ToString().Split(',');
                int itemId = int.Parse(args[0]);
                int duplicateOfId = int.Parse(args[1]);
                int adminId = (int)Session["UserID"];
                _itemSvc.MarkDuplicate(itemId, duplicateOfId, adminId);
                LoadSuggestedDuplicates();
                LoadStats();
            }
        }

        // admin removes flagged/inappropriate item
        protected void gvFlaggedItems_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                int itemId = int.Parse(e.CommandArgument.ToString());
                _itemSvc.DeleteItem(itemId);
                LoadFlaggedItems();
                LoadStats();
            }
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }
    }
}