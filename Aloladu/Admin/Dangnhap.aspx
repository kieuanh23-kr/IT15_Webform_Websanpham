<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dangnhap.aspx.cs" Inherits="Aloladu.Admin.Dangnhap" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin - Đăng nhập</title>
    <link href="AdminStyle.css" rel="stylesheet" />
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid min-vh-100">
            <div class="row min-vh-100">

                <!-- LEFT -->
                <div class="col-12 col-lg-7 left-panel d-flex align-items-center">
                    <div class="brand ms-lg-5 ps-lg-5">Aloladu</div>
                </div>

                <!-- RIGHT -->
                <div class="col-12 col-lg-5 d-flex align-items-center justify-content-center right-panel">
                    <div class="card login-card border-0 shadow-sm">
                        <div class="card-body p-4 p-md-5">

                           <div class="login-title">Đăng nhập</div>

                            <asp:Label ID="Label1" runat="server" CssClass="msg text-danger"></asp:Label>

                            <div class="mb-4">
                                <div class="form-label">Tên đăng nhập</div>
                                <asp:TextBox ID="txtUser" runat="server" CssClass="tb" placeholder="Nhập tên đăng nhập"></asp:TextBox>
                            </div>

                            <div class="mb-4">
                                <div class="form-label">Mật khẩu</div>
                                <asp:TextBox ID="txtPass" runat="server" CssClass="tb" placeholder="Nhập mật khẩu"></asp:TextBox>
                            </div>
                            </div>

                            <asp:Label ID="lblMsg" runat="server" CssClass="text-danger small d-block text-center mb-2" Visible="false"></asp:Label>

                            <div class="d-grid mt-3">
                                <asp:Button ID="btnLogin" runat="server"
                                    Text="Đăng nhập"
                                    CssClass="btn btn-primary fw-semibold py-2"
                                    OnClick="btnLogin_Click" />
                            </div>

                        </div>
                    </div>
                </div>

            </div>
        </div>
    </form>
</body>
</html>
