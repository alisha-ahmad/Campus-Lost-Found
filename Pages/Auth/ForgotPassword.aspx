<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="CampusLostFound.Pages.Auth.ForgotPassword" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Forgot Password | Campus Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="../../shared_style.css" />
</head>
<body>
<form id="form1" runat="server">

<div class="auth-wrapper">
    <div class="auth-card" style="max-width:420px;">

        <!-- logo -->
        <div class="auth-logo">
            <i class="fa-solid fa-key"
               style="color:var(--accent);font-size:2rem;display:block;margin-bottom:8px;"></i>
            Reset <span>Password</span>
        </div>
        <p class="auth-subtitle">Enter your university email. We'll send a reset link.</p>

        <!-- user enter email -->
        <asp:Panel ID="pnlEmailStep" runat="server">

            <asp:Label ID="lblMessage" runat="server" Visible="false"
                CssClass="alert-danger-custom d-block mb-3"></asp:Label>

            <div class="mb-4">
                <label class="form-label">University Email</label>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control"
                    placeholder="you@university.edu"
                    TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="Email is required."
                    CssClass="text-danger" Display="Dynamic"
                    style="font-size:0.82rem;"></asp:RequiredFieldValidator>
            </div>

            <asp:Button ID="btnSendLink" runat="server"
                Text="Send Reset Link"
                CssClass="btn btn-primary w-100 py-2"
                OnClick="btnSendLink_Click"
                style="font-size:1rem;font-weight:600;" />

        </asp:Panel>

        <!-- shows success panel -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div class="text-center">
                <div style="width:64px;height:64px;background:#edf7f2;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;">
                    <i class="fa fa-check" style="color:var(--success);font-size:1.6rem;"></i>
                </div>
                <h5 style="font-family:'Sora',sans-serif;font-weight:700;margin-bottom:8px;color:var(--primary);">
                    Check Your Email
                </h5>
                <p style="color:var(--muted);font-size:0.9rem;">
                    A password reset link has been sent to your registered email address.
                    Please check your inbox and follow the instructions.
                </p>
                <a href="Login.aspx" class="btn btn-outline-primary mt-3 w-100">
                    <i class="fa-solid fa-arrow-left me-2"></i>Back to Login
                </a>
            </div>
        </asp:Panel>

        <hr class="divider" />
        <p class="text-center mb-0" style="font-size:0.88rem;color:var(--muted);">
            Remembered it?
            <a href="Login.aspx"
               style="color:var(--primary-light);font-weight:600;text-decoration:none;">Sign in</a>
        </p>

    </div>
</div>

</form>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
