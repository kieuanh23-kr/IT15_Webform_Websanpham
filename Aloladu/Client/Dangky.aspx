<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Dangky.aspx.cs" Inherits="Aloladu.Client.Dangky" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
     
      .auth-card{
          margin: auto;
          max-width: 980px;
          background:#fcf8f8;
          border-radius: 10px;
          padding: 26px 36px 30px;
          box-shadow: 0 2px 15px rgba(0,0,0,0.15);
          margin-bottom:120px;
          margin-top:80px;
      }
      .auth-title{
          text-align:center;
          color:#1712c9;
          font-weight:700;
          font-size:28px;
          margin: 0 0 18px;
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
        .btn-clear {
            display: block;
            background: #111;
            color: #fff;
            min-width: 110px;
            height: 38px;
            border-radius: 4px;
            border-color: #111;
            font-weight: 700;
            padding: 0 14px;
            cursor: pointer;
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
      .btn-login{  
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
      .msg{
          text-align:center;
          margin: 8px 0 10px;
          font-weight:700;
      }
      .msg.err{ color:#c00; }
      .msg.ok{ color:#0a8a2a; }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-wrap">
      <div class="auth-card">

        <div class="auth-title">Đăng ký</div>

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

        <div class="actions">
          <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" Class="btn-login" OnClick="btnGoLogin_Click" CausesValidation="false"/>
          <asp:Button ID="btnClear" runat="server" Text="Xóa trắng" Class="btn-clear" OnClick="btnClear_Click" CausesValidation="false" />
          <asp:Button ID="btnRegister" runat="server" Text="Đăng ký" Class="btn-primary" OnClick="btnRegister_Click" />
        </div>

      </div>
    </div>
</asp:Content>
