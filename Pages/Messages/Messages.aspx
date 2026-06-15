<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="CampusLostFound.Pages.Messages.Messages" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ── chat panel: fills remaining viewport below heading ── */
        .chat-panel {
            display: flex;
            /* navbar=70px + main padding=28px + heading+margin=68px */
            height: calc(100vh - 196px);
            min-height: 480px;
            border-radius: var(--radius);
            border: 1px solid var(--border);
            overflow: hidden;
            background: var(--card-bg);
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }

        /* Conversations sidebar */
        .conv-list {
            width: 290px;
            flex-shrink: 0;
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;
        }
        .conv-list-header {
            padding: 14px 18px;
            border-bottom: 1px solid var(--border);
            font-family: 'Sora', sans-serif;
            font-weight: 600;
            font-size: 0.93rem;
            color: var(--primary);
            flex-shrink: 0;
        }
        .conv-list-body { overflow-y: auto; flex: 1; min-height: 0; }
        .conv-item {
            display: block;
            padding: 13px 16px;
            border-bottom: 1px solid var(--border);
            cursor: pointer;
            border-left: 3px solid transparent;
            text-decoration: none;
            color: var(--text);
            width: 100%;
            text-align: left;
            background: none;
            border-top: none;
            border-right: none;
        }
        .conv-item:hover  { background: #f4f6fb; }
        .conv-active { background: #eef2fb !important; border-left-color: var(--primary-light) !important; }
        .conv-name { font-weight: 600; font-size: 0.87rem; color: var(--text); }
        .conv-sub  { font-size: 0.77rem; color: var(--muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 190px; }
        .conv-time { font-size: 0.73rem; color: var(--muted); }

        /* chat window: flex column with fixed bounds */
        .chat-window {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;  /* to allow flex child to shrink */
        }
        .chat-header {
            padding: 13px 18px;
            border-bottom: 1px solid var(--border);
            font-family: 'Sora', sans-serif;
            font-weight: 600;
            font-size: 0.93rem;
            color: var(--primary);
            flex-shrink: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        /* for internal scrolling of chatbox */
        .chat-box {
            flex: 1;
            overflow-y: auto;
            padding: 18px;
            background: #f8fafc;
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-height: 0;  /* to prevent overflow pushing footer out */
        }
        .message-left {
            background: #fff;
            padding: 10px 14px;
            border-radius: 14px 14px 14px 0;
            max-width: 70%;
            border: 1px solid var(--border);
            font-size: 0.91rem;
            align-self: flex-start;
            word-break: break-word;
        }
        .message-right {
            background: var(--primary);
            color: #fff;
            padding: 10px 14px;
            border-radius: 14px 14px 0 14px;
            max-width: 70%;
            font-size: 0.91rem;
            align-self: flex-end;
            word-break: break-word;
        }
        .msg-time { font-size: 0.7rem; opacity: 0.7; margin-top: 4px; }

        /* pinning footer at bottom */
        .chat-footer {
            padding: 12px 16px;
            border-top: 1px solid var(--border);
            background: var(--card-bg);
            flex-shrink: 0;
        }

        /* ── for mobile ── */
        @media (max-width: 767px) {
            .chat-panel {
                flex-direction: column;
                height: calc(100vh - 130px);
                min-height: 0;
            }
            .chat-window { order: 1; flex: 1; min-height: 0; }
            .conv-list {
                order: 2;
                width: 100%;
                height: 160px;
                flex-shrink: 0;
                border-right: none;
                border-top: 1px solid var(--border);
            }
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<!-- page heading -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-4">
            <div>
                <h4 style="margin:0;font-size:1.35rem;">
                    <i class="fa-solid fa-comments me-2" style="color:var(--accent);"></i>Blind Messaging
                </h4>
                <p class="text-muted mb-0" style="font-size:0.85rem;margin-top:2px;">
                    Communicate anonymously about lost &amp; found items
                </p>
            </div>
        </div>

        <!-- chat panel -->
        <div class="chat-panel">

            <!-- conversations list -->
            <div class="conv-list">
                <div class="conv-list-header">
                    <i class="fa-solid fa-inbox me-2" style="color:var(--accent);"></i>Conversations
                </div>
                <div class="conv-list-body">
                    <asp:Repeater ID="rptConversations" runat="server">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtnConversation" runat="server"
                                OnCommand="lbtnConversation_Command"
                                CommandArgument='<%# Eval("chat_key") %>'
                                CssClass='<%# Eval("chat_key").ToString() == (ViewState["ChatKey"] == null ? "" : ViewState["ChatKey"].ToString()) ? "conv-item conv-active" : "conv-item" %>'>
                                <div class="d-flex justify-content-between align-items-start gap-2">
                                    <div style="overflow:hidden;">
                                        <div class="conv-name"><%# Eval("other_user_name") %></div>
                                        <div class="conv-sub"><%# Eval("item_name") %> &middot; <%# Eval("item_type") %></div>
                                    </div>
                                    <div class="d-flex flex-column align-items-end gap-1 flex-shrink-0">
                                        <div class="conv-time"><%# Eval("latest_message", "{0:hh:mm tt}") %></div>
                                        <asp:Panel ID="pnlUnread" runat="server"
                                            Visible='<%# Convert.ToInt32(Eval("UnreadCount")) > 0 %>'>
                                            <span class="badge rounded-pill"
                                                style="background:var(--danger);font-size:0.7rem;">
                                                <%# Eval("UnreadCount") %>
                                            </span>
                                        </asp:Panel>
                                    </div>
                                </div>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- chat window -->
            <div class="chat-window">
                <asp:Panel ID="pnlActiveChat" runat="server">
                    <div class="chat-header">
                        <i class="fa-solid fa-user-secret" style="color:var(--muted);"></i>
                        Anonymous Conversation
                    </div>

                    <div class="chat-box" id="chatBox">
                        <asp:Repeater ID="rptMessages" runat="server">
                            <ItemTemplate>
                                <div class='<%# Convert.ToInt32(Eval("sender_id")) == Convert.ToInt32(Session["UserID"]) ? "message-right" : "message-left" %>'>
                                    <div class="text-break"><%# Server.HtmlEncode(Eval("message_text").ToString()) %></div>
                                    <div class='msg-time <%# Convert.ToInt32(Eval("sender_id")) == Convert.ToInt32(Session["UserID"]) ? "text-end" : "" %>'>
                                        <%# Eval("sent_at", "{0:dd MMM hh:mm tt}") %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <asp:Panel ID="pnlInputContainer" runat="server" DefaultButton="btnSend" CssClass="chat-footer">
                        <div class="input-group">
                            <asp:TextBox ID="txtMessage" runat="server"
                                CssClass="form-control"
                                placeholder="Type your anonymous message..."
                                autocomplete="off"></asp:TextBox>
                            <asp:Button ID="btnSend" runat="server"
                                Text="Send"
                                CssClass="btn btn-primary px-4"
                                OnClick="btnSend_Click" />
                        </div>
                    </asp:Panel>
                </asp:Panel>

                <!-- empty state -->
                <asp:Panel ID="pnlEmptyState" runat="server" Visible="false">
                    <div class="d-flex flex-column align-items-center justify-content-center h-100 text-center p-5"
                        style="flex:1;min-height:300px;">
                        <div style="width:72px;height:72px;background:#f0f2f8;border-radius:50%;display:flex;align-items:center;justify-content:center;margin-bottom:16px;">
                            <i class="fa-solid fa-comments" style="font-size:1.8rem;color:var(--muted);opacity:0.5;"></i>
                        </div>
                        <h5 style="font-family:'Sora',sans-serif;color:var(--primary);margin-bottom:8px;">No Conversations Yet</h5>
                        <p style="color:var(--muted);font-size:0.88rem;max-width:300px;">
                            Conversations appear here when you or another user initiates contact through an item listing.
                        </p>
                    </div>
                </asp:Panel>
            </div>

        </div><!-- /chat-panel -->

</asp:Content>
