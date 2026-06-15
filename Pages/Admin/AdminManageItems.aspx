<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminManageItems.aspx.cs" Inherits="CampusLostFound.Pages.Admin.AdminManageItems" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Items — Campus Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="../../shared_style.css" />
    <style>
        /* page-specific styles */
        .thumb {
            width: 46px; height: 46px; object-fit: cover;
            border-radius: 8px; border: 1px solid var(--border);
        }
        .no-thumb {
            width: 46px; height: 46px; background: #f0f2f7;
            border-radius: 8px; display: flex; align-items: center;
            justify-content: center; color: var(--muted); font-size: 1.1rem;
        }
        .badge-type { border-radius: 20px; padding: .25rem .7rem; font-size: .75rem; font-weight: 600; }
        .flag-badge {
            display: inline-block; border-radius: 20px;
            padding: .18rem .55rem; font-size: .7rem;
            font-weight: 700; margin-left: .3rem;
        }
        .flag-inappropriate { background: #fde8e8; color: #c0392b; }
        .flag-spam          { background: #fef9e7; color: #b7770d; }
        .flag-duplicate     { background: #fef3cd; color: #7d6608; }
        .status-pill {
            display: inline-block; border-radius: 20px;
            padding: .22rem .7rem; font-size: .74rem; font-weight: 600;
        }
        .pill-pending   { background: #fff3cd; color: #856404; }
        .pill-available { background: #d1f2eb; color: #1e8449; }
        .pill-claimed   { background: #d6eaf8; color: #1a5276; }
        .pill-flagged   { background: #fde8e8; color: #c0392b; }
        .pill-duplicate { background: #fef9e7; color: #784212; }
        .pill-recovered,
        .pill-returned  { background: #e8f8f5; color: #1a5276; }
        .btn-action {
            border: none; border-radius: 7px; padding: .28rem .6rem;
            font-size: .78rem; font-weight: 600; cursor: pointer;
            display: inline-flex; align-items: center; gap: .3rem; transition: .15s;
        }
        .btn-flag-inapt { background: #fde8e8; color: #c0392b; }
        .btn-flag-inapt:hover { background: #c0392b; color: #fff; }
        .btn-flag-spam  { background: #fef9e7; color: #b7770d; }
        .btn-flag-spam:hover  { background: #b7770d; color: #fff; }
        .btn-del        { background: #f8d7da; color: #721c24; }
        .btn-del:hover  { background: #721c24; color: #fff; }
        .truncate-text  { max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .empty-state    { text-align: center; padding: 3.5rem 1rem; color: var(--muted); }
        .empty-state i  { font-size: 2.8rem; margin-bottom: .75rem; display: block; }
        .grid-table th  { white-space: nowrap; }
    </style>
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
            <a class="nav-link active" href="AdminManageItems.aspx">
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
                    <i class="fa-solid fa-boxes-stacked me-2" style="color:var(--accent);"></i>Manage Items
                </h4>
                <p class="text-muted mb-0" style="font-size:0.85rem;margin-top:2px;">
                    Moderate, flag or remove reported items
                </p>
            </div>
        </div>

        <!-- status message -->
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="d-block mb-4" />

        <!-- filter card -->
        <div class="mb-4" style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);padding:1.25rem 1.5rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);">
            <div class="row g-3 align-items-end">
                <div class="col-12 col-sm-auto">
                    <label class="form-label mb-1">Item Type</label>
                    <asp:DropDownList ID="ddlTypeFilter" runat="server" CssClass="form-select form-select-sm">
                        <asp:ListItem Value="">All Types</asp:ListItem>
                        <asp:ListItem Value="lost">Lost</asp:ListItem>
                        <asp:ListItem Value="found">Found</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-12 col-sm-auto d-flex gap-3 align-items-center pt-1">
                    <div class="form-check mb-0">
                        <asp:CheckBox ID="chkShowFlagged" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" style="font-size:.84rem;">Flagged Only</label>
                    </div>
                    <div class="form-check mb-0">
                        <asp:CheckBox ID="chkShowDuplicates" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" style="font-size:.84rem;">Duplicates Only</label>
                    </div>
                </div>
                <div class="col-12 col-sm-auto">
                    <asp:Button ID="btnFilter" runat="server" Text="Apply Filter"
                        CssClass="btn btn-sm btn-primary px-4"
                        OnClick="btnFilter_Click" />
                </div>
            </div>
        </div>

        <!-- items grid -->
        <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
            <div style="padding:14px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;">
                <span style="font-family:'Sora',sans-serif;font-weight:600;">
                    <i class="fa-solid fa-list me-2" style="color:var(--accent);"></i>All Reported Items
                </span>
                <small class="text-muted">Use actions to moderate content</small>
            </div>
            <div style="overflow-x:auto;">
                <asp:GridView ID="gvItems" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="table table-hover mb-0 grid-table"
                    GridLines="None"
                    OnRowCommand="gvItems_RowCommand"
                    EmptyDataText="">
                    <Columns>

                        <!-- image -->
                        <asp:TemplateField HeaderText="Image">
                            <ItemTemplate>
                                <asp:Image ID="imgThumb" runat="server"
                                    ImageUrl='<%# string.IsNullOrEmpty(Eval("image_path")?.ToString()) ? "" : ResolveUrl("~/" + Eval("image_path")) %>'
                                    CssClass="thumb" AlternateText="item"
                                    Visible='<%# !string.IsNullOrEmpty(Eval("image_path")?.ToString()) %>' />
                                <asp:Panel ID="pnlNoThumb" runat="server"
                                    Visible='<%# string.IsNullOrEmpty(Eval("image_path")?.ToString()) %>'>
                                    <div class="no-thumb"><i class="fas fa-image"></i></div>
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- type -->
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <span class='badge-type <%# Eval("item_type").ToString()=="lost" ? "badge-lost" : "badge-found" %>'>
                                    <%# Eval("item_type").ToString()=="lost"
                                        ? "<i class='fas fa-exclamation-circle me-1'></i>Lost"
                                        : "<i class='fas fa-check-circle me-1'></i>Found" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- item name + flags -->
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <strong><%# Eval("item_name") %></strong>
                                <%# (bool)Eval("is_flagged")
                                    ? "<span class='flag-badge flag-inappropriate'><i class='fas fa-flag'></i> Flagged</span>"
                                    : "" %>
                                <%# (bool)Eval("is_duplicate")
                                    ? "<span class='flag-badge flag-duplicate'><i class='fas fa-copy'></i> Duplicate</span>"
                                    : "" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- description -->
                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <span class="truncate-text d-block" title='<%# Eval("description") %>'>
                                    <%# Eval("description") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- location -->
                        <asp:BoundField DataField="location"      HeaderText="Location" />

                        <!-- category -->
                        <asp:BoundField DataField="category_name" HeaderText="Category" />

                        <!-- reporter -->
                        <asp:TemplateField HeaderText="Reporter">
                            <ItemTemplate>
                                <div><%# Eval("reporter_name") %></div>
                                <small class="text-muted"><%# Eval("reporter_email") %></small>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- status -->
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%# GetStatusPill(Eval("status")?.ToString(), (bool)Eval("is_flagged")) %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- flag reason -->
                        <asp:TemplateField HeaderText="Flag Reason">
                            <ItemTemplate>
                                <span class="text-muted" style="font-size:.8rem;">
                                    <%# string.IsNullOrEmpty(Eval("flag_reason")?.ToString()) ? "—" : Eval("flag_reason") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- reported date -->
                        <asp:TemplateField HeaderText="Reported">
                            <ItemTemplate>
                                <span style="white-space:nowrap;font-size:.82rem;">
                                    <%# Convert.ToDateTime(Eval("reported_date")).ToString("dd MMM yyyy") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <!-- actions -->
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="d-flex flex-wrap gap-1">
                                    <asp:LinkButton runat="server"
                                        CommandName="FlagInappropriate"
                                        CommandArgument='<%# Eval("item_id") %>'
                                        CssClass="btn-action btn-flag-inapt"
                                        OnClientClick="return confirm('Flag as inappropriate and remove?');"
                                        ToolTip="Flag: Inappropriate">
                                        <i class="fas fa-ban"></i> Inappropriate
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server"
                                        CommandName="FlagSpam"
                                        CommandArgument='<%# Eval("item_id") %>'
                                        CssClass="btn-action btn-flag-spam"
                                        OnClientClick="return confirm('Flag as spam and remove?');"
                                        ToolTip="Flag: Spam">
                                        <i class="fas fa-exclamation-triangle"></i> Spam
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server"
                                        CommandName="DeleteItem"
                                        CommandArgument='<%# Eval("item_id") %>'
                                        CssClass="btn-action btn-del"
                                        OnClientClick="return confirm('Permanently delete this item?');"
                                        ToolTip="Delete permanently">
                                        <i class="fas fa-trash"></i> Delete
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                    <EmptyDataTemplate>
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <p class="mb-0 fw-semibold">No items match the selected filters.</p>
                            <small class="text-muted">Try adjusting the filter criteria above.</small>
                        </div>
                    </EmptyDataTemplate>
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

    // auto-hide alert after 4 seconds
    (function () {
        var msg = document.querySelector('.alert.d-block');
        if (msg && msg.innerText.trim() !== '') {
            setTimeout(function () {
                msg.style.transition = 'opacity .5s';
                msg.style.opacity = '0';
                setTimeout(function () { msg.style.display = 'none'; }, 500);
            }, 4000);
        }
    })();
</script>
</body>
</html>
