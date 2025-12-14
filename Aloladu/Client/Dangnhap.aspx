<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Dangnhap.aspx.cs" Inherits="Aloladu.Client.Dangnhap" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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

        .actions{
            display:flex;
            justify-content:center;
            gap: 18px;
            margin-top: 20px;
        }

        .btnx{
             display: block;
             background:#fff;
             color:#1712c9;
             border-color:#1712c9;
             min-width:110px;
             height:38px;
             border-radius:4px;
             font-weight:700;
             padding:0 14px;
             cursor:pointer;
        }

        .btn-primaryx{
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <div class="login-box">
            <div class="login-title">Đăng nhập</div>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg text-danger"></asp:Label>

            <div class="mb-4">
                <div class="form-label">Tên đăng nhập</div>
                <asp:TextBox ID="txtCCCD" runat="server" CssClass="tb" placeholder="Nhập CCCD"></asp:TextBox>
            </div>

            <div class="mb-4">
                <div class="form-label">Mật khẩu</div>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="tb" placeholder="SĐT"></asp:TextBox>
            </div>

            <div class="actions">
                <asp:Button ID="btnGoRegister" runat="server" Text="Đăng ký" CssClass="btnx" OnClick="btnGoRegister_Click" CausesValidation="false" />
                <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" CssClass="btnx btn-primaryx" OnClick="btnLogin_Click" />
            </div>
        </div>
</asp:Content>
