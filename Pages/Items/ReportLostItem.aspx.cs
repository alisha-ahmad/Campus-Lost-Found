using System;
using System.IO;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Items
{
    public partial class ReportLostItem : Page
    {
        readonly ItemService _svc = new ItemService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }
            if (!IsPostBack)
            {
                litUserName.Text = Session["UserName"]?.ToString() ?? "User";
            }
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        protected void cvLocation_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            args.IsValid = !string.IsNullOrWhiteSpace(txtLocation.Text.Trim())
                        || !string.IsNullOrWhiteSpace(ddlLocation.SelectedValue);
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int userId = (int)Session["UserID"];
            string itemName = txtItemName.Text.Trim();
            string description = txtDescription.Text.Trim();
            string location = txtLocation.Text.Trim();
            if (string.IsNullOrEmpty(location))
                location = ddlLocation.SelectedValue;
            string category = ddlCategory.SelectedValue;
            string secQ = txtSecurityQuestion.Text.Trim();
            string secA = txtSecurityAnswer.Text.Trim();

            if (string.IsNullOrEmpty(secA))
            { ShowError("Security answer is required."); return; }

            DateTime dateLost;
            if (!DateTime.TryParse(txtDateLost.Text, out dateLost))
            { ShowError("Please enter a valid date."); return; }

            string imagePath = HandleImageUpload();
            if (imagePath == "ERROR") return;

            int newId = _svc.ReportLostItem(userId, itemName, description, location,
                dateLost, category, secQ, secA, imagePath);
            if (newId > 0)
            {
                pnlError.Visible = false;
                pnlSuccess.Visible = true;
                // show possible matches to user
                var matches = new MatchService().GetPossibleMatchesForLostItem(newId);
                if (matches.Rows.Count > 0)
                {
                    rptMatches.DataSource = matches;
                    rptMatches.DataBind();
                    pnlMatches.Visible = true;
                }
                ClearForm();
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

        private void ShowError(string msg)
        {
            litError.Text = msg;
            pnlError.Visible = true;
        }

        private void ClearForm()
        {
            txtItemName.Text = txtDescription.Text = txtSecurityQuestion.Text =
                txtSecurityAnswer.Text = txtDateLost.Text = txtLocation.Text = "";
        }
    }
}