<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportFoundItem.aspx.cs" Inherits="CampusLostFound.Pages.Items.ReportFoundItem" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%-- litUserName kept for code-behind compatibility --%>
    <asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

<!-- page heading -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-4">
            <div>
                <h4 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:2px;">Report Found Item</h4>
                <p class="text-muted mb-0" style="font-size:0.9rem;">Submit details of an item you found on campus</p>
            </div>
            <a href="../../UserDashboard.aspx" class="btn btn-sm btn-outline-secondary">
                <i class="fa fa-arrow-left me-1"></i> Back to Dashboard
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

            <!-- item Details -->
            <div class="col-lg-8">
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
                    <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
                        <span style="font-family:'Sora',sans-serif;font-weight:600;">Item Details</span>
                    </div>
                    <div class="p-4">
                        <div class="row g-3">

                            <div class="col-md-6">
                                <label class="form-label">Item Name <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtItemName" runat="server" CssClass="form-control"
                                    placeholder="e.g. Black Wallet, Samsung Phone" MaxLength="100"></asp:TextBox>
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
                                    TextMode="MultiLine" Rows="4" MaxLength="500"
                                    placeholder="Describe the item in detail — colour, brand, distinguishing marks, contents, etc."></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDescription" runat="server"
                                    ControlToValidate="txtDescription"
                                    ErrorMessage="Description is required."
                                    CssClass="text-danger" Display="Dynamic"
                                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                                <div class="text-muted mt-1" style="font-size:0.8rem;">The more detail you provide, the easier it is for the owner to identify the item.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Where was it found? <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control"
                                    placeholder="e.g. Library, Block-C Corridor, Cafeteria" MaxLength="200"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvLocation" runat="server"
                                    ControlToValidate="txtLocation"
                                    ErrorMessage="Location is required."
                                    CssClass="text-danger" Display="Dynamic"
                                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Date Found <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtFoundDate" runat="server" CssClass="form-control"
                                    TextMode="Date"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFoundDate" runat="server"
                                    ControlToValidate="txtFoundDate"
                                    ErrorMessage="Date found is required."
                                    CssClass="text-danger" Display="Dynamic"
                                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Item Photo <span class="text-muted" style="font-weight:400;">(optional but recommended)</span></label>
                                <asp:FileUpload ID="fuItemImage" runat="server" CssClass="form-control" accept="image/*" />
                                <div class="text-muted mt-1" style="font-size:0.8rem;">Accepted: JPG, PNG, GIF. Max size: 5 MB.</div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <!-- right column -->
            <div class="col-lg-4">
                <!-- custody -->
                <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;margin-bottom:16px;">
                    <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
                        <span style="font-family:'Sora',sans-serif;font-weight:600;">Item Custody</span>
                    </div>
                    <div class="p-3">
                        <p class="text-muted mb-3" style="font-size:0.85rem;">Where is the item currently being kept?</p>
                        <div class="mb-3">
                            <label class="form-label">Handed to</label>
                            <asp:DropDownList ID="ddlCustody" runat="server" CssClass="form-select">
                                <asp:ListItem Value="self">Kept with me temporarily</asp:ListItem>
                                <asp:ListItem Value="security">Campus Security Office</asp:ListItem>
                                <asp:ListItem Value="admin">Department Admin</asp:ListItem>
                                <asp:ListItem Value="library">Library Front Desk</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div>
                            <label class="form-label">Additional note</label>
                            <asp:TextBox ID="txtCustodyNote" runat="server" CssClass="form-control"
                                TextMode="MultiLine" Rows="2" MaxLength="200"
                                placeholder="Room number, contact, etc."></asp:TextBox>
                        </div>
                    </div>
                </div>

                <!-- tips -->
                <div style="background:#f8f9fc;border-radius:var(--radius);border:1px solid var(--border);padding:16px 18px;">
                    <p style="font-family:'Sora',sans-serif;font-weight:600;font-size:0.9rem;margin-bottom:10px;color:var(--primary);">
                        Tips for a good report
                    </p>
                    <ul class="text-muted mb-0 ps-3" style="font-size:0.84rem;line-height:1.9;">
                        <li>Include brand, colour, and model if applicable.</li>
                        <li>Mention any unique marks or stickers.</li>
                        <li>Upload a clear photo to speed up identification.</li>
                        <li>Note the exact location and time you found it.</li>
                    </ul>
                </div>

            </div>
        </div>

        <!-- actions -->
        <div class="mt-4 d-flex gap-2">
            <asp:Button ID="btnSubmit" runat="server"
                Text="Submit Found Report"
                CssClass="btn btn-success px-4"
                OnClick="btnSubmit_Click"
                style="font-weight:600;" />
            <asp:Button ID="btnCancel" runat="server"
                Text="Cancel"
                CssClass="btn btn-outline-secondary"
                PostBackUrl="../../UserDashboard.aspx"
                CausesValidation="false" />
        </div>

</asp:Content>
