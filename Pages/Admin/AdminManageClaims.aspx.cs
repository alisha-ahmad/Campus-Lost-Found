using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Admin
{
    public partial class AdminManageClaims : Page
    {
        readonly ClaimService _svc = new ClaimService();

        protected void Page_Load(object sender, EventArgs e)
        {
            RequireAdmin();
            if (!IsPostBack) LoadClaims();
        }

        private void RequireAdmin()
        {
            if (Session["UserID"] == null || Session["UserRole"]?.ToString() != "admin")
                Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        private void LoadClaims()
        {
            DataTable dt = _svc.GetAllClaims();
            gvManageClaims.DataSource = dt;
            gvManageClaims.DataBind();
        }

        protected void gvManageClaims_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int claimId = Convert.ToInt32(e.CommandArgument);
            int adminId = (int)Session["UserID"];

            if (e.CommandName == "ApproveClaim")
            {
                bool ok = _svc.ApproveClaim(claimId, adminId);
                ShowMessage(ok ? "Claim approved. Collection code generated." : "Approval failed.", ok);
            }
            else if (e.CommandName == "RejectClaim")
            {
                // notes could come from TextBox in DetailsView or modal (simplified here)
                bool ok = _svc.RejectClaim(claimId, adminId, "Rejected by admin.");
                ShowMessage(ok ? "Claim rejected." : "Rejection failed.", ok);
            }
            LoadClaims();
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

        protected string GetStatusBadgeClass(string status)
        {
            switch (status?.ToLower())
            {
                case "approved": return "badge-found";
                case "rejected": return "badge-lost";
                case "pending":  return "badge-pending";
                default:         return "badge-claimed";
            }
        }
    }
}