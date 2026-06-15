using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using CampusLostFound.DAL.Repositories;

namespace CampusLostFound.Pages.Messages
{
    public partial class Messages : Page
    {
        private readonly MessageRepository _repo = new MessageRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/Auth/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadConversations(selectFirstIfNone: true);
            }
        }

        private void LoadConversations(bool selectFirstIfNone)
        {
            int userId = (int)Session["UserID"];
            DataTable dt = _repo.GetConversations(userId);

            rptConversations.DataSource = dt;
            rptConversations.DataBind();

            if (dt != null && dt.Rows.Count > 0)
            {
                pnlActiveChat.Visible = true;
                pnlEmptyState.Visible = false;

                if (selectFirstIfNone || ViewState["ChatKey"] == null)
                {
                    string defaultKey = dt.Rows[0]["chat_key"].ToString();
                    ViewState["ChatKey"] = defaultKey;
                    int defaultItemId = int.Parse(defaultKey.Split('_')[0]);
                    _repo.MarkMessagesAsRead(defaultItemId, userId);
                    LoadMessages(defaultKey);
                }
            }
            else
            {
                pnlActiveChat.Visible = false;
                pnlEmptyState.Visible = true;
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMessage.Text)) return;
            if (ViewState["ChatKey"] == null) return;

            int senderId = (int)Session["UserID"];
            string chatKey = ViewState["ChatKey"].ToString();
            string[] parts = chatKey.Split('_');

            int itemId = Convert.ToInt32(parts[0]);
            int receiverId = Convert.ToInt32(parts[1]);

            _repo.SendMessage(senderId, receiverId, txtMessage.Text.Trim(), itemId);
            txtMessage.Text = "";

            LoadMessages(chatKey);
            LoadConversations(selectFirstIfNone: false); // refreshes timelines without resetting active window state
        }

        protected void lbtnConversation_Command(object sender, CommandEventArgs e)
        {
            string chatKey = e.CommandArgument.ToString();
            ViewState["ChatKey"] = chatKey;
            int userId = (int)Session["UserID"];
            int itemId = int.Parse(chatKey.Split('_')[0]);
            _repo.MarkMessagesAsRead(itemId, userId);
            LoadMessages(chatKey);
            LoadConversations(selectFirstIfNone: false); // safeguards active window memory choice
        }

        private void LoadMessages(string chatKey)
        {
            int userId = (int)Session["UserID"];
            DataTable dt = _repo.GetMessages(chatKey, userId);
            rptMessages.DataSource = dt;
            rptMessages.DataBind();
        }

        protected void lbtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Pages/Auth/Login.aspx");
        }
    }
}