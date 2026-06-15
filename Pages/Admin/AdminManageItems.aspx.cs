using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Admin
{
    public partial class AdminManageItems : Page
    {
        readonly ItemService _svc = new ItemService();

        protected void Page_Load(object sender, EventArgs e)
        {
            RequireAdmin();
            if (!IsPostBack) LoadItems();
        }

        private void RequireAdmin()
        {
            if (Session["UserID"] == null || Session["UserRole"]?.ToString() != "admin")
                Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        private void LoadItems()
        {
            bool showFlagged = chkShowFlagged.Checked;
            bool showDuplicates = chkShowDuplicates.Checked;
            string type = ddlTypeFilter.SelectedValue;
            DataTable dt = _svc.GetAllItemsForAdmin(type, showFlagged, showDuplicates);
            gvItems.DataSource = dt;
            gvItems.DataBind();
        }

        protected void btnFilter_Click(object sender, EventArgs e) => LoadItems();

        protected void gvItems_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int itemId = Convert.ToInt32(e.CommandArgument);
            int adminId = (int)Session["UserID"];

            switch (e.CommandName)
            {
                case "FlagInappropriate":
                    _svc.FlagItem(itemId, adminId, "Inappropriate content");
                    ShowMessage("Item flagged and removed.", true);
                    break;
                case "FlagSpam":
                    _svc.FlagItem(itemId, adminId, "Spam");
                    ShowMessage("Item flagged as spam and removed.", true);
                    break;
                case "DeleteItem":
                    _svc.DeleteItem(itemId);
                    ShowMessage("Item deleted.", true);
                    break;
            }
            LoadItems();
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = "alert " + (success ? "alert-success" : "alert-danger") + " d-block";
            lblMessage.Visible = true;
        }

        protected string GetStatusPill(string status, bool isFlagged)
        {
            if (isFlagged)
                return "<span class='status-pill pill-flagged'><i class='fas fa-flag me-1'></i>Flagged</span>";

            switch ((status ?? "").ToLower())
            {
                case "pending": return "<span class='status-pill pill-pending'>Pending</span>";
                case "available": return "<span class='status-pill pill-available'>Available</span>";
                case "claimed": return "<span class='status-pill pill-claimed'>Claimed</span>";
                case "recovered": return "<span class='status-pill pill-recovered'>Recovered</span>";
                case "returned": return "<span class='status-pill pill-returned'>Returned</span>";
                case "matched": return "<span class='status-pill pill-claimed'>Matched</span>";
                default: return $"<span class='status-pill' style='background:#eee;color:#555;'>{status}</span>";
            }
        }
    }
}