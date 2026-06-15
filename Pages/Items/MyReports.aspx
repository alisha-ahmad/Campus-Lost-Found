<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyReports.aspx.cs" Inherits="CampusLostFound.Pages.Items.MyReports" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%-- litUserName kept for code-behind compatibility --%>
    <asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

<!-- page heading -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-4">
            <div>
                <h4 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:2px;">My Reports</h4>
                <p class="text-muted mb-0" style="font-size:0.9rem;">Manage all your lost and found reports</p>
            </div>
            <div class="d-flex gap-2">
                <a href="ReportLostItem.aspx" class="btn btn-sm btn-danger px-3">
                    <i class="fa fa-plus me-1"></i><span class="d-none d-sm-inline">Report</span> Lost
                </a>
                <a href="ReportFoundItem.aspx" class="btn btn-sm btn-success px-3">
                    <i class="fa fa-plus me-1"></i><span class="d-none d-sm-inline">Report</span> Found
                </a>
            </div>
        </div>

        <!-- success alert -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
            CssClass="alert-success-custom d-flex align-items-center gap-2 mb-4">
            <i class="fa fa-circle-check"></i>
            <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- filter tabs -->
        <ul class="nav nav-pills mb-3" style="gap:6px;">
            <li class="nav-item">
                <asp:LinkButton ID="lbtnAll" runat="server" CssClass="nav-link active"
                    OnClick="lbtnAll_Click" CausesValidation="false">
                    All Reports
                </asp:LinkButton>
            </li>
            <li class="nav-item">
                <asp:LinkButton ID="lbtnLost" runat="server" CssClass="nav-link"
                    OnClick="lbtnLost_Click" CausesValidation="false">
                    <i class="fa fa-triangle-exclamation me-1"></i>Lost
                </asp:LinkButton>
            </li>
            <li class="nav-item">
                <asp:LinkButton ID="lbtnFound" runat="server" CssClass="nav-link"
                    OnClick="lbtnFound_Click" CausesValidation="false">
                    <i class="fa fa-box-archive me-1"></i>Found
                </asp:LinkButton>
            </li>
        </ul>

        <!-- reports table -->
        <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
            <div style="overflow-x:auto;-webkit-overflow-scrolling:touch;">
                <asp:Repeater ID="rptReports" runat="server">
                    <HeaderTemplate>
                        <table class="table table-hover mb-0" style="min-width:700px;">
                            <thead>
                                <tr>
                                    <th class="ps-4" style="width:32%;">Item</th>
                                    <th>Type</th>
                                    <th>Category</th>
                                    <th>Location</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>

                    <ItemTemplate>
                        <tr>
                            <td class="ps-4">
                                <div class="d-flex align-items-center gap-3">
                                    <div style="width:38px;height:38px;border-radius:8px;background:#eef1f7;flex-shrink:0;overflow:hidden;display:flex;align-items:center;justify-content:center;color:var(--muted);font-size:1rem;">
                                        <asp:Image ID="imgThumb" runat="server"
                                            ImageUrl='<%# Eval("image_path") == DBNull.Value ? "" : Eval("image_path") %>'
                                            style="width:100%;height:100%;object-fit:cover;"
                                            Visible='<%# Eval("image_path") != DBNull.Value && Eval("image_path").ToString() != "" %>' />
                                        <i class="fa fa-image"></i>
                                    </div>
                                    <div>
                                        <p class="mb-0" style="font-size:0.92rem;font-weight:500;"><%# Eval("item_name") %></p>
                                        <p class="text-muted mb-0" style="font-size:0.78rem;">
                                            <%# Eval("description") == DBNull.Value ? "" : (Eval("description").ToString().Length > 45 ? Eval("description").ToString().Substring(0,45)+"..." : Eval("description").ToString()) %>
                                        </p>
                                    </div>
                                </div>
                            </td>

                            <td>
                                <span class='status-badge <%# (string)Eval("item_type")=="lost" ? "badge-lost" : "badge-found" %>'>
                                    <%# Eval("item_type") == DBNull.Value ? "" : Eval("item_type").ToString() %>
                                </span>
                            </td>

                            <td class="text-muted" style="font-size:0.88rem;"><%# Eval("category_name") %></td>
                            <td class="text-muted" style="font-size:0.88rem;"><%# Eval("location") %></td>
                            <td class="text-muted" style="font-size:0.85rem;white-space:nowrap;">
                                <%# Eval("reported_date", "{0:dd MMM yyyy}") %>
                            </td>

                            <td>
                                <span class='status-badge <%# GetStatusBadgeClass((string)Eval("status")) %>'>
                                    <%# Eval("status") == DBNull.Value ? "" : Eval("status").ToString() %>
                                </span>
                            </td>

                            <td class="text-end pe-4">
                                <div class="d-flex gap-1 justify-content-end">
                                    <a href='ItemDetail.aspx?id=<%# Eval("item_id") %>&type=<%# Eval("item_type") %>'
                                       class="btn btn-sm btn-outline-primary py-0 px-2" title="View">
                                        <i class="fa fa-eye"></i>
                                    </a>
                                    <a href='EditReport.aspx?id=<%# Eval("item_id") %>&type=<%# Eval("item_type") %>'
                                       class="btn btn-sm btn-outline-secondary py-0 px-2" title="Edit">
                                        <i class="fa fa-pen"></i>
                                    </a>
                                    <asp:LinkButton ID="lbtnDelete" runat="server"
                                        CommandArgument='<%# Eval("item_id") + "," + Eval("item_type") %>'
                                        OnCommand="lbtnDelete_Command"
                                        CssClass="btn btn-sm btn-outline-danger py-0 px-2"
                                        OnClientClick="return confirm('Delete this report? This cannot be undone.');"
                                        CausesValidation="false" title="Delete">
                                        <i class="fa fa-trash"></i>
                                    </asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>

                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                    <div class="text-center py-5 text-muted">
                        <i class="fa fa-folder-open fa-2x mb-2 d-block" style="color:#dde3ed;"></i>
                        <p class="mb-0">No reports found.</p>
                        <p class="small">Start by reporting a lost or found item.</p>
                    </div>
                </asp:Panel>
            </div>
        </div>

</asp:Content>
