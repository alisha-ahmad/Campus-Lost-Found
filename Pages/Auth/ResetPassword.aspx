<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="CampusLostFound.Pages.Auth.ResetPassword" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reset Password | Campus Lost &amp; Found</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="../../shared_style.css" />
</head>
<body>
<form id="resetForm" runat="server">

<div class="auth-wrapper">
    <div class="auth-card" style="max-width:440px;">

        <!-- logo -->
        <div class="auth-logo">
            <i class="fa-solid fa-key"
               style="color:var(--accent);font-size:2rem;display:block;margin-bottom:8px;"></i>
            Account <span>Recovery</span>
        </div>
        <p class="auth-subtitle">Update your secure login credentials below</p>

        <!-- invalid/expired token panel -->
        <asp:Panel ID="pnlInvalidToken" runat="server" Visible="false">
            <div class="text-center py-2">
                <div style="width:64px;height:64px;background:#fdf0f0;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;">
                    <i class="fa-solid fa-circle-exclamation" style="color:var(--danger);font-size:1.6rem;"></i>
                </div>
                <h5 style="font-family:'Sora',sans-serif;font-weight:700;color:var(--primary);margin-bottom:8px;">
                    Invalid or Expired Link
                </h5>
                <p style="color:var(--muted);font-size:0.9rem;margin-bottom:20px;">
                    This password reset link has expired, is malformed, or has already been used.
                </p>
                <a href="Login.aspx" class="btn btn-primary w-100 py-2" style="font-weight:600;">
                    <i class="fa-solid fa-arrow-left me-2"></i>Return to Login
                </a>
            </div>
        </asp:Panel>

        <!-- reset form panel -->
        <asp:Panel ID="pnlResetInputs" runat="server" Visible="false">

            <!-- error alert -->
            <asp:Panel ID="pnlStatusAlert" runat="server" Visible="false"
                CssClass="alert-danger-custom d-flex align-items-center gap-2 mb-3 py-2 px-3">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <asp:Label ID="lblStatusError" runat="server"></asp:Label>
            </asp:Panel>

            <!-- success panel -->
            <asp:Panel ID="pnlStatusSuccess" runat="server" Visible="false"
                CssClass="alert-success-custom text-center mb-3 py-3 px-3">
                <i class="fa-solid fa-circle-check"
                   style="color:var(--success);font-size:2rem;display:block;margin-bottom:8px;"></i>
                <span style="font-family:'Sora',sans-serif;font-weight:700;color:var(--primary);display:block;margin-bottom:4px;">
                    Password Changed Successfully!
                </span>
                <span style="color:var(--muted);font-size:0.88rem;display:block;margin-bottom:16px;">
                    Your credentials have been updated securely.
                </span>
                <a href="Login.aspx" class="btn btn-primary btn-sm w-100 py-2" style="font-weight:600;">
                    Proceed to Login
                </a>
            </asp:Panel>

            <!-- input fields -->
            <div id="inputFieldsContainer" runat="server">

                <div class="mb-3">
                    <label class="form-label">New Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"
                            style="border:1.5px solid var(--border);border-right:none;border-radius:9px 0 0 9px;">
                            <i class="fa-solid fa-lock text-muted"></i>
                        </span>
                        <asp:TextBox ID="txtNewPassword" runat="server"
                            TextMode="Password"
                            CssClass="form-control"
                            placeholder="Enter new password (min 8 characters)"
                            style="border-radius:0 9px 9px 0;border-left:none;"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Confirm New Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"
                            style="border:1.5px solid var(--border);border-right:none;border-radius:9px 0 0 9px;">
                            <i class="fa-solid fa-shield-halved text-muted"></i>
                        </span>
                        <asp:TextBox ID="txtConfirmPassword" runat="server"
                            TextMode="Password"
                            CssClass="form-control"
                            placeholder="Confirm new password"
                            style="border-radius:0 9px 9px 0;border-left:none;"></asp:TextBox>
                    </div>
                </div>
                            style="border-radius:0 9px 9px 0;border-left:none;"></asp:TextBox>
                    </div>
                </div>

                <asp:Button ID="btnExecuteReset" runat="server"
                    Text="Save New Password"
                    CssClass="btn btn-primary w-100 py-2 mb-3"
                    OnClick="btnExecuteReset_Click"
                    style="font-size:1rem;font-weight:600;" />

                <p class="text-center mb-0">
                    <a href="Login.aspx"
                       style="font-size:0.88rem;color:var(--muted);text-decoration:none;">
                        <i class="fa-solid fa-arrow-left me-1"></i>Back to Sign In
                    </a>
                </p>

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
