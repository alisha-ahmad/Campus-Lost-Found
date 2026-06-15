<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditReport.aspx.cs" Inherits="CampusLostFound.Pages.Items.EditReport" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%-- litUserName kept for code-behind compatibility --%>
    <asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

<!-- page heading -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-4">
            <div>
                <h4 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:2px;">
                    Edit Report <asp:Literal ID="litReportType" runat="server"></asp:Literal>
                </h4>
                <p class="text-muted mb-0" style="font-size:0.9rem;">Update the details of your report</p>
            </div>
            <a href="MyReports.aspx" class="btn btn-sm btn-outline-secondary">
                <i class="fa fa-arrow-left me-1"></i> Back to My Reports
            </a>
        </div>

        <!-- alerts -->
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

            <!-- left column: form fields -->
            <div class="col-lg-8">

                <!-- item details -->
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;margin-bottom:20px;">
                    <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
                        <span style="font-family:'Sora',sans-serif;font-weight:600;">Item Details</span>
                    </div>
                    <div class="p-4">
                        <div class="row g-3">

                            <div class="col-md-6">
                                <label class="form-label">Item Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtItemName" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvItemName" runat="server"
                                    ControlToValidate="txtItemName"
                                    ErrorMessage="Item name is required."
                                    CssClass="text-danger" Display="Dynamic"
                                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Category <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="">-- Select Category --</asp:ListItem>
                                    <asp:ListItem Value="Electronics">Electronics (Phone, Laptop, etc.)</asp:ListItem>
                                    <asp:ListItem Value="ID/Cards">ID Card / Access Card</asp:ListItem>
                                    <asp:ListItem Value="Keys">Keys</asp:ListItem>
                                    <asp:ListItem Value="Wallet">Wallet / Purse</asp:ListItem>
                                    <asp:ListItem Value="Clothing">Clothing / Accessories</asp:ListItem>
                                    <asp:ListItem Value="Books">Books / Stationery</asp:ListItem>
                                    <asp:ListItem Value="Bag">Bag / Backpack</asp:ListItem>
                                    <asp:ListItem Value="Jewelry">Jewelry / Watch</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvCategory" runat="server"
                                    ControlToValidate="ddlCategory" InitialValue=""
                                    ErrorMessage="Please select a category."
                                    CssClass="text-danger" Display="Dynamic"
                                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Description <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                                    TextMode="MultiLine" Rows="4" MaxLength="500"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDescription" runat="server"
                                    ControlToValidate="txtDescription"
                                    ErrorMessage="Description is required."
                                    CssClass="text-danger" Display="Dynamic"
                                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Location <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvLocation" runat="server"
                                    ControlToValidate="txtLocation"
                                    ErrorMessage="Location is required."
                                    CssClass="text-danger" Display="Dynamic"
                                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Date <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtItemDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                                    ControlToValidate="txtItemDate"
                                    ErrorMessage="Date is required."
                                    CssClass="text-danger" Display="Dynamic"
                                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- security question(lost items only) -->
                <asp:Panel ID="pnlSecuritySection" runat="server">
                    <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;margin-bottom:20px;">
                        <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
                            <span style="font-family:'Sora',sans-serif;font-weight:600;">Security Question</span>
                        </div>
                        <div class="p-4">
                            <p class="text-muted mb-3" style="font-size:0.85rem;">
                                This question verifies the identity of anyone who claims this item. Choose something only the real owner would know.
                            </p>
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label">Security Question <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtSecurityQuestion" runat="server" CssClass="form-control"
                                        placeholder="e.g. What sticker is on the back of this laptop?" MaxLength="255"></asp:TextBox>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Answer <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtSecurityAnswer" runat="server" CssClass="form-control"
                                        placeholder="Your answer (stored securely)" MaxLength="255"></asp:TextBox>
                                    <div class="text-muted mt-1" style="font-size:0.8rem;">Leave blank to keep the existing answer unchanged.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- item photo -->
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;margin-bottom:20px;">
                    <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
                        <span style="font-family:'Sora',sans-serif;font-weight:600;">Item Photo</span>
                    </div>
                    <div class="p-4">
                        <asp:Panel ID="pnlCurrentImage" runat="server" CssClass="mb-3">
                            <p class="form-label mb-2">Current Photo</p>
                            <img id="imgCurrent" runat="server" src="" alt="Current item photo"
                                 style="max-width:200px;border-radius:10px;border:1px solid var(--border);" />
                        </asp:Panel>
                        <label class="form-label">Replace Photo</label>
                        <asp:FileUpload ID="fuItemImage" runat="server" CssClass="form-control" accept="image/*" />
                        <div class="text-muted mt-1" style="font-size:0.8rem;">
                            Accepted: JPG, PNG, GIF. Max size: 5 MB. Leave blank to keep the current photo.
                        </div>
                    </div>
                </div>

            </div>

            <!-- right column: status & danger zone -->
            <div class="col-lg-4">

                <!-- status -->
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;margin-bottom:16px;">
                    <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
                        <span style="font-family:'Sora',sans-serif;font-weight:600;">Report Status</span>
                    </div>
                    <div class="p-3">
                        <p class="text-muted mb-1" style="font-size:0.8rem;">Current Status</p>
                        <asp:Literal ID="litCurrentStatus" runat="server"></asp:Literal>
                        <hr class="divider" />
                        <p class="text-muted mb-1" style="font-size:0.8rem;">Reported on</p>
                        <p class="mb-0" style="font-weight:500;font-size:0.92rem;">
                            <asp:Literal ID="litReportedOn" runat="server"></asp:Literal>
                        </p>
                    </div>
                </div>

                <!-- delete -->
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1.5px solid #f5c6c6;overflow:hidden;">
                    <div class="p-3">
                        <p style="font-family:'Sora',sans-serif;font-weight:600;font-size:0.9rem;color:var(--danger);margin-bottom:8px;">
                            Delete Report
                        </p>
                        <p class="text-muted mb-3" style="font-size:0.84rem;">
                            Permanently remove this report. This cannot be undone.
                        </p>
                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete This Report"
                            CssClass="btn btn-outline-danger w-100"
                            OnClick="btnDelete_Click"
                            CausesValidation="false"
                            OnClientClick="return confirm('Are you sure you want to permanently delete this report?');" />
                    </div>
                </div>

            </div>
        </div>

        <!-- save/cancel -->
        <div class="d-flex gap-2 mt-3">
            <asp:Button ID="btnSave" runat="server"
                Text="Save Changes"
                CssClass="btn btn-primary px-4"
                OnClick="btnSave_Click"
                style="font-weight:600;" />
            <asp:Button ID="btnCancel" runat="server"
                Text="Cancel"
                CssClass="btn btn-outline-secondary"
                PostBackUrl="MyReports.aspx"
                CausesValidation="false" />
        </div>

</asp:Content>
