<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CampusLostFound.Pages.Auth.Login" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#1a3a5c" />
    <title>Signin | Campus Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="../../shared_style.css" />
</head>
<body>
<form id="form1" runat="server">

<div class="auth-wrapper">
    <div class="auth-card">

        <!-- logo -->
        <div class="auth-logo">
            <i class="fa-solid fa-magnifying-glass-location"
               style="color:var(--accent);font-size:2rem;display:block;margin-bottom:8px;"></i>
            Campus <span>Lost &amp; Found</span>
        </div>
        <p class="auth-subtitle">Sign in to your account to continue</p>

        <!-- error message -->
        <asp:Label ID="lblMessage" runat="server" Visible="false"
            CssClass="alert-danger-custom d-block mb-3 text-center"></asp:Label>

        <!-- email -->
        <div class="mb-3">
            <label class="form-label">Email Address</label>
            <div class="input-group">
                <span class="input-group-text bg-white"
                    style="border:1.5px solid var(--border);border-right:none;border-radius:9px 0 0 9px;">
                    <i class="fa fa-envelope text-muted"></i>
                </span>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control"
                    placeholder="you@university.edu"
                    TextMode="Email"
                    style="border-radius:0 9px 9px 0;border-left:none;"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                ControlToValidate="txtEmail"
                ErrorMessage="Email is required."
                CssClass="text-danger"
                Display="Dynamic"
                style="font-size:0.8rem;"></asp:RequiredFieldValidator>
        </div>

        <!-- password -->
        <div class="mb-3">
            <div class="d-flex justify-content-between align-items-center mb-1">
                <label class="form-label mb-0">Password</label>
                <a href="ForgotPassword.aspx"
                   style="font-size:0.85rem;color:var(--primary-light);text-decoration:none;font-weight:500;">
                    Forgot password?
                </a>
            </div>
            <div class="input-group">
                <span class="input-group-text bg-white"
                    style="border:1.5px solid var(--border);border-right:none;border-radius:9px 0 0 9px;">
                    <i class="fa fa-lock text-muted"></i>
                </span>
                <asp:TextBox ID="txtPassword" runat="server"
                    CssClass="form-control"
                    placeholder="Enter your password"
                    TextMode="Password"
                    style="border-radius:0 9px 9px 0;border-left:none;"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                ControlToValidate="txtPassword"
                ErrorMessage="Password is required."
                CssClass="text-danger"
                Display="Dynamic"
                style="font-size:0.8rem;"></asp:RequiredFieldValidator>
        </div>

        <!-- remember me -->
        <div class="mb-4 d-flex align-items-center gap-2">
            <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input mt-0" />
            <label class="form-label mb-0" style="font-size:0.9rem;cursor:pointer;">
                Keep me signed in
            </label>
        </div>

        <!-- submit -->
        <asp:Button ID="btnLogin" runat="server" Text="Sign In"
            CssClass="btn btn-primary w-100 py-2"
            OnClick="btnLogin_Click"
            style="font-size:1rem;font-weight:600;" />

        <hr class="divider" />

        <p class="text-center mb-0" style="font-size:0.9rem;color:var(--muted);">
            Don't have an account?
            <a href="Register.aspx"
               style="color:var(--primary-light);font-weight:600;text-decoration:none;">
               Create one
            </a>
        </p>

    </div>
</div>

</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
