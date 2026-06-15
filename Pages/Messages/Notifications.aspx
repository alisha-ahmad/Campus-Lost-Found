<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="CampusLostFound.Pages.Messages.Notifications" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .notif-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            border-left: 4px solid var(--border);
            padding: 18px 20px;
            margin-bottom: 12px;
            transition: box-shadow 0.15s;
            display: flex;
            align-items: flex-start;
            gap: 16px;
        }
        .notif-card:hover { box-shadow: 0 4px 12px rgba(26,58,92,0.08); }
        .notif-card.unread { border-left-color: var(--primary-light); background: #f7f9ff; }
        .notif-icon {
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0; font-size: 1rem;
        }
        .notif-icon.type-claim      { background: #fff8e6; color: var(--warning); }
        .notif-icon.type-match      { background: #edf7f2; color: var(--success); }
        .notif-icon.type-message    { background: #eef2fb; color: var(--primary-light); }
        .notif-icon.type-system     { background: #f3f0ff; color: #7c3aed; }
        .notif-icon.type-default    { background: #f0f2f8; color: var(--muted); }
        .notif-title  { font-family: 'Sora', sans-serif; font-weight: 600; font-size: 0.92rem; color: var(--text); margin-bottom: 3px; }
        .notif-msg    { font-size: 0.86rem; color: var(--muted); margin-bottom: 5px; }
        .notif-time   { font-size: 0.76rem; color: var(--muted); }
        .unread-dot   { width: 8px; height: 8px; border-radius: 50%; background: var(--primary-light); flex-shrink: 0; margin-top: 6px; }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<!-- page heading -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
            <div>
                <h4 style="margin:0;font-size:1.35rem;">
                    <i class="fa-solid fa-bell me-2" style="color:var(--accent);"></i>Notifications
                </h4>
                <p class="text-muted mb-0" style="font-size:0.85rem;margin-top:2px;">
                    Your alerts, matches and system updates
                </p>
            </div>
            <asp:Button ID="btnMarkAll" runat="server"
                Text="Mark All as Read"
                CssClass="btn btn-sm btn-outline-primary px-4"
                OnClick="btnMarkAllRead_Click" />
        </div>

        <!-- notifications list -->
        <div style="max-width:800px;">
            <asp:Repeater ID="rptNotifications" runat="server" OnItemCommand="rptNotifications_ItemCommand">
                <ItemTemplate>
                    <div class='<%# Convert.ToBoolean(Eval("is_read")) ? "notif-card" : "notif-card unread" %>'>

                        <!-- unread dot -->
                        <%# Convert.ToBoolean(Eval("is_read")) ? "" : "<div class='unread-dot'></div>" %>

                        <!-- icon -->
                        <div class='<%# "notif-icon type-" + GetNotifIconClass(Eval("notification_type") == null ? "" : Eval("notification_type").ToString()) %>'>
                            <i class='<%# GetNotifIcon(Eval("notification_type") == null ? "" : Eval("notification_type").ToString()) %>'></i>
                        </div>

                        <!-- content -->
                        <div style="flex:1;min-width:0;">
                            <div class="notif-title"><%# Eval("title") %></div>
                            <div class="notif-msg"><%# Eval("message") %></div>
                            <div class="notif-time">
                                <i class="fa-solid fa-clock me-1"></i>
                                <%# Eval("created_at", "{0:dd MMM yyyy, hh:mm tt}") %>
                            </div>
                        </div>

                        <!-- action -->
                        <div class="flex-shrink-0">
                            <asp:LinkButton ID="lbtnView" runat="server"
                                Text="View"
                                CommandName="ProcessNotification"
                                CommandArgument='<%# Eval("notification_id") + "|" + Eval("related_entity_type") %>'
                                CssClass="btn btn-sm btn-outline-primary px-3" />
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- empty state -->
        <asp:Panel ID="pnlNoNotifs" runat="server" Visible="false">
            <div class="text-center py-5" style="max-width:400px;margin:40px auto 0;">
                <div style="width:72px;height:72px;background:#f0f2f8;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;">
                    <i class="fa-solid fa-envelope-open" style="font-size:1.8rem;color:var(--muted);opacity:0.5;"></i>
                </div>
                <h5 style="font-family:'Sora',sans-serif;color:var(--primary);margin-bottom:8px;">All Caught Up!</h5>
                <p style="color:var(--muted);font-size:0.88rem;">
                    You have no new notifications right now. We'll alert you when there's activity on your items or claims.
                </p>
            </div>
        </asp:Panel>

</asp:Content>
