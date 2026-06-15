<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ItemDetail.aspx.cs" Inherits="CampusLostFound.Pages.Items.ItemDetail" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%-- litUserName kept for code-behind compatibility --%>
    <asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

<!-- Back link -->
        <div class="mb-3">
            <a href="SearchItems.aspx" style="color:var(--muted);font-size:0.88rem;text-decoration:none;">
                <i class="fa fa-arrow-left me-1"></i>Back to Search
            </a>
        </div>

        <!-- success / error alerts -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
            CssClass="alert-success-custom d-flex align-items-center gap-2 mb-4">
            <i class="fa fa-circle-check"></i>
            <asp:Literal ID="litSuccess" runat="server"></asp:Literal>
        </asp:Panel>
        <asp:Panel ID="pnlError" runat="server" Visible="false"
            CssClass="alert-danger-custom d-flex align-items-center gap-2 mb-4">
            <i class="fa fa-circle-exclamation"></i>
            <asp:Literal ID="litError" runat="server"></asp:Literal>
        </asp:Panel>

        <div class="row g-4">

            <!-- item detail card -->
            <div class="col-lg-7">
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">

                    <!-- image -->
                    <asp:Panel ID="pnlImage" runat="server" Visible="false">
                        <asp:Image ID="imgItem" runat="server"
                            AlternateText="Item photo"
                            style="width:100%;height:260px;object-fit:cover;display:block;" />
                    </asp:Panel>
                    <asp:Panel ID="pnlNoImage" runat="server" Visible="false">
                        <div style="width:100%;height:160px;background:#eef1f7;display:flex;align-items:center;justify-content:center;font-size:2.5rem;color:var(--muted);">
                            <i class="fa fa-image"></i>
                        </div>
                    </asp:Panel>

                    <div class="p-4">
                        <!-- title and badges -->
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h5 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:4px;color:var(--primary);">
                                    <asp:Literal ID="litItemName" runat="server"></asp:Literal>
                                </h5>
                                <span style="font-size:0.85rem;color:var(--muted);">
                                    <asp:Literal ID="litCategory" runat="server"></asp:Literal>
                                </span>
                            </div>
                            <div class="d-flex flex-column align-items-end gap-1">
                                <asp:Literal ID="litTypeBadge" runat="server"></asp:Literal>
                                <asp:Literal ID="litStatusBadge" runat="server"></asp:Literal>
                                <asp:Literal ID="litMessageStatus" runat="server"></asp:Literal>
                            </div>
                        </div>

                        <hr class="divider" />

                        <!-- meta fields -->
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <p class="text-muted mb-1" style="font-size:0.8rem;">Location</p>
                                <p class="mb-0" style="font-size:0.92rem;font-weight:500;">
                                    <i class="fa fa-location-dot me-1" style="color:var(--accent);"></i>
                                    <asp:Literal ID="litLocation" runat="server"></asp:Literal>
                                </p>
                            </div>
                            <div class="col-6">
                                <p class="text-muted mb-1" style="font-size:0.8rem;">Date</p>
                                <p class="mb-0" style="font-size:0.92rem;font-weight:500;">
                                    <i class="fa fa-calendar me-1" style="color:var(--accent);"></i>
                                    <asp:Literal ID="litDate" runat="server"></asp:Literal>
                                </p>
                            </div>
                            <div class="col-6">
                                <p class="text-muted mb-1" style="font-size:0.8rem;">Reported On</p>
                                <p class="mb-0" style="font-size:0.92rem;font-weight:500;">
                                    <asp:Literal ID="litReportedDate" runat="server"></asp:Literal>
                                </p>
                            </div>
                            <div class="col-6">
                                <p class="text-muted mb-1" style="font-size:0.8rem;">Reported By</p>
                                <p class="mb-0" style="font-size:0.92rem;font-weight:500;">
                                    <asp:Literal ID="litReportedBy" runat="server"></asp:Literal>
                                </p>
                            </div>
                        </div>

                        <!-- description -->
                        <div>
                            <p class="text-muted mb-1" style="font-size:0.8rem;">Description</p>
                            <p class="mb-0" style="font-size:0.92rem;line-height:1.7;">
                                <asp:Literal ID="litDescription" runat="server"></asp:Literal>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- action column -->
            <div class="col-lg-5">

                <!-- contact reporter -->
                <asp:Panel ID="pnlMessage" runat="server">
                    <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);margin-bottom:16px;overflow:hidden;">
                        <div style="padding:14px 18px;border-bottom:1px solid var(--border);">
                            <span style="font-family:'Sora',sans-serif;font-weight:600;font-size:0.95rem;">Contact Reporter</span>
                        </div>
                        <div class="p-3">
                            <p style="font-size:0.85rem;color:var(--muted);margin-bottom:12px;">
                                Send a message to the person who submitted this report. Your contact details remain private.
                            </p>
                            <div class="mb-3">
                                <label class="form-label">Your Message</label>
                                <asp:TextBox ID="txtMessage" runat="server"
                                    CssClass="form-control"
                                    TextMode="MultiLine" Rows="3" MaxLength="500"
                                    placeholder="Hi, I think this might be my item..."></asp:TextBox>
                            </div>
                            <asp:Button ID="btnSendMessage" runat="server"
                                Text="Send Message"
                                CssClass="btn btn-outline-primary w-100"
                                OnClick="btnSendMessage_Click"
                                CausesValidation="false" />
                        </div>
                    </div>
                </asp:Panel>

                <!-- claim this item -->
                <asp:Panel ID="pnlClaim" runat="server">
                    <div style="background:var(--card-bg);border-radius:var(--radius);border:2px solid var(--accent);margin-bottom:16px;overflow:hidden;">
                        <div style="padding:14px 18px;border-bottom:1px solid #f5d98a;background:#fffbf0;">
                            <span style="font-family:'Sora',sans-serif;font-weight:600;font-size:0.95rem;color:var(--primary);">
                                <i class="fa fa-hand-holding-heart me-2" style="color:var(--accent);"></i>Claim This Item
                            </span>
                        </div>
                        <div class="p-3">
                            <p style="font-size:0.85rem;color:var(--muted);margin-bottom:12px;">
                                If this is your item, answer the security question to submit a claim.
                            </p>

                            <!-- security question -->
                            <div class="mb-3 p-3" style="background:#f8f9fc;border-radius:8px;border:1px solid var(--border);">
                                <p class="text-muted mb-1" style="font-size:0.78rem;">Security Question</p>
                                <p class="mb-0" style="font-size:0.92rem;font-weight:500;">
                                    <asp:Literal ID="litSecurityQuestion" runat="server"></asp:Literal>
                                </p>
                            </div>

                            <!-- link lost item (optional) -->
                            <div class="mb-3">
                                <label class="form-label">Link your lost item <span class="text-muted" style="font-weight:400;">(optional)</span></label>
                                <asp:DropDownList ID="ddlMyLostItem" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>

                            <!-- security answer -->
                            <div class="mb-3">
                                <label class="form-label">Your Answer <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtSecurityAnswer" runat="server"
                                    CssClass="form-control"
                                    placeholder="Type your answer here..."
                                    MaxLength="255"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAnswer" runat="server"
                                    ControlToValidate="txtSecurityAnswer"
                                    ErrorMessage="Answer is required to submit a claim."
                                    CssClass="text-danger" style="font-size:0.8rem;"
                                    Display="Dynamic"
                                    ValidationGroup="ClaimGroup"></asp:RequiredFieldValidator>
                            </div>

                            <asp:Button ID="btnSubmitClaim" runat="server"
                                Text="Submit Claim Request"
                                CssClass="btn btn-primary w-100"
                                OnClick="btnClaim_Click"
                                ValidationGroup="ClaimGroup" />

                            <p style="font-size:0.78rem;color:var(--muted);text-align:center;margin-top:8px;margin-bottom:0;">
                                An admin will review your claim before approval.
                            </p>
                        </div>
                    </div>
                </asp:Panel>

                <!-- mark as recovered (owner only) -->
                <asp:Panel ID="pnlMarkRecovered" runat="server" Visible="false">
                    <div style="background:var(--card-bg);border-radius:var(--radius);border:2px solid var(--success);overflow:hidden;">
                        <div class="p-4 text-center">
                            <p style="font-weight:600;margin-bottom:6px;color:var(--primary);">Did you recover your item?</p>
                            <p style="font-size:0.85rem;color:var(--muted);margin-bottom:16px;">
                                Mark this report as recovered to close it.
                            </p>
                            <asp:Button ID="btnMarkRecovered" runat="server"
                                Text="Mark as Recovered"
                                CssClass="btn btn-success px-4"
                                OnClick="btnMarkRecovered_Click"
                                CausesValidation="false"
                                OnClientClick="return confirm('Mark this item as recovered?');" />
                        </div>
                    </div>
                </asp:Panel>

            </div>
        </div>

</asp:Content>
