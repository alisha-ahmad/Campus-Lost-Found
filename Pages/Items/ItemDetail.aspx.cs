using System;
using System.Data;
using System.Web.UI;
using CampusLostFound.DAL.Services;

namespace CampusLostFound.Pages.Items
{
    public partial class ItemDetail : Page
    {
        readonly ItemService _itemSvc = new ItemService();
        readonly ClaimService _claimSvc = new ClaimService();
        readonly MatchService _matchSvc = new MatchService();
        readonly DAL.Repositories.MessageRepository _msgRepo = new DAL.Repositories.MessageRepository();

        int _itemId;
        string _type;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }

            if (!int.TryParse(Request.QueryString["id"], out _itemId))
            { Response.Redirect("~/Pages/Items/SearchItems.aspx"); return; }

            if (!IsPostBack)
                LoadItem();
        }

        private void LoadItem()
        {
            DataRow row = _itemSvc.GetItemById(_itemId);
            if (row == null) { Response.Redirect("~/Pages/Items/SearchItems.aspx"); return; }

            _type = row["item_type"].ToString();
            ViewState["ItemType"] = _type;
            ViewState["OwnerId"] = (int)row["user_id"];

            // set navbar username
            if (Session["UserName"] != null)
                litUserName.Text = Session["UserName"].ToString();

            litItemName.Text = Server.HtmlEncode(row["item_name"].ToString());
            litDescription.Text = Server.HtmlEncode(row["description"].ToString());
            litLocation.Text = Server.HtmlEncode(row["location"].ToString());
            litDate.Text = Convert.ToDateTime(row["item_date"]).ToString("dd MMM yyyy");
            litCategory.Text = Server.HtmlEncode(row["category_name"].ToString());

            string reporter = row["reporter_name"].ToString();
            if (litReporter != null) litReporter.Text = Server.HtmlEncode(reporter);
            if (litReportedBy != null) litReportedBy.Text = Server.HtmlEncode(reporter);
            if (litReportedDate != null && row.Table.Columns.Contains("reported_date") && row["reported_date"] != DBNull.Value)
                litReportedDate.Text = Convert.ToDateTime(row["reported_date"]).ToString("dd MMM yyyy");

            string status = row["status"] == DBNull.Value ? "available" : row["status"].ToString();
            string statusClass = status == "available" ? "badge-found" : status == "pending" ? "badge-lost" : "badge bg-secondary";
            if (litStatus != null) litStatus.Text = status;
            if (litStatusBadge != null)
                litStatusBadge.Text = $"<span class='status-badge {statusClass}'>{Server.HtmlEncode(status)}</span>";

            string typeLabel = _type == "lost" ? "Lost" : "Found";
            string typeClass = _type == "lost" ? "badge-lost" : "badge-found";
            if (litType != null) litType.Text = _type == "lost" ? "Lost Item" : "Found Item";
            if (litTypeBadge != null)
                litTypeBadge.Text = $"<span class='status-badge {typeClass}'>{typeLabel}</span>";

            string img = row["image_path"] as string;
            if (!string.IsNullOrEmpty(img))
            {
                imgItem.ImageUrl = ResolveUrl("~/" + img);
                pnlImage.Visible = true;
                pnlNoImage.Visible = false;
            }
            else
            {
                pnlImage.Visible = false;
                pnlNoImage.Visible = true;
            }

            int currentUserId = (int)Session["UserID"];
            bool isOwner = currentUserId == (int)row["user_id"];

            // show claim button for available found items only, where user != owner
            pnlClaim.Visible = (_type == "found" && status == "available" && !isOwner);

            // load security question for claim panel
            if (pnlClaim.Visible)
            {
                string sq = _itemSvc.GetSecurityQuestion(_itemId);
                if (litSecurityQuestion != null)
                    litSecurityQuestion.Text = !string.IsNullOrEmpty(sq) ? Server.HtmlEncode(sq) : "No security question set.";
                // user may optionally link their lost item
                if (ddlMyLostItem != null)
                {
                    var myLost = _itemSvc.GetUserReports(currentUserId, "lost");
                    ddlMyLostItem.DataSource = myLost;
                    ddlMyLostItem.DataTextField = "item_name";
                    ddlMyLostItem.DataValueField = "item_id";
                    ddlMyLostItem.DataBind();
                    ddlMyLostItem.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- None --", "0"));
                }
            }

            // possible matches for lost item
            if (_type == "lost")
            {
                var matches = _matchSvc.GetPossibleMatchesForLostItem(_itemId);
                if (matches != null && matches.Rows.Count > 0 && rptMatches != null)
                {
                    rptMatches.DataSource = matches;
                    rptMatches.DataBind();
                    if (pnlMatches != null) pnlMatches.Visible = true;
                }
            }

            // show mark-recovered for owner of lost items still pending/matched
            if (pnlMarkRecovered != null)
                pnlMarkRecovered.Visible = isOwner && _type == "lost"
                    && (status == "pending" || status == "matched");

            // hide message box if user is owner
            if (pnlMessage != null) pnlMessage.Visible = !isOwner;
        }

        protected void btnClaim_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }

            _type = ViewState["ItemType"]?.ToString();
            int currentUserId = (int)Session["UserID"];
            string secAnswer = txtSecurityAnswer.Text.Trim();

            if (string.IsNullOrEmpty(secAnswer))
            {
                litClaimMessage.Text = "Please provide a security answer."; return;
            }

            int? lostItemId = null;
            if (ddlMyLostItem != null && ddlMyLostItem.SelectedValue != "0")
                lostItemId = int.Parse(ddlMyLostItem.SelectedValue);

            bool ok = _claimSvc.SubmitClaim(_itemId, lostItemId, currentUserId, secAnswer);
            litClaimMessage.Text = ok
                ? "Claim submitted successfully! Awaiting admin review."
                : "Claim submission failed. You may have already claimed this item.";
            pnlClaim.Visible = !ok;
        }

        protected void btnMarkRecovered_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }
            int ownerId = ViewState["OwnerId"] != null ? (int)ViewState["OwnerId"] : 0;
            if ((int)Session["UserID"] != ownerId) return;

            string type = ViewState["ItemType"]?.ToString();
            bool ok = _itemSvc.MarkItemRecovered(_itemId, type);
            litMessageStatus.Text = ok ? "Item marked as recovered." : "Could not update item status.";
            pnlMarkRecovered.Visible = false;
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }

        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("~/Pages/Auth/Login.aspx"); return; }
            string msg = txtMessage.Text.Trim();
            if (string.IsNullOrEmpty(msg)) return;

            int senderId = (int)Session["UserID"];
            int receiverId = (int)ViewState["OwnerId"];
            if (senderId == receiverId) { litMessageStatus.Text = "You cannot message yourself."; return; }

            bool sent = _msgRepo.SendMessage(senderId, receiverId, msg, _itemId);
            litMessageStatus.Text = sent ? "Message sent." : "Failed to send message.";
            if (sent) txtMessage.Text = "";
        }
    }
}