using System;
using System.Web.UI;
using System.Data;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Items
{
    public partial class SearchItems : Page
    {
        readonly ItemService _svc = new ItemService();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }
            if (!IsPostBack)
            {
                litUserName.Text = Session["UserName"]?.ToString() ?? "User";
                BindItems();
            }
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtKeyword.Text = txtLocation.Text = txtDateFrom.Text = "";
            ddlType.SelectedIndex = ddlCategory.SelectedIndex = 0;
            BindItems();
        }

        protected void btnSearch_Click(object sender, EventArgs e) => BindItems();
        protected void lbtnGridView_Click(object sender, EventArgs e)
        {
            lbtnGridView.CssClass = "btn btn-sm btn-outline-secondary active";
            lbtnListView.CssClass = "btn btn-sm btn-outline-secondary";
            BindItems();
        }

        protected void lbtnListView_Click(object sender, EventArgs e)
        {
            lbtnListView.CssClass = "btn btn-sm btn-outline-secondary active";
            lbtnGridView.CssClass = "btn btn-sm btn-outline-secondary";
            BindItems();
        }
        private void BindItems()
        {
            DateTime? dateFrom = null;
            if (!string.IsNullOrEmpty(txtDateFrom.Text) && DateTime.TryParse(txtDateFrom.Text, out DateTime d))
                dateFrom = d;

            // map dropdown value to db values ("Lost"->"lost", "Found"->"found", ""->all)
            string typeVal = ddlType.SelectedValue?.ToLower() ?? "";
            if (typeVal == "lost" || typeVal == "found") { /* keep */ }
            else typeVal = "";

            DataTable dt = _svc.SearchItems(txtKeyword.Text.Trim(), typeVal,
                ddlCategory.SelectedValue, txtLocation.Text.Trim(), dateFrom);

            litResultCount.Text = dt.Rows.Count.ToString();
            rptItems.DataSource = dt;
            rptItems.DataBind();
            pnlResults.Visible = dt.Rows.Count > 0;
            pnlEmpty.Visible = dt.Rows.Count == 0;
        }
    }
}