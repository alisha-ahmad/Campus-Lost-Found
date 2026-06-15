<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="CampusLostFound.Pages.Auth.Register" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#1a3a5c" />
    <title>Create Account | Campus Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="../../shared_style.css" />
</head>
<body>
<form id="form1" runat="server">

<div class="auth-wrapper">
    <div class="auth-card" style="max-width:500px;">

        <!-- logo -->
        <div class="auth-logo">
            <i class="fa-solid fa-magnifying-glass-location"
               style="color:var(--accent);font-size:2rem;display:block;margin-bottom:8px;"></i>
            Campus <span>Lost &amp; Found</span>
        </div>
        <p class="auth-subtitle">Create your account to get started</p>

        <!-- status message -->
        <asp:Label ID="lblMessage" runat="server" Visible="false"
            CssClass="d-block mb-3"></asp:Label>

        <div class="row g-3">

            <!-- first name -->
            <div class="col-md-6">
                <label class="form-label">First Name</label>
                <asp:TextBox ID="txtFirstName" runat="server"
                    CssClass="form-control" placeholder="Ahmad"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
                    ControlToValidate="txtFirstName"
                    ErrorMessage="First name is required."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
            </div>

            <!-- last name -->
            <div class="col-md-6">
                <label class="form-label">Last Name</label>
                <asp:TextBox ID="txtLastName" runat="server"
                    CssClass="form-control" placeholder="Khan"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
                    ControlToValidate="txtLastName"
                    ErrorMessage="Last name is required."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
            </div>

            <!-- email -->
            <div class="col-12">
                <label class="form-label">University Email</label>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control"
                    placeholder="fa22-bcs-001@lhr.nu.edu.pk"
                    TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="Email is required."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    ErrorMessage="Enter a valid email address."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:RegularExpressionValidator>
                <asp:RegularExpressionValidator ID="revUniversityEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationExpression="^[A-Za-z0-9._%+-]+@lhr\.nu\.edu\.pk$"
                    ErrorMessage="Only FAST university emails are allowed."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:RegularExpressionValidator>
            </div>

            <!-- role -->
            <div class="col-12">
                <label class="form-label">Role</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                    <asp:ListItem Value="">-- Select your role --</asp:ListItem>
                    <asp:ListItem Value="user">Student / Staff</asp:ListItem>
                    <asp:ListItem Value="admin">Admin</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvRole" runat="server"
                    ControlToValidate="ddlRole" InitialValue=""
                    ErrorMessage="Please select a role."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
            </div>

            <!-- password -->
            <div class="col-md-6">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server"
                    CssClass="form-control" placeholder="Min 8 characters"
                    TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ErrorMessage="Password is required."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                    ControlToValidate="txtPassword"
                    ValidationExpression=".{8,}"
                    ErrorMessage="Minimum 8 characters."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:RegularExpressionValidator>
            </div>

            <!-- confirm password -->
            <div class="col-md-6">
                <label class="form-label">Confirm Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server"
                    CssClass="form-control" placeholder="Repeat password"
                    TextMode="Password"></asp:TextBox>
                <asp:CompareValidator ID="cvPassword" runat="server"
                    ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtPassword"
                    ErrorMessage="Passwords do not match."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.8rem;"></asp:CompareValidator>
            </div>

            <!-- submit -->
            <div class="col-12 mt-2">
                <asp:Button ID="btnRegister" runat="server"
                    Text="Create Account"
                    CssClass="btn btn-primary w-100 py-2"
                    OnClick="btnRegister_Click"
                    style="font-size:1rem;font-weight:600;" />
            </div>

        </div>

        <hr class="divider" />

        <p class="text-center mb-0" style="font-size:0.9rem;color:var(--muted);">
            Already have an account?
            <a href="Login.aspx"
               style="color:var(--primary-light);font-weight:600;text-decoration:none;">Sign in</a>
        </p>

    </div>
</div>

</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>