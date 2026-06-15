<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="CampusLostFound.Pages.Admin.AdminDashboard" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard — Campus Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="../../shared_style.css" />
</head>
<body>
<form id="form2" runat="server">

    <!-- sidebar overlay -->
    <!-- on mobile: tap to close -->
    <div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

    <!-- top navbar (fixed) -->
    <nav class="navbar fixed-top app-navbar px-3 d-flex align-items-center justify-content-between">
        <div class="d-flex align-items-center gap-3">
            <button class="hamburger-btn" type="button" onclick="toggleSidebar()" aria-label="Toggle sidebar">
                <i class="fa-solid fa-bars"></i>
            </button>
            <a class="navbar-brand mb-0" href="AdminDashboard.aspx">
                Campus <span>L&amp;F</span>
                <small style="font-size:0.65rem;opacity:0.55;font-weight:400;margin-left:4px;">Admin</small>
            </a>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span class="user-info d-none d-md-inline">
                <i class="fa-solid fa-shield-halved me-1" style="color:var(--accent);"></i>Administrator
            </span>
            <asp:LinkButton ID="lbtnLogout" runat="server" OnClick="lbtnLogout_Click"
                CssClass="btn btn-sm"
                style="background:rgba(255,255,255,0.12);color:#fff;border:1px solid rgba(255,255,255,0.22);border-radius:8px;font-size:0.88rem;">
                <i class="fa-solid fa-right-from-bracket me-1"></i><span class="d-none d-sm-inline">Logout</span>
            </asp:LinkButton>
        </div>
    </nav>

    <!-- sidebar -->
    <div class="sidebar-wrapper" id="sidebarWrapper">
        <div class="sidebar-nav">
            <div class="nav-section-label">Dashboard</div>
            <a class="nav-link active" href="AdminDashboard.aspx">
                <i class="fa-solid fa-chart-line"></i> Overview
            </a>

            <div class="nav-section-label">Manage</div>
            <a class="nav-link" href="AdminManageItems.aspx">
                <i class="fa-solid fa-boxes-stacked"></i> Manage Items
            </a>
            <a class="nav-link" href="AdminManageClaims.aspx">
                <i class="fa-solid fa-hand-holding-heart"></i> Manage Claims
            </a>

            <div class="nav-section-label">Account</div>
            <a class="nav-link" href="../../UserDashboard.aspx">
                <i class="fa-solid fa-arrow-left"></i> User View
            </a>
        </div>

        </div>

    <!-- main content -->
    <div class="main-content-fluid">

        <!-- page heading -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-4">
            <div>
                <h4 style="margin:0;font-size:1.35rem;">
                    <i class="fa-solid fa-chart-line me-2" style="color:var(--accent);"></i>Admin Dashboard
                </h4>
                <p class="text-muted mb-0" style="font-size:0.85rem;margin-top:2px;">
                    System overview &amp; activity monitor
                </p>
            </div>
        </div>

        <!-- stat cards -->
        <div class="stats-grid mb-4">
            <div class="stat-card-color" style="background:linear-gradient(135deg,var(--primary-light),var(--primary));">
                <div class="stat-num"><asp:Label ID="lblTotalReports" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label"><i class="fa-solid fa-file-lines me-1"></i>Total Reports</div>
            </div>
            <div class="stat-card-color" style="background:linear-gradient(135deg,#1a6b45,#27ae60);">
                <div class="stat-num"><asp:Label ID="lblRecoveredItems" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label"><i class="fa-solid fa-circle-check me-1"></i>Recovered</div>
            </div>
            <div class="stat-card-color" style="background:linear-gradient(135deg,#b7770d,#e8a020);">
                <div class="stat-num"><asp:Label ID="lblPendingClaims" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label"><i class="fa-solid fa-clock me-1"></i>Pending Claims</div>
            </div>
            <div class="stat-card-color" style="background:linear-gradient(135deg,#922b21,#c0392b);">
                <div class="stat-num"><asp:Label ID="lblFlaggedItems" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label"><i class="fa-solid fa-flag me-1"></i>Flagged Items</div>
            </div>
            <div class="stat-card-color" style="background:linear-gradient(135deg,#5b21b6,#7c3aed);">
                <div class="stat-num"><asp:Label ID="lblDuplicateItems" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label"><i class="fa-solid fa-copy me-1"></i>Duplicates</div>
            </div>
            <div class="stat-card-color" style="background:linear-gradient(135deg,#0e7490,#0891b2);">
                <div class="stat-num"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label"><i class="fa-solid fa-users me-1"></i>Total Users</div>
            </div>
        </div>

        <!-- suggested duplicates -->
        <asp:Panel ID="pnlDuplicates" runat="server" Visible="false" CssClass="mb-4"
            style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
            <div style="padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px;">
                <i class="fa-solid fa-copy" style="color:var(--warning);"></i>
                <span style="font-family:'Sora',sans-serif;font-weight:600;">Suggested Duplicates</span>
                <span class="badge badge-pending ms-auto">Review Required</span>
            </div>
            <div style="overflow-x:auto;">
                <asp:Repeater ID="rptDuplicates" runat="server" OnItemCommand="rptDuplicates_ItemCommand">
                    <HeaderTemplate>
                        <table class="table table-hover mb-0">
                            <thead><tr><th>Item 1</th><th>Item 2</th><th style="text-align:right;padding-right:20px;">Action</th></tr></thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("item_name_1") %></td>
                            <td><%# Eval("item_name_2") %></td>
                            <td style="text-align:right;padding-right:20px;">
                                <asp:LinkButton runat="server" CommandName="ConfirmDuplicate"
                                    CommandArgument='<%# Eval("item_id_1") + "," + Eval("item_id_2") %>'
                                    CssClass="btn btn-sm btn-warning">
                                    <i class="fa-solid fa-check me-1"></i>Confirm Duplicate
                                </asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></tbody></table></FooterTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

        <!-- flagged items -->
        <div class="mb-4" style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
            <div style="padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px;">
                <i class="fa-solid fa-flag" style="color:var(--danger);"></i>
                <span style="font-family:'Sora',sans-serif;font-weight:600;">Flagged Items</span>
            </div>
            <div style="overflow-x:auto;">
                <asp:GridView ID="gvFlaggedItems" runat="server"
                    CssClass="table table-hover mb-0"
                    AutoGenerateColumns="False"
                    EmptyDataText="No flagged items."
                    OnRowCommand="gvFlaggedItems_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="item_name"     HeaderText="Item"     />
                        <asp:BoundField DataField="reporter_name" HeaderText="Reporter" />
                        <asp:BoundField DataField="flag_reason"   HeaderText="Reason"   />
                        <asp:TemplateField HeaderText="Action" ItemStyle-Width="110px">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="DeleteItem"
                                    CommandArgument='<%# Eval("item_id") %>'
                                    CssClass="btn btn-sm btn-danger"
                                    OnClientClick="return confirm('Delete this flagged item?');">
                                    <i class="fa-solid fa-trash me-1"></i>Delete
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- activitylogs -->
        <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
            <div style="padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px;">
                <i class="fa-solid fa-clock-rotate-left" style="color:var(--primary-light);"></i>
                <span style="font-family:'Sora',sans-serif;font-weight:600;">Recent Activity Logs</span>
            </div>
            <div style="overflow-x:auto;">
                <asp:GridView ID="gvActivityLogs" runat="server"
                    CssClass="table table-hover mb-0"
                    AutoGenerateColumns="False"
                    EmptyDataText="No activity logs found.">
                    <Columns>
                        <asp:BoundField DataField="full_name"   HeaderText="User"   />
                        <asp:BoundField DataField="action"      HeaderText="Action" />
                        <asp:BoundField DataField="entity_type" HeaderText="Entity" />
                        <asp:BoundField DataField="created_at"  HeaderText="Date"
                            DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div><!-- /main-content-fluid -->

</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar() {
        document.getElementById('sidebarWrapper').classList.toggle('show');
        document.getElementById('sidebarOverlay').classList.toggle('show');
    }
    function closeSidebar() {
        document.getElementById('sidebarWrapper').classList.remove('show');
        document.getElementById('sidebarOverlay').classList.remove('show');
    }
</script>
</body>
</html>
