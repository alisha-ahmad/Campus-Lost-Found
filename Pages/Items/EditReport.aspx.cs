using System;
using System.Data;
using System.IO;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Items
{
    public partial class EditReport : Page
    {
        readonly ItemService _svc = new ItemService();
        int _itemId;
        string _type;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }
            if (!int.TryParse(Request.QueryString["id"], out _itemId))
            { Response.Redirect("~/Pages/Items/MyReports.aspx"); return; }
            _type = Request.QueryString["type"] ?? "";

            if (!IsPostBack)
            {
                litUserName.Text = Session["UserName"]?.ToString() ?? "User";
                LoadReport();
            }
        }

        private void LoadReport()
        {
            DataRow row = _svc.GetItemById(_itemId);
            if (row == null || (int)row["user_id"] != (int)Session["UserID"])
            { Response.Redirect("~/Pages/Items/MyReports.aspx"); return; }

            _type = row["item_type"].ToString();
            ViewState["ItemType"] = _type;
            litReportType.Text = "- " + (_type == "lost" ? "Lost" : "Found") + " Item";
            txtItemName.Text = row["item_name"].ToString();
            txtDescription.Text = row["description"].ToString();
            txtLocation.Text = row["location"].ToString();
            txtItemDate.Text = Convert.ToDateTime(row["item_date"]).ToString("yyyy-MM-dd");
            litCurrentStatus.Text = row["status"].ToString();
            litReportedOn.Text = Convert.ToDateTime(row["reported_date"]).ToString("dd MMM yyyy");

            pnlSecuritySection.Visible = (_type == "lost");
            if (_type == "lost") txtSecurityQuestion.Text = row["security_question"]?.ToString();

            string imgPath = row["image_path"] as string;
            if (!string.IsNullOrEmpty(imgPath))
            {
                imgCurrent.Src = ResolveUrl("~/" + imgPath);
                pnlCurrentImage.Visible = true;
            }
            else pnlCurrentImage.Visible = false;
            // select current category by name
            string catName = row["category_name"].ToString();
            foreach (System.Web.UI.WebControls.ListItem li in ddlCategory.Items)
                if (li.Value == catName) { li.Selected = true; break; }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            _type = ViewState["ItemType"]?.ToString() ?? Request.QueryString["type"];
            DateTime itemDate;
            if (!DateTime.TryParse(txtItemDate.Text, out itemDate))
            { ShowError("Please enter a valid date."); return; }

            string imagePath = null;
            if (fuItemImage.HasFile)
            {
                string ext = Path.GetExtension(fuItemImage.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp")
                { ShowError("Only JPG, PNG, GIF, and WEBP images are allowed."); return; }
                string folder = Server.MapPath("~/-/Uploads/");
                if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                string fileName = Guid.NewGuid() + ext;
                fuItemImage.SaveAs(folder + fileName);
                imagePath = "-/Uploads/" + fileName;
            }

            string secQ = _type == "lost" ? txtSecurityQuestion.Text.Trim() : null;
            string secA = _type == "lost" ? txtSecurityAnswer.Text.Trim() : null;

            bool ok = _svc.UpdateItem(_itemId, txtItemName.Text.Trim(),
                txtDescription.Text.Trim(), txtLocation.Text.Trim(),
                itemDate, ddlCategory.SelectedValue,
                secQ, secA, imagePath);

            if (ok)
            {
                pnlSuccess.Visible = true; pnlError.Visible = false;
                litSuccess.Text = "Report updated successfully.";
                LoadReport();
            }
            else ShowError("Update failed. Please try again.");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            _svc.DeleteItem(_itemId);
            Response.Redirect("~/Pages/Items/MyReports.aspx?msg=deleted");
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        private void ShowError(string msg) { litError.Text = msg; pnlError.Visible = true; }
    }
}