<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="CampusLostFound.UserDashboard" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%-- litUserName kept for code-behind compatibility --%>
    <asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

<!-- Page heading -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-4">
            <div>
                <h4 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:2px;">My Dashboard</h4>
                <p class="text-muted mb-0" style="font-size:0.9rem;">
                    Welcome back, <asp:Literal ID="litGreet" runat="server" Text="User"></asp:Literal>
                </p>
            </div>
            <div class="d-flex gap-2">
                <a href="Pages/Items/ReportLostItem.aspx" class="btn btn-danger btn-sm px-3">
                    <i class="fa fa-plus me-1"></i><span class="d-none d-sm-inline">Report</span> Lost
                </a>
                <a href="Pages/Items/ReportFoundItem.aspx" class="btn btn-success btn-sm px-3">
                    <i class="fa fa-plus me-1"></i><span class="d-none d-sm-inline">Report</span> Found
                </a>
            </div>
        </div>

        <!-- Stat cards -->
        <div class="row g-3 mb-4">
            <div class="col-md-3 col-6">
                <div class="stat-card-color" style="background:linear-gradient(135deg,#a93226,#c0392b);">
                    <div class="stat-num">
                        <asp:Literal ID="litLostCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Lost Reports</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card-color" style="background:linear-gradient(135deg,#1a6b45,#27ae60);">
                    <div class="stat-num">
                        <asp:Literal ID="litFoundCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Found Reports</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card-color" style="background:linear-gradient(135deg,#b7770d,#d68910);">
                    <div class="stat-num">
                        <asp:Literal ID="litClaimCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Pending Claims</div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="stat-card-color" style="background:linear-gradient(135deg,var(--primary-light),var(--primary));">
                    <div class="stat-num">
                        <asp:Literal ID="litRecoveredCount" runat="server" Text="0"></asp:Literal>
                    </div>
                    <div class="stat-label">Items Recovered</div>
                </div>
            </div>
        </div>

        <div class="row g-4">

            <!-- Recent reports -->
            <div class="col-lg-7">
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
                    <div style="padding:14px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;">
                        <span style="font-family:'Sora',sans-serif;font-weight:600;">My Recent Reports</span>
                        <a href="Pages/Items/MyReports.aspx" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                    <div style="overflow-x:auto;-webkit-overflow-scrolling:touch;">
                        <asp:Repeater ID="rptMyReports" runat="server">
                            <HeaderTemplate>
                                <table class="table table-hover mb-0" style="min-width:480px;">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">Item</th>
                                            <th>Type</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td class="ps-4" style="font-weight:500;"><%# Eval("item_name") %></td>
                                    <td>
                                        <span class='status-badge <%# (string)Eval("item_type")=="lost" ? "badge-lost" : "badge-found" %>'>
                                            <%# Eval("item_type") %>
                                        </span>
                                    </td>
                                    <td class="text-muted" style="font-size:0.85rem;white-space:nowrap;">
                                        <%# Eval("reported_date", "{0:dd MMM yyyy}") %>
                                    </td>
                                    <td>
                                        <span class='status-badge <%# GetStatusBadgeClass((string)Eval("status")) %>'>
                                            <%# Eval("status") %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href='Pages/Items/EditReport.aspx?id=<%# Eval("item_id") %>'
                                           class="btn btn-sm btn-outline-secondary py-0 px-2">Edit</a>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                    </tbody>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlNoReports" runat="server" Visible="false">
                            <div class="text-center py-5 text-muted">
                                <i class="fa fa-inbox fa-2x mb-2 d-block" style="color:#dde3ed;"></i>
                                <p class="mb-0" style="font-size:0.9rem;">No reports yet.</p>
                                <p class="small">Start by reporting a lost or found item.</p>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>

            <!-- Recent notifications -->
            <div class="col-lg-5">
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
                    <div style="padding:14px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;">
                        <span style="font-family:'Sora',sans-serif;font-weight:600;">Recent Notifications</span>
                        <a href="Pages/Messages/Notifications.aspx"
                           style="font-size:0.82rem;color:var(--primary-light);text-decoration:none;">View all</a>
                    </div>
                    <asp:Repeater ID="rptNotifications" runat="server">
                        <ItemTemplate>
                            <div class="d-flex gap-3 px-4 py-3" style="border-bottom:1px solid var(--border);">
                                <div style="width:34px;height:34px;border-radius:50%;background:#f0f2f8;flex-shrink:0;display:flex;align-items:center;justify-content:center;">
                                    <i class="fa fa-bell" style="font-size:0.8rem;color:var(--primary-light);"></i>
                                </div>
                                <div style="min-width:0;">
                                    <p class="mb-0" style="font-size:0.87rem;font-weight:500;"><%# Eval("title") %></p>
                                    <p class="mb-0 text-muted" style="font-size:0.81rem;"><%# Eval("message") %></p>
                                    <span class="text-muted" style="font-size:0.76rem;">
                                        <%# Eval("created_at", "{0:dd MMM yyyy hh:mm tt}") %>
                                    </span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoNotifs" runat="server" Visible="false">
                        <div class="text-center py-5 text-muted">
                            <i class="fa fa-bell-slash fa-2x mb-2 d-block" style="color:#dde3ed;"></i>
                            <p class="mb-0" style="font-size:0.9rem;">No new notifications</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>

        </div>

</asp:Content>
