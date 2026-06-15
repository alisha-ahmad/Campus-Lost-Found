<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchItems.aspx.cs" Inherits="CampusLostFound.Pages.Items.SearchItems" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%-- litUserName kept for code-behind compatibility --%>
    <asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

<!-- page heading -->
        <div class="mb-4">
            <h4 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:2px;">Browse &amp; Search Items</h4>
            <p class="text-muted mb-0" style="font-size:0.9rem;">Search lost and found reports across campus</p>
        </div>

        <!-- filter bar -->
        <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);padding:20px;margin-bottom:24px;">
            <div class="row g-3 align-items-end">

                <div class="col-md-4">
                    <label class="form-label">Keyword Search</label>
                    <div class="input-group">
                        <span class="input-group-text"
                            style="background:#fafbfd;border:1.5px solid var(--border);border-right:none;border-radius:9px 0 0 9px;">
                            <i class="fa fa-search text-muted"></i>
                        </span>
                        <asp:TextBox ID="txtKeyword" runat="server" CssClass="form-control"
                            placeholder="Item name, description..."
                            style="border-left:none;border-radius:0 9px 9px 0;"></asp:TextBox>
                    </div>
                </div>

                <div class="col-md-2">
                    <label class="form-label">Type</label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-select">
                        <asp:ListItem Value="">All Types</asp:ListItem>
                        <asp:ListItem Value="lost">Lost Items</asp:ListItem>
                        <asp:ListItem Value="found">Found Items</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <label class="form-label">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                        <asp:ListItem Value="">All Categories</asp:ListItem>
                        <asp:ListItem Value="1">Electronics</asp:ListItem>
                        <asp:ListItem Value="2">ID / Cards</asp:ListItem>
                        <asp:ListItem Value="3">Bags / Backpacks</asp:ListItem>
                        <asp:ListItem Value="4">Keys</asp:ListItem>
                        <asp:ListItem Value="5">Wallets / Purses</asp:ListItem>
                        <asp:ListItem Value="6">Books / Stationery</asp:ListItem>
                        <asp:ListItem Value="7">Clothing / Accessories</asp:ListItem>
                        <asp:ListItem Value="8">Other</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <label class="form-label">Location</label>
                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control"
                        placeholder="e.g. Library"></asp:TextBox>
                </div>

                <div class="col-md-2">
                    <label class="form-label">Date From</label>
                    <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>

                <div class="col-12 d-flex gap-2">
                    <asp:Button ID="btnSearch" runat="server" Text="Search"
                        CssClass="btn btn-primary px-4" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="Clear Filters"
                        CssClass="btn btn-outline-secondary" OnClick="btnReset_Click"
                        CausesValidation="false" />
                </div>

            </div>
        </div>

        <!-- results header -->
        <div class="d-flex align-items-center justify-content-between mb-3">
            <p class="text-muted mb-0" style="font-size:0.9rem;">
                Showing <asp:Literal ID="litResultCount" runat="server" Text="0"></asp:Literal> result(s)
            </p>
            <div class="d-flex gap-2">
                <asp:LinkButton ID="lbtnGridView" runat="server"
                    CssClass="btn btn-sm btn-outline-secondary active"
                    OnClick="lbtnGridView_Click" CausesValidation="false">
                    <i class="fa fa-grip"></i>
                </asp:LinkButton>
                <asp:LinkButton ID="lbtnListView" runat="server"
                    CssClass="btn btn-sm btn-outline-secondary"
                    OnClick="lbtnListView_Click" CausesValidation="false">
                    <i class="fa fa-list"></i>
                </asp:LinkButton>
            </div>
        </div>

        <!-- results grid -->
        <asp:Panel ID="pnlResults" runat="server">
            <div class="row g-3" id="resultsGrid">
                <asp:Repeater ID="rptItems" runat="server">
                    <ItemTemplate>
                        <div class="col-sm-6 col-md-4 col-lg-3">
                            <div class="item-card">
                                <div class="item-img">
                                    <asp:Image ID="imgItem" runat="server"
                                        ImageUrl='<%# Eval("image_path") == DBNull.Value ? "" : Eval("image_path") %>'
                                        CssClass="w-100 h-100"
                                        style="object-fit:cover;"
                                        AlternateText="Item photo" />
                                    <asp:Panel ID="pnlNoImg" runat="server"
                                        Visible='<%# Convert.IsDBNull(Eval("image_path")) || string.IsNullOrEmpty(Eval("image_path").ToString()) %>'>
                                        <i class="fa fa-image"></i>
                                    </asp:Panel>
                                </div>
                                <div class="item-body">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <span class="item-title"><%# Eval("item_name") %></span>
                                        <span class='status-badge <%# Eval("item_type")!=DBNull.Value && Eval("item_type").ToString()=="lost" ? "badge-lost" : "badge-found" %>'>
                                            <%# Eval("item_type") %>
                                        </span>
                                    </div>
                                    <div class="item-meta mb-1">
                                        <i class="fa fa-tag me-1"></i><%# Eval("category_name") %>
                                    </div>
                                    <div class="item-meta mb-1">
                                        <i class="fa fa-location-dot me-1"></i><%# Eval("location") %>
                                    </div>
                                    <div class="item-meta mb-2">
                                        <i class="fa fa-calendar me-1"></i><%# Eval("reported_date", "{0:dd MMM yyyy}") %>
                                    </div>
                                    <a href='ItemDetail.aspx?id=<%# Eval("item_id") %>&type=<%# Eval("item_type") %>'
                                       class="btn btn-sm btn-primary w-100">View Details</a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

        <!-- empty state -->
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="text-center py-5 text-muted">
                <i class="fa fa-magnifying-glass fa-2x mb-3 d-block" style="color:#dde3ed;"></i>
                <p class="mb-1" style="font-size:0.95rem;font-weight:500;">No items match your search.</p>
                <p class="small mb-0">Try different keywords or remove some filters.</p>
            </div>
        </asp:Panel>

</asp:Content>
