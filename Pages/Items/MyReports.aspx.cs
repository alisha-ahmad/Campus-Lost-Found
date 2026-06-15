using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Items
{
    public partial class MyReports : Page
    {
        readonly ItemService _svc = new ItemService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }
            if (!IsPostBack)
            {
                litUserName.Text = Session["UserName"]?.ToString() ?? "User";
                if (Request.QueryString["msg"] == "deleted")
                {
                    litSuccess.Text = "Report deleted successfully.";
                    pnlSuccess.Visible = true;
                }
                BindReports("");
            }
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        protected void lbtnAll_Click(object sender, EventArgs e) => BindReports("");
        protected void lbtnLost_Click(object sender, EventArgs e) => BindReports("lost");
        protected void lbtnFound_Click(object sender, EventArgs e) => BindReports("found");

        private void BindReports(string filter)
        {
            int userId = (int)Session["UserID"];
            DataTable dt = _svc.GetUserReports(userId, filter);
            rptReports.DataSource = dt;
            rptReports.DataBind();
            pnlEmpty.Visible = dt.Rows.Count == 0;
        }

        protected void lbtnDelete_Command(object sender, CommandEventArgs e)
        {
            string[] parts = e.CommandArgument.ToString().Split(',');
            int itemId = Convert.ToInt32(parts[0]);
            bool ok = _svc.DeleteItem(itemId);
            if (ok) { litSuccess.Text = "Report deleted."; pnlSuccess.Visible = true; }
            BindReports("");
        }

        protected string GetStatusBadgeClass(string status)
        {
            switch ((status ?? "").ToLower())
            {
                case "pending": return "badge-pending";
                case "matched": return "badge-info";
                case "recovered": case "returned": return "badge-recovered";
                case "available": return "badge-found";
                case "claimed": return "badge-pending";
                default: return "badge-secondary";
            }
        }
    }
}