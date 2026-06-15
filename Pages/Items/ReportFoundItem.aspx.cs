using System;
using System.Web.UI;
using System.IO;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Items
{
    public partial class ReportFoundItem : Page
    {
        readonly ItemService _svc = new ItemService();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }
            if (!IsPostBack) litUserName.Text = Session["UserName"]?.ToString() ?? "User";
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int userId = (int)Session["UserID"];
            DateTime dateFound;
            if (!DateTime.TryParse(txtFoundDate.Text, out dateFound))
            { ShowError("Please enter a valid date."); return; }

            string imagePath = HandleImageUpload();
            if (imagePath == "ERROR") return;

            bool ok = _svc.ReportFoundItem(userId, txtItemName.Text.Trim(),
                txtDescription.Text.Trim(), txtLocation.Text.Trim(),
                dateFound, ddlCategory.SelectedValue, imagePath) > 0;

            if (ok)
            {
                pnlError.Visible = false;
                litSuccess.Text = "Found item reported successfully! The owner will be notified if a match is found.";
                pnlSuccess.Visible = true;
                txtItemName.Text = txtDescription.Text = txtLocation.Text = txtFoundDate.Text = "";
            }
            else ShowError("Failed to submit report. Please try again.");
        }

        private string HandleImageUpload()
        {
            if (!fuItemImage.HasFile) return null;
            string ext = Path.GetExtension(fuItemImage.FileName).ToLower();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp")
            { ShowError("Only JPG, PNG, GIF, and WEBP images are allowed."); return "ERROR"; }
            if (fuItemImage.PostedFile.ContentLength > 5 * 1024 * 1024)
            { ShowError("Image must be under 5MB."); return "ERROR"; }
            string folder = Server.MapPath("~/-/Uploads/");
            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
            string fileName = Guid.NewGuid() + ext;
            fuItemImage.SaveAs(folder + fileName);
            return "-/Uploads/" + fileName;
        }

        private void ShowError(string msg) { litError.Text = msg; pnlError.Visible = true; }
        
        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }
    }
}