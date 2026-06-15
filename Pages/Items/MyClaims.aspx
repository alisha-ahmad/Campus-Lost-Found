<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyClaims.aspx.cs" Inherits="CampusLostFound.Pages.Items.MyClaims" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%-- litUserName kept for code-behind compatibility --%>
    <asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

<!-- page heading -->
        <div class="mb-4">
            <h4 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:2px;">My Claims</h4>
            <p class="text-muted mb-0" style="font-size:0.9rem;">Track the status of your item claim requests</p>
        </div>

        <!-- success alert -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
            CssClass="alert-success-custom d-flex align-items-center gap-2 mb-4">
            <i class="fa fa-circle-check"></i>
            <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- claims list -->
        <asp:Repeater ID="rptClaims" runat="server" OnItemCommand="rptClaims_ItemCommand">
            <ItemTemplate>
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);margin-bottom:14px;">
                    <div class="p-3">
                        <div class="row g-3 align-items-center">

                            <!-- item name & date -->
                            <div class="col-md-5">
                                <div class="d-flex align-items-center gap-3">
                                    <div style="width:44px;height:44px;border-radius:9px;background:#eef1f7;flex-shrink:0;display:flex;align-items:center;justify-content:center;color:var(--muted);font-size:1.1rem;">
                                        <i class="fa fa-box"></i>
                                    </div>
                                    <div>
                                        <p style="font-weight:600;font-size:0.93rem;margin-bottom:2px;"><%# Eval("ItemName") %></p>
                                        <p class="text-muted mb-0" style="font-size:0.8rem;">
                                            Submitted <%# Eval("ClaimDate", "{0:dd MMM yyyy}") %>
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <!-- status -->
                            <div class="col-md-2 text-center">
                                <p class="text-muted mb-1" style="font-size:0.78rem;">Status</p>
                                <span class='status-badge <%# GetClaimBadgeClass((string)Eval("Status")) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </div>

                            <!-- collection code -->
                            <div class="col-md-3 text-center">
                                <asp:Panel ID="pnlCode" runat="server"
                                    Visible='<%# Eval("CollectionCode") != null && Eval("CollectionCode").ToString() != "" %>'>
                                    <p class="text-muted mb-1" style="font-size:0.78rem;">Collection Code</p>
                                    <div style="font-family:'Sora',sans-serif;font-size:1.4rem;font-weight:700;letter-spacing:0.15em;color:var(--success);background:#edf7f2;border-radius:8px;padding:4px 12px;display:inline-block;border:1.5px solid #a8dfc4;">
                                        <%# Eval("CollectionCode") %>
                                    </div>
                                    <p class="text-muted mt-1 mb-0" style="font-size:0.78rem;">Give this code to the finder</p>
                                </asp:Panel>
                                <asp:Panel ID="pnlPending" runat="server"
                                    Visible='<%# Eval("Status") != null && Eval("Status").ToString() != "approved" %>'>
                                    <p class="text-muted mb-0" style="font-size:0.82rem;">Awaiting admin review</p>
                                </asp:Panel>
                            </div>

                            <!-- actions -->
                            <div class="col-md-2 text-end">
                                <a href='ItemDetail.aspx?id=<%# Eval("LostItemId") %>&type=lost'
                                   class="btn btn-sm btn-outline-primary mb-1 d-block">View Item</a>
                                <a href='../Messages/Messages.aspx?claimId=<%# Eval("ClaimId") %>'
                                   class="btn btn-sm btn-outline-secondary d-block">
                                    <i class="fa fa-comments me-1"></i>Message
                                </a>
                            </div>

                        </div>

                        <!-- admin notes -->
                        <asp:Panel ID="pnlAdminNotes" runat="server"
                            Visible='<%# Eval("AdminNotes") != null && Eval("AdminNotes").ToString() != "" %>'>
                            <hr class="divider" />
                            <div class="d-flex gap-2 align-items-start" style="background:#f8f9fc;border-radius:8px;padding:12px;">
                                <i class="fa fa-circle-info text-muted mt-1" style="font-size:0.85rem;"></i>
                                <div>
                                    <p style="font-weight:600;font-size:0.82rem;margin-bottom:2px;">Admin Note</p>
                                    <p class="text-muted mb-0" style="font-size:0.85rem;"><%# Eval("AdminNotes") %></p>
                                </div>
                            </div>
                        </asp:Panel>

                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- empty state -->
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
            <div class="text-center py-5 text-muted">
                <i class="fa fa-hand-holding-heart fa-2x mb-2 d-block" style="color:#dde3ed;"></i>
                <p class="mb-2">No claims submitted yet.</p>
                <a href="SearchItems.aspx" class="btn btn-sm btn-primary">Browse Items</a>
            </div>
        </asp:Panel>

        <!-- collection code entry -->
        <div style="background:var(--card-bg);border-radius:var(--radius);border:2px solid var(--primary-light);overflow:hidden;margin-top:24px;">
            <div style="padding:14px 20px;border-bottom:1px solid var(--border);background:#f0f4ff;">
                <span style="font-family:'Sora',sans-serif;font-weight:600;color:var(--primary);">
                    <i class="fa fa-key me-2" style="color:var(--primary-light);"></i>Enter Collection Code
                </span>
            </div>
            <div class="p-4">
                <p class="text-muted mb-3" style="font-size:0.85rem;">
                    If you are the finder, enter the collection code provided by the owner to confirm the item has been returned.
                </p>
                <div class="row g-2 align-items-end" style="max-width:440px;">
                    <div class="col">
                        <label class="form-label">Collection Code</label>
                        <asp:TextBox ID="txtCollectionCode" runat="server" CssClass="form-control"
                            MaxLength="8" placeholder="8-character code"
                            style="font-size:1.2rem;letter-spacing:0.18em;font-family:'Sora',sans-serif;text-align:center;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCode" runat="server"
                            ControlToValidate="txtCollectionCode"
                            ErrorMessage="Please enter the collection code."
                            CssClass="text-danger" Display="Dynamic"
                            style="font-size:0.8rem;"
                            ValidationGroup="CodeGroup"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revCode" runat="server"
                            ControlToValidate="txtCollectionCode"
                            ValidationExpression="^[A-Za-z0-9]{8}$"
                            ErrorMessage="Code must be exactly 8 alphanumeric characters."
                            CssClass="text-danger" Display="Dynamic"
                            style="font-size:0.8rem;"
                            ValidationGroup="CodeGroup"></asp:RegularExpressionValidator>
                    </div>
                    <div class="col-auto">
                        <asp:Button ID="btnVerifyCode" runat="server"
                            Text="Verify &amp; Close"
                            CssClass="btn btn-primary"
                            OnClick="btnVerifyCode_Click"
                            ValidationGroup="CodeGroup" />
                    </div>
                </div>
            </div>
        </div>

</asp:Content>
