using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Items
{
    public partial class MyClaims : Page
    {
        readonly ClaimService _svc = new ClaimService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }
            if (!IsPostBack) LoadClaims();
        }

        private void LoadClaims()
        {
            int userId = (int)Session["UserID"];
            var dt = _svc.GetUserClaims(userId);
            rptClaims.DataSource = dt;
            rptClaims.DataBind();
        }

        protected void rptClaims_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Reserved for future claim actions (e.g. Cancel claim)
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        protected void btnVerifyCode_Click(object sender, EventArgs e)
        {
            string code = txtCollectionCode.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code)) { lblCodeMessage.Text = "Please enter a code."; return; }
            int userId = (int)Session["UserID"];
            bool ok = _svc.VerifyCollectionCode(code, userId);
            lblCodeMessage.Text = ok
                ? "Item successfully collected! The report has been closed."
                : "Invalid or already used collection code.";
            lblCodeMessage.CssClass = ok ? "text-success" : "text-danger";
            if (ok) LoadClaims();
        }

        protected string GetClaimBadgeClass(string status)
        {
            switch ((status ?? "").ToLower())
            {
                case "pending": return "badge-warning";
                case "approved": return "badge-success";
                case "rejected": return "badge-danger";
                case "verified": return "badge-info";
                default: return "badge-secondary";
            }
        }
    }
}