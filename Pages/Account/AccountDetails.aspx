<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountDetails.aspx.cs" Inherits="CampusLostFound.Pages.Account.AccountDetails" MasterPageFile="~/Main.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<asp:Literal ID="litUserName" runat="server" Visible="false"></asp:Literal>

    <!-- page heading -->
    <div class="mb-4">
        <h4 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:2px;">Account Details</h4>
        <p class="text-muted mb-0" style="font-size:0.9rem;">Manage your profile and password</p>
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

    <div class="row g-4" style="max-width:820px;">

        <!-- profile information -->
        <div class="col-12">
            <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
                <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
                    <span style="font-family:'Sora',sans-serif;font-weight:600;">Profile Information</span>
                </div>
                <div class="p-4">
                    <div class="row g-3">

                        <div class="col-md-6">
                            <label class="form-label">First Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
                                ControlToValidate="txtFirstName"
                                ErrorMessage="First name is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"
                                ValidationGroup="ProfileGroup"></asp:RequiredFieldValidator>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Last Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
                                ControlToValidate="txtLastName"
                                ErrorMessage="Last name is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"
                                ValidationGroup="ProfileGroup"></asp:RequiredFieldValidator>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                                ReadOnly="true"
                                style="background:#f8f9fc;color:var(--muted);cursor:not-allowed;"></asp:TextBox>
                            <div class="text-muted mt-1" style="font-size:0.8rem;">Email cannot be changed.</div>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Role</label>
                            <asp:TextBox ID="txtRole" runat="server" CssClass="form-control"
                                ReadOnly="true"
                                style="background:#f8f9fc;color:var(--muted);cursor:not-allowed;"></asp:TextBox>
                        </div>

                        <div class="col-12 pt-1">
                            <asp:Button ID="btnSaveProfile" runat="server"
                                Text="Save Changes"
                                CssClass="btn btn-primary px-4"
                                OnClick="btnSaveProfile_Click"
                                ValidationGroup="ProfileGroup"
                                style="font-weight:600;" />
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <!-- change password -->
        <div class="col-12">
            <div style="background:var(--card-bg);border-radius:var(--radius);border:1px solid var(--border);box-shadow:0 4px 6px -1px rgba(0,0,0,0.05);overflow:hidden;">
                <div style="padding:14px 20px;border-bottom:1px solid var(--border);">
                    <span style="font-family:'Sora',sans-serif;font-weight:600;">Change Password</span>
                </div>
                <div class="p-4">
                    <div class="row g-3" style="max-width:480px;">

                        <div class="col-12">
                            <label class="form-label">Current Password <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server"
                                CssClass="form-control" TextMode="Password"
                                placeholder="Enter your current password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvCurrentPw" runat="server"
                                ControlToValidate="txtCurrentPassword"
                                ErrorMessage="Current password is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"
                                ValidationGroup="PasswordGroup"></asp:RequiredFieldValidator>
                        </div>

                        <div class="col-12">
                            <label class="form-label">New Password <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtNewPassword" runat="server"
                                CssClass="form-control" TextMode="Password"
                                placeholder="Minimum 8 characters"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvNewPw" runat="server"
                                ControlToValidate="txtNewPassword"
                                ErrorMessage="New password is required."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"
                                ValidationGroup="PasswordGroup"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revNewPw" runat="server"
                                ControlToValidate="txtNewPassword"
                                ValidationExpression=".{8,}"
                                ErrorMessage="Password must be at least 8 characters."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"
                                ValidationGroup="PasswordGroup"></asp:RegularExpressionValidator>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Confirm New Password <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server"
                                CssClass="form-control" TextMode="Password"
                                placeholder="Repeat new password"></asp:TextBox>
                            <asp:CompareValidator ID="cvPassword" runat="server"
                                ControlToValidate="txtConfirmPassword"
                                ControlToCompare="txtNewPassword"
                                ErrorMessage="Passwords do not match."
                                CssClass="text-danger" Display="Dynamic"
                                style="font-size:0.8rem;"
                                ValidationGroup="PasswordGroup"></asp:CompareValidator>
                        </div>

                        <div class="col-12 pt-1">
                            <asp:Button ID="btnChangePassword" runat="server"
                                Text="Update Password"
                                CssClass="btn btn-outline-primary px-4"
                                OnClick="btnChangePassword_Click"
                                ValidationGroup="PasswordGroup"
                                style="font-weight:600;" />
                        </div>

                    </div>
                </div>
            </div>
        </div>

    </div>

</asp:Content>
