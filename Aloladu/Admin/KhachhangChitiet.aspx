<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.Master" AutoEventWireup="true" CodeBehind="KhachhangChitiet.aspx.cs" Inherits="Aloladu.Admin.KhachhangChitiet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style>
        .cus-title{
            font-size: 34px;
            font-weight: 900;
            color: #0b0bbf;
            margin-bottom: 18px;
            letter-spacing: .3px;
        }

        .cus-grid{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 48px;
            max-width: 1800px;
        }
        .cus-select{
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #0b0bbf;
            border-radius: 4px;
            font-weight: 600;
            background: #fff;
        }

        .cus-field{ width: 100%; }

        .cus-span2{ grid-column: span 2; }

        .cus-label{
            font-weight: 800;
            margin-bottom: 8px;
        }

        .cus-input{
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #0b0bbf;
            border-radius: 4px;
            font-weight: 600;
            background: #fff;
        }

        /* Disabled fields giống hình (xám) */
        .cus-input:disabled,
        .cus-input[disabled]{
            background: #e9e9e9;
            color: #222;
            opacity: 1;
        }

        /* dropdown có dấu > bên phải */
        .cus-select-wrap{ position: relative; }
        .cus-select{ appearance: none; padding-right: 36px; }
        .cus-arrow{
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: 900;
            color: #222;
            pointer-events: none;
        }

        .cus-note{ resize: none; }

        .cus-actions{
            margin-top: 22px;
            display: flex;
            gap: 16px;
            justify-content: right;
        }
        .btn {
            height: 45px;
            min-width: 110px;
            border-radius: 4px;
            font-weight: 700;
            padding: 0 14px;
            align-content: center;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="cus-title" runat="server" id="RecTitle">KHÁCH HÀNG &gt; CHI TIẾT KHÁCH HÀNG </div>


    <div class="cus-grid">
        <!-- Row 1 -->
        <div class="cus-field cus-span2">
            <div class="cus-label">Mã khách hàng</div>
            <asp:TextBox ID="txtCusID" runat="server" CssClass="cus-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="cus-field">
            <div class="cus-label">Tên khách hàng</div>
            <asp:TextBox ID="txtCusName" runat="server" CssClass="cus-input" Enabled="true"></asp:TextBox>
        </div>
        <div class="cus-field">
            <div class="cus-label">SĐT</div>
            <asp:TextBox ID="txtCusPhone" runat="server" CssClass="cus-input" Enabled="true"></asp:TextBox>
        </div>

        <!-- Row 2 -->
        <div class="cus-field">
            <div class="cus-label">Ngày tạo tài khoản</div>
            <asp:TextBox ID="txtCusCreate" runat="server" CssClass="cus-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="cus-field">
           <div class="cus-label">CCCD</div>
           <asp:TextBox ID="txtCusCCCD" runat="server" CssClass="cus-input" Enabled="true"></asp:TextBox>
       </div>

        <!-- Row 3 -->
        <div class="cus-field">
            <div class="cus-label">Gmail</div>
            <asp:TextBox ID="txtCusMail" runat="server" CssClass="cus-input" Enabled="true"></asp:TextBox>
        </div>

        <div class="cus-field">
            <div class="cus-label">Giới tính</div>
            <asp:DropDownList ID="ddlCusGender" runat="server" CssClass="cus-select">
                <asp:ListItem Text="Nữ" Value="Nữ" />
                <asp:ListItem Text="Nam" Value="Nam" />
                <asp:ListItem Text="Khác" Value="Khác" />
            </asp:DropDownList>
        </div>
        
        <!-- Row 4 (full) -->
        <div class="cus-field">
            <div class="cus-label">Địa chỉ</div>
            <asp:TextBox ID="txtCusAddress" runat="server" CssClass="cus-input" Enabled="true"></asp:TextBox>
        </div>
        <div class="cus-field">
            <div class="cus-label">Ngày sinh</div>
            <asp:TextBox ID="txtCusBirth" runat="server" CssClass="cus-input" Enabled="true" TextMode="Date"></asp:TextBox>
        </div>

        <!-- Row 5-->
        <div class="cus-field">
            <div class="cus-label">Số đơn đã đặt</div>
            <asp:TextBox ID="txtCusQuan" runat="server" CssClass="cus-input" Enabled="false"></asp:TextBox>
        </div>

        <div class="cus-field">
            <div class="cus-label">Doanh thu</div>
            <asp:TextBox ID="txtCusTotal" runat="server" CssClass="cus-input" Enabled="false"></asp:TextBox>
        </div>

    </div>

    <div class="cus-actions">
        <asp:Label ID="lblMsg" runat="server" CssClass="fw-semibold d-block mb-3" Visible="false"></asp:Label>
        <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-outline-primary" OnClick="btnBack_Click">
            Thoát
        </asp:LinkButton>

        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-dark"
            OnClientClick="return confirm('Bạn chắc chắn muốn xóa khách hàng này?');"
            OnClick="btnDelete_Click">
            Xóa
        </asp:LinkButton>

        <asp:LinkButton ID="btnUpdate" runat="server" CssClass="btn btn-primary"
            OnClick="btnUpdate_Click">
            Cập nhật
        </asp:LinkButton>
    </div>
</asp:Content>

