<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminManageClaims.aspx.cs" Inherits="CampusLostFound.Pages.Admin.AdminManageClaims" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Claims — Campus Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="../../shared_style.css" />
</head>
<body>
<form id="form1" runat="server">

    <!-- sidebar overlay -->
    <div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

    <!-- top navbar -->
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
            <a class="nav-link" href="AdminDashboard.aspx">
                <i class="fa-solid fa-chart-line"></i> Overview
            </a>

            <div class="nav-section-label">Manage</div>
            <a class="nav-link" href="AdminManageItems.aspx">
                <i class="fa-solid fa-boxes-stacked"></i> Manage Items
            </a>
            <a class="nav-link active" href="AdminManageClaims.aspx">
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
                    <i class="fa-solid fa-hand-holding-heart me-2" style="color:var(--accent);"></i>Manage Claims
                </h4>
                <p class="text-muted mb-0" style="font-size:0.85rem;margin-top:2px;">
                    Review, approve or reject item claims
                </p>
            </div>
        </div>

        <!-- status message -->
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="d-block mb-4"></asp:Label>

        <!-- claims table card -->
        <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
            <div style="padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px;">
                <i class="fa-solid fa-list-check" style="color:var(--primary-light);"></i>
                <span style="font-family:'Sora',sans-serif;font-weight:600;">All Claims</span>
            </div>
            <div style="overflow-x:auto;">
                <asp:GridView ID="gvManageClaims" runat="server"
                    CssClass="table table-hover mb-0"
                    AutoGenerateColumns="False"
                    DataKeyNames="claim_id"
                    EmptyDataText="No claims found."
                    OnRowCommand="gvManageClaims_RowCommand">
                    <EmptyDataRowStyle CssClass="text-center text-muted" />
                    <Columns>
                        <asp:BoundField DataField="claim_id"      HeaderText="ID"
                            ItemStyle-CssClass="text-muted" ItemStyle-Width="60px" />
                        <asp:BoundField DataField="item_name"     HeaderText="Item" />
                        <asp:BoundField DataField="claimant_name" HeaderText="Claimant" />
                        <asp:BoundField DataField="claim_date"    HeaderText="Date"
                            DataFormatString="{0:dd MMM yyyy}" />
                        <asp:TemplateField HeaderText="Status" ItemStyle-Width="110px">
                            <ItemTemplate>
                                <span class='status-badge <%# GetStatusBadgeClass(Eval("status").ToString()) %>'>
                                    <%# Eval("status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="security_answer_provided" HeaderText="Security Answer" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="170px" ItemStyle-CssClass="text-nowrap">
                            <ItemTemplate>
                                <asp:Button ID="btnApprove" runat="server"
                                    Text="Approve"
                                    CssClass="btn btn-success btn-sm me-1"
                                    CommandName="ApproveClaim"
                                    CommandArgument='<%# Eval("claim_id") %>'
                                    OnClientClick="return confirm('Approve this claim?');" />
                                <asp:Button ID="btnReject" runat="server"
                                    Text="Reject"
                                    CssClass="btn btn-danger btn-sm"
                                    CommandName="RejectClaim"
                                    CommandArgument='<%# Eval("claim_id") %>'
                                    OnClientClick="return confirm('Reject this claim?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
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
