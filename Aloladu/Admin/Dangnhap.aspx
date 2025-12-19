<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dangnhap.aspx.cs" Inherits="Aloladu.Admin.Dangnhap" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin - Đăng nhập</title>
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        .left-panel {
            background: #1712c9;
            padding: 48px;
            justify-content: center;
        }

        .brand {
            color: #fff;
            font-size: 120px;
            font-weight: 800;
            letter-spacing: 1px;
        }

        /* Panel phải */
        .right-panel {
            background: #fff;
            padding: 24px;
        }

        /* Card login */
        .login-box {
            margin: auto;
            background: #fcf8f8;
            border-radius: 14px;
            padding: 26px 30px 28px;
            box-sizing: border-box;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            width: 400px;
            margin-top: 180px;
            margin-bottom: 180px;
        }

        .login-title{
            text-align:center;
            color:#1712c9;
            font-weight:700;
            font-size:28px;
            margin: 0 0 18px;
        }

        .form-label{
            font-weight: 700;
            margin-bottom: 8px;
        }

        .tb{
             width:100%;
             border:2px solid #1712c9;
             border-radius: 4px;
             padding: 10px 10px;
             background: transparent;
             outline:none;
             box-sizing: border-box;
        }

        .msg{
            display:block;
            text-align:center;
            font-weight:700;
            margin: 10px 0 10px;
        }

        .btn-primary{
            display: block;
            background:#1712c9;
            color:#fff;
            border-color:#1712c9;
            min-width:110px;
            height:38px;
            border-radius:4px;
            font-weight:700;
            padding:0 14px;
            cursor:pointer;
        }


    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid min-vh-100">
            <div class="row min-vh-100">

                <!-- LEFT -->
                <div class="col-12 col-lg-7 left-panel d-flex align-items-center">
                    <div class="brand">ALOLADU</div>
                </div>

                <!-- RIGHT -->
                <div class="col-12 col-lg-5 d-flex align-items-center justify-content-center right-panel">
                    <div class="login-box">

                           <div class="login-title">Đăng nhập</div>


                            <div class="mb-4">
                                <div class="form-label">Tên đăng nhập</div>
                                <asp:TextBox ID="txtUser" runat="server" CssClass="tb" placeholder="Nhập tên đăng nhập"></asp:TextBox>
                            </div>

                            <div class="mb-4">
                                <div class="form-label">Mật khẩu</div>
                                <asp:TextBox ID="txtPass" runat="server" CssClass="tb" placeholder="Nhập mật khẩu" TextMode="Password"></asp:TextBox>
                            </div>

                            <asp:Label ID="lblMsg" runat="server" CssClass="text-danger small d-block text-center mb-2" Visible="false"></asp:Label> 

                            <div class="d-flex justify-content-center">
                                <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" CssClass="btn-primary" OnClick="btnLogin_Click" />
                            </div>
                    </div>
                            
                    </div>
                </div>

            </div>
    </form>
</body>
</html>
