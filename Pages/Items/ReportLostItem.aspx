<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportLostItem.aspx.cs" Inherits="CampusLostFound.Pages.Items.ReportLostItem" MasterPageFile="~/Main.Master" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%-- litUserName kept for code-behind compatibility --%>
    <asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

<div style="max-width:720px;">

            <!-- page heading -->
            <div class="mb-4">
                <h4 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:2px;">
                    Report a Lost Item
                </h4>
                <p class="text-muted mb-0" style="font-size:0.9rem;">
                    Fill in the details below so others can help locate your item.
                </p>
            </div>

            <!-- alerts -->
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false"
                CssClass="alert-success-custom p-3 mb-4">
                <i class="fa fa-check-circle me-2"></i>
                Your lost item report has been submitted successfully. You will be notified when a match is found.
            </asp:Panel>
            <asp:Panel ID="pnlError" runat="server" Visible="false"
                CssClass="alert-danger-custom p-3 mb-4">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>

            <!-- form card -->
            <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);">
                <div class="p-4">
                    <div class="row g-3">

                        <!-- item Name -->
                        <div class="col-md-6">
                            <label class="form-label">Item Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtItemName" runat="server" CssClass="form-control"
                                placeholder="e.g. Blue Laptop Bag" MaxLength="100"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvItemName" runat="server"
                                ControlToValidate="txtItemName"
                                ErrorMessage="Item name is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                        </div>

                        <!-- category -->
                        <div class="col-md-6">
                            <label class="form-label">Category <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                <asp:ListItem Value="">-- Select category --</asp:ListItem>
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

                        <!-- description -->
                        <div class="col-12">
                            <label class="form-label">Description <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                                TextMode="MultiLine" Rows="4" MaxLength="1000"
                                placeholder="Describe the item in detail: color, brand, distinguishing marks, what was inside, etc."></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvDescription" runat="server"
                                ControlToValidate="txtDescription"
                                ErrorMessage="Description is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                            <div class="text-muted mt-1" style="font-size:0.8rem;">Be as specific as possible to improve chances of recovery.</div>
                        </div>

                        <!-- location -->
                        <div class="col-md-6">
                            <label class="form-label">Last Seen Location <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlLocation" runat="server" CssClass="form-select mb-2">
                                <asp:ListItem Value="">-- Select location --</asp:ListItem>
                                <asp:ListItem Value="Library">Library</asp:ListItem>
                                <asp:ListItem Value="Cafeteria">Cafeteria / Canteen</asp:ListItem>
                                <asp:ListItem Value="Sports Complex">Sports Complex</asp:ListItem>
                                <asp:ListItem Value="Lecture Halls">Lecture Halls Block</asp:ListItem>
                                <asp:ListItem Value="Lab Block">Computer / Science Lab Block</asp:ListItem>
                                <asp:ListItem Value="Admin Block">Admin Block</asp:ListItem>
                                <asp:ListItem Value="Parking Area">Parking Area</asp:ListItem>
                                <asp:ListItem Value="Hostel">Hostel</asp:ListItem>
                                <asp:ListItem Value="Other">Other (specify below)</asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control"
                                placeholder="Or type a specific location..."></asp:TextBox>
                            <asp:CustomValidator ID="cvLocation" runat="server"
                                ErrorMessage="Please select or enter a location."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"
                                OnServerValidate="cvLocation_ServerValidate"></asp:CustomValidator>
                        </div>

                        <!-- date lost -->
                        <div class="col-md-6">
                            <label class="form-label">Date Lost <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtDateLost" runat="server" CssClass="form-control"
                                TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvDateLost" runat="server"
                                ControlToValidate="txtDateLost"
                                ErrorMessage="Date is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                        </div>

                        <!-- security question -->
                        <div class="col-12">
                            <label class="form-label">Security Question <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtSecurityQuestion" runat="server" CssClass="form-control"
                                placeholder="e.g. What sticker is on the back of this laptop?"></asp:TextBox>
                            <div class="text-muted mt-1" style="font-size:0.8rem;">
                                This question will be asked to anyone who tries to claim your item, to verify ownership.
                            </div>
                            <asp:RequiredFieldValidator ID="rfvSecQ" runat="server"
                                ControlToValidate="txtSecurityQuestion"
                                ErrorMessage="Security question is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                        </div>

                        <!-- security answer -->
                        <div class="col-12">
                            <label class="form-label">Security Answer <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtSecurityAnswer" runat="server" CssClass="form-control"
                                placeholder="Your answer (kept private — used to verify ownership)"></asp:TextBox>
                            <div class="text-muted mt-1" style="font-size:0.8rem;">
                                Only you will see this answer. Anyone claiming the item must answer the security question correctly.
                            </div>
                            <asp:RequiredFieldValidator ID="rfvSecA" runat="server"
                                ControlToValidate="txtSecurityAnswer"
                                ErrorMessage="Security answer is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                        </div>

                        <!-- image upload -->
                        <div class="col-12">
                            <label class="form-label">Upload Image <span class="text-muted" style="font-weight:400;">(optional)</span></label>
                            <asp:FileUpload ID="fuItemImage" runat="server" CssClass="form-control" accept="image/*" />
                            <div class="text-muted mt-1" style="font-size:0.8rem;">Supported formats: JPG, PNG, WEBP. Max size: 5MB.</div>
                        </div>

                        <!-- actions -->
                        <div class="col-12 pt-2 d-flex gap-2">
                            <asp:Button ID="btnSubmit" runat="server"
                                Text="Submit Lost Report"
                                CssClass="btn btn-danger px-4"
                                OnClick="btnSubmit_Click"
                                style="font-weight:600;" />
                            <a href="../../UserDashboard.aspx"
                               class="btn btn-outline-secondary px-4">Cancel</a>
                        </div>

                    </div>
                </div>
            </div>

        </div>

</asp:Content>
