<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Dathang.aspx.cs" Inherits="Aloladu.Client.Dathang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
    .page-title {
        background: #f3f0d6;
        padding: 10px 16px;
        border-radius: 6px;
        font-weight: 900;
        color: #1d1bd9;
        font-size: 18px;
        margin-bottom: 18px;
    }


    /* WRAP 2 CỘT */
    .dh-layout {
        display: grid;
        grid-template-columns: 280px 1fr;
        gap: 26px;
        align-items: start;
    }

    /* CARD SẢN PHẨM (cột trái) */
    .p-sidecard {
        border: 3px solid #2e2dfb;
        border-radius: 16px;
        background: #fff;
        overflow: hidden;
    }

    .p-side-img {
        height: 220px;
        background: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        border-bottom: 2px solid #2e2dfb; /* line ngăn ảnh/text */
    }

    .p-side-img img {
        width: 100%;
        height: 100%;
        object-fit: contain;
        padding: 14px;
    }

    .p-side-body {
        padding: 14px 16px 16px;
    }

    .p-side-name {
        font-weight: 900;
        color: #1712c9;
        font-size: 22px;
        line-height: 1.15;

        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        margin-bottom: 10px;
    }

    .p-side-line {
        font-size: 16px;
        margin: 4px 0;
    }
    .p-side-line b { font-weight: 900; }

    .p-side-old {
        margin-top: 10px;
        color: #666;
        text-decoration: line-through;
        font-size: 16px;
    }

    .p-side-price {
        color: #ff2b2b;
        font-weight: 900;
        font-size: 34px;
        margin-top: 4px;
    }

    /* FORM bên phải */
    .order-form {
        background: #fff7f7;
        border-radius: 18px;
        padding: 35px 26px;
    }

    .order-form h2 {
        margin: 0 0 18px;
        font-size: 22px;
        font-weight: 900;
        color: #1712c9;
    }

    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 18px 26px;
    }

    .form-group label {
        font-weight: 800;
        margin-bottom: 6px;
        display: block;
    }

    .form-control {
        width: 100%;
        height: 44px;
        border-radius: 6px;
        border: 2px solid #2e2dfb;
        padding: 6px 12px;
        font-size: 16px;
        box-sizing: border-box;
    }

    .form-control[readonly] { background: #e6e6e6; }

    .full { grid-column: 1 / -1; }
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
          background:#111;
          color:#fff;
          border-color:#111;
      }
      .btn-primary2{
          background:#1712c9;
          color:#fff;
          border-color:#1712c9;
          margin-bottom: 100px;
      }
</style>

<div class="page-title">Sản phẩm &gt; Đặt hàng</div>

<div class="dh-layout">

    <!-- CỘT TRÁI: CARD SẢN PHẨM -->
    <div class="p-sidecard">
        <div class="p-side-img">
            <asp:Image ID="imgProduct" runat="server" AlternateText="Sản phẩm" />
        </div>

        <div class="p-side-body">
            <div class="p-side-name">
                <asp:Literal ID="litName" runat="server" />
            </div>

            <div class="p-side-line"><b>Mô tả:</b> <asp:Literal ID="litDesc" runat="server" /></div>
            <div class="p-side-line"><b>Phân loại:</b> <asp:Literal ID="litCategory" runat="server" /></div>
            <div class="p-side-line"><b>Hãng:</b> <asp:Literal ID="litBrand" runat="server" /></div>

            <div class="p-side-old"><asp:Literal ID="litOldPrice" runat="server" /></div>
            <div class="p-side-price"><asp:Literal ID="litPrice" runat="server" /></div>
        </div>
    </div>

    <!-- CỘT PHẢI: THÔNG TIN ĐƠN HÀNG -->
    <div class="order-form">
        <h2>Thông tin Đơn hàng</h2>

        <div class="form-grid">
            <div class="form-group">
                <label>Người nhận</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
            </div>

            <div class="form-group">
                <label>SĐT</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
            </div>

            <div class="form-group full">
                <label>Địa chỉ</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" />
            </div>

            <div class="form-group">
                <label>Số lượng</label>
                <asp:TextBox ID="txtQuantity" runat="server"
                    CssClass="form-control"
                    Text="1"
                    TextMode="Number"
                    oninput="updateTotal()" />
            </div>

            <div class="form-group">
                <label>Thành tiền</label>
                <asp:TextBox ID="txtTotal" runat="server" CssClass="form-control" ReadOnly="true" />
            </div>

            <div class="form-group">
                <label>Hình thức thanh toán</label>
                <input type="text" class="form-control" value="Ship COD" readonly />
            </div>

            <div class="form-group">
                <label>Ghi chú</label>
                <asp:TextBox ID="txtNote" runat="server" CssClass="form-control" />
            </div>
        </div>

        <!-- Hidden price để tính thành tiền -->
        <asp:HiddenField ID="hdPrice" runat="server" />
    </div>

</div>

<!-- CÁC BUTTON-->
<div class="btn-row">
    <!-- Thoát: quay lại trang trước -->
    <asp:Button ID="btnExit" runat="server" Text="Thoát"
        CssClass="btn-ui btn-outline"
        UseSubmitBehavior="false"
        OnClientClick="history.back(); return false;" />

    <!-- Xóa trắng -->
    <asp:Button ID="btnClear" runat="server" Text="Xóa trắng"
        CssClass="btn-ui btn-black"
        CausesValidation="false"
        OnClick="btnClear_Click" />

    <!-- Đặt hàng -->
    <asp:Button ID="btnPlaceOrder" runat="server" Text="Đặt hàng"
        CssClass="btn-ui btn-primary2"
        OnClick="btnPlaceOrder_Click" />
</div>

<!-- Thông báo -->
<asp:Label ID="lblMsg" runat="server" CssClass="d-block mt-2" />



<script>
    function updateTotal() {
        const qtyInput = document.getElementById('<%= txtQuantity.ClientID %>');
        const totalInput = document.getElementById('<%= txtTotal.ClientID %>');
        const priceEl = document.getElementById('<%= hdPrice.ClientID %>');

        let price = parseInt(priceEl.value || "0");
        let qty = parseInt(qtyInput.value || "1");

        if (isNaN(qty) || qty < 1) { qty = 1; qtyInput.value = 1; }
        const total = qty * price;

        totalInput.value = total.toLocaleString('vi-VN');
    }

    window.onload = updateTotal;
</script>

   
</asp:Content>
