<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.Master" AutoEventWireup="true" CodeBehind="DonhangChitiet.aspx.cs" Inherits="Aloladu.Admin.DonhangChitiet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .od-title{
            font-size: 34px;
            font-weight: 900;
            color: #0b0bbf;
            margin-bottom: 18px;
            letter-spacing: .3px;
        }

        .od-grid{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 48px;
            max-width: 1800px;
        }

        .od-field{ width: 100%; }

        .od-span2{ grid-column: span 2; }

        .od-label{
            font-weight: 800;
            margin-bottom: 8px;
        }

        .od-input{
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #0b0bbf;
            border-radius: 4px;
            font-weight: 600;
            background: #fff;
        }

        /* Disabled fields giống hình (xám) */
        .od-input:disabled,
        .od-input[disabled]{
            background: #e9e9e9;
            color: #222;
            opacity: 1;
        }

        /* dropdown có dấu > bên phải */
        .od-select-wrap{ position: relative; }
        .od-select{ appearance: none; padding-right: 36px; }
        .od-arrow{
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: 900;
            color: #222;
            pointer-events: none;
        }

        .od-note{ resize: none; }

        .od-actions{
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

    <div class="od-title">ĐƠN HÀNG &gt; CHI TIẾT ĐƠN HÀNG</div>


    <div class="od-grid">
        <!-- Row 1 -->
        <div class="od-field">
            <div class="od-label">Mã đơn</div>
            <asp:TextBox ID="txtOrderId" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="od-field">
            <div class="od-label">Khách hàng</div>
            <asp:TextBox ID="txtCustomer" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>

        <!-- Row 2 -->
        <div class="od-field">
            <div class="od-label">Thời gian đặt</div>
            <asp:TextBox ID="txtTime" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="od-field">
            <div class="od-label">Trạng thái</div>
            <div class="od-select-wrap">
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="od-input od-select">
                    <asp:ListItem Text="Chờ xử lý" Value="Chờ xử lý" />
                    <asp:ListItem Text="Chuẩn bị giao" Value="Chuẩn bị giao" />
                    <asp:ListItem Text="Đang giao" Value="Đang giao" />
                    <asp:ListItem Text="Hoàn thành" Value="Hoàn thành" />
                </asp:DropDownList>
                <span class="od-arrow">&gt;</span>
            </div>
        </div>

        <!-- Row 3 -->
        <div class="od-field">
            <div class="od-label">Người nhận</div>
            <asp:TextBox ID="txtReceiver" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="od-field">
            <div class="od-label">SĐT</div>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>

        <!-- Row 4 (full) -->
        <div class="od-field od-span2">
            <div class="od-label">Địa chỉ</div>
            <asp:TextBox ID="txtAddress" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>

        <!-- Row 5 -->
        <div class="od-field">
            <div class="od-label">Sản phẩm</div>
            <asp:TextBox ID="txtProduct" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="od-field">
            <div class="od-label">Số lượng</div>
            <asp:TextBox ID="txtQuantity" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>

        <!-- Row 6 -->
        <div class="od-field">
            <div class="od-label">Đơn giá</div>
            <asp:TextBox ID="txtUnit" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="od-field">
            <div class="od-label">Thành tiền</div>
            <asp:TextBox ID="txtTotal" runat="server" CssClass="od-input" Enabled="false"></asp:TextBox>
        </div>

        <!-- Row 7 (full) -->
        <div class="od-field od-span2">
            <div class="od-label">Ghi chú</div>
            <asp:TextBox ID="txtNote" runat="server" CssClass="od-input od-note"
                TextMode="MultiLine" Rows="2"></asp:TextBox>
        </div>
    </div>

    <div class="od-actions">
        <asp:Label ID="lblMsg" runat="server" CssClass="fw-semibold d-block mb-3" Visible="false"></asp:Label>
        <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-outline-primary" OnClick="btnBack_Click">
            Thoát
        </asp:LinkButton>

        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-dark"
            OnClientClick="return confirm('Bạn chắc chắn muốn xóa đơn hàng này?');"
            OnClick="btnDelete_Click">
            Xóa
        </asp:LinkButton>

        <asp:LinkButton ID="btnUpdate" runat="server" CssClass="btn btn-primary"
            OnClick="btnUpdate_Click">
            Cập nhật
        </asp:LinkButton>
    </div>
</asp:Content>
