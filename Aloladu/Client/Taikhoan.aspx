<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Taikhoan.aspx.cs" Inherits="Aloladu.Client.Taikhoan" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .about-wrap{
            max-width: 980px;
            margin: 0 auto;
            padding: 6px 0 24px;
        }
        .news-header{
            background:#f3f0d6;
            padding:10px 16px;
            border-radius:6px;
            font-weight:900;
            color:#1d1bd9;
            font-size:18px;
            margin-bottom:12px;
        }

        .grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 60px;
        }
        .field label{
            display:block;
            font-weight:700;
            margin-bottom:6px;
        }
        .tb, .ddl{
            width:100%;
            border:2px solid #1712c9;
            border-radius: 4px;
            padding: 10px 10px;
            background: transparent;
            outline:none;
            box-sizing: border-box;
        }
        .field.full{ grid-column: 1 / -1; }
        .actions{
            display:flex;
            justify-content:center;
            gap: 18px;
            margin-top: 18px;
        }
        .btn-row{
              display:flex;
              justify-content:flex-end;
              gap:14px;
              margin-top:18px;
          }
          .btn-ui{
              min-width:110px;
              height:38px;
              border-radius:4px;
              font-weight:700;
              border:1.5px solid #2e2dfb;
              padding:0 14px;
              cursor:pointer;
          }
          .btn-outline{
              background:#fff;
              color:#1712c9;
          }
          .btn-black{
              background:#1712c9;
                color:#fff;
                border-color:#1712c9;
                margin-bottom: 100px;
          }
          .btn-primary2{
              background:#ff3131;
              color:#fff;
              border-color:#ff3131;
              margin-bottom: 100px;
          }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="news-header">Thông tin Tài khoản</div>
    <div class="about-wrap">
      <asp:Label ID="lblMsg" runat="server" CssClass="msg err" />

      <div class="grid">

        <div class="field">
          <label>Họ và tên</label>
          <asp:TextBox ID="txtName" runat="server" CssClass="tb" placeholder="Nhập họ và tên" />
        </div>

        <div class="field">
          <label>SĐT</label>
          <asp:TextBox ID="txtPhone" runat="server" CssClass="tb" placeholder="Nhập SĐT" />
        </div>

        <div class="field">
          <label>Số CCCD</label>
          <asp:TextBox ID="txtCCCD" runat="server" CssClass="tb" placeholder="Nhập số CCCD" />
        </div>

        <div class="field">
          <label>Gmail</label>
          <asp:TextBox ID="txtEmail" runat="server" CssClass="tb" placeholder="Nhập địa chỉ gmail" />
        </div>

        <div class="field">
          <label>Ngày sinh</label>
          <!-- type=date để nhập dễ, bạn vẫn có thể hiển thị dd/MM/yyyy nếu thích -->
          <asp:TextBox ID="txtBirth" runat="server" CssClass="tb" TextMode="Date" />
        </div>

        <div class="field">
          <label>Giới tính</label>
          <asp:DropDownList ID="ddlGender" runat="server" CssClass="ddl">
            <asp:ListItem Text="Nữ" Value="Nữ"></asp:ListItem>
            <asp:ListItem Text="Nam" Value="Nam"></asp:ListItem>
            <asp:ListItem Text="Khác" Value="Khác"></asp:ListItem>
          </asp:DropDownList>
        </div>

        <div class="field full">
          <label>Địa chỉ</label>
          <asp:TextBox ID="txtAddress" runat="server" CssClass="tb" placeholder="Nhập địa chỉ" />
        </div>

      </div>

      <div class="btn-row">
        <!-- Thoát: quay lại trang trước -->
        <asp:Button ID="btnExit" runat="server" Text="Thoát"
            CssClass="btn-ui btn-outline"
            OnClick="btnBack_Click" CausesValidation="false"/>

        <!-- Cập nhật -->
        <asp:Button ID="btnClear" runat="server" Text="Cập nhật"
            CssClass="btn-ui btn-black"
            OnClick="btnUpdate_Click"/>

        <!-- Đặt hàng -->
        <asp:Button ID="btnPlaceOrder" runat="server" Text="Đăng xuất"
            CssClass="btn-ui btn-primary2"
            OnClick="btnLogout_Click" CausesValidation="false"/>
    </div>
    </div>


</asp:Content>
