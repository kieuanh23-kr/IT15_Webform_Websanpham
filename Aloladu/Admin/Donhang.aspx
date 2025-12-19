<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.Master" AutoEventWireup="true" CodeBehind="Donhang.aspx.cs" Inherits="Aloladu.Admin.Donhang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .orders-title{
            font-size: 34px;
            font-weight: 900;
            color: #0b0bbf;
            letter-spacing: .5px;
            margin-bottom: 18px;
        }

        .orders-toolbar{
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
        }

        .orders-select{
            min-width: 180px;
            padding: 10px 12px;
            border: 2px solid #1712c9;
            border-radius: 4px;
            font-weight: 700;
            background: #fff;
        }

        .orders-input{
            min-width: 320px;
            padding: 10px 12px;
            border: 2px solid #1712c9;
            border-radius: 4px;
            font-weight: 600;
        }

        /* vùng bảng có scroll, hiển thị 10 dòng */

        /* bảng */
        .orders-table{
            margin: 0;
            font-size: 15px;
        }
        .orders-table-wrap {
            max-height: 600px; /* Tương đương ~10 dòng (mỗi dòng ~60px) */
            overflow-y: auto;
            overflow-x: auto;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            position: relative;
        }

        /* header */
            .orders-table thead th {
                position: sticky !important;
                top: 0;
                z-index: 2;
                font-weight: 700;
                border-bottom: 1px solid #e6e6e6 !important;
                white-space: nowrap;
                padding: 12px 8px !important;
            }

        /* cell */
            .orders-table td {
                border-bottom: 1px solid #f1f1f1;
                vertical-align: middle;
                padding: 12px 8px !important;
            }

        /* hover */
        .orders-table tbody tr:hover{
            background: #f9fbff;
        }

        /* cột checkbox */
        .col-check{
            width: 48px;
            text-align: center;
            padding: 8px !important;
        }
   

        /* giới hạn chiều rộng chữ dài */
        .orders-table td:nth-child(5), /* Sản phẩm */
        .orders-table td:nth-child(6), /* Khách hàng */
        .orders-table td:nth-child(7)  /* Địa chỉ */
        {
            max-width: 280px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .btn-del{
                display:block;
                background: #000000;
                color: #fff;
                min-width: 110px;
                height: 45px;
                border-radius: 4px;
                font-weight: 700;
                padding: 0 14px;
                cursor: pointer;
                align-content: center;
                border: 2px solid #000000;
            }
            .btn-del:hover {
                background: #ff5757;
                color: #fff;
                border-color: #ff5757;
            }
        .btn-search{
                display: flex;
                align-items: center;
                justify-content: center;
                background: #1712c9;
                color: #fff;
                border-color: #1712c9;
                min-width:45px;
                height:45px;
                border-radius:4px;
                font-weight:700;
                padding:0 14px;
                cursor:pointer;
            }
            .btn-search:hover {
                background: #0b0bbf;
                color: #fff;
                border-color: #0b0bbf;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <div class="orders-page">
        <div class="orders-title">ĐƠN HÀNG</div>

        <div class="orders-toolbar">
            <asp:DropDownList ID="ddlField" runat="server" CssClass="orders-select">
                <asp:ListItem Text="Tên khách hàng" Value="Order_Cus" />
                <asp:ListItem Text="Tên sản phẩm" Value="Order_Prod" />
                <asp:ListItem Text="Địa chỉ" Value="Order_Address" />
                <asp:ListItem Text="Trạng thái đơn" Value="Status" />
            </asp:DropDownList>


            <asp:TextBox ID="txtKeyword" runat="server" CssClass="orders-input" placeholder="Nhập từ khoá tìm kiếm"></asp:TextBox>

            <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-search"
                OnClick="btnSearch_Click">
                <i class="bi bi-search"></i>
            </asp:LinkButton>

            <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-del ms-auto"
                OnClientClick="return confirm('Bạn chắc chắn muốn xóa các đơn hàng đã chọn?');"
                OnClick="btnDelete_Click">
                Xóa
            </asp:LinkButton>
        </div>

        <div class="orders-table-wrap">
            <asp:GridView ID="gvOrders" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="Order_ID"
                CssClass="table table-hover align-middle orders-table"
                GridLines="None" 
                UseAccessibleHeader="true"
                ShowHeaderWhenEmpty="true">

                <Columns>
                    <asp:TemplateField HeaderStyle-CssClass="col-check" ItemStyle-CssClass="col-check" HeaderStyle-BackColor="#d9d9d9">
                        <HeaderTemplate>
                            <input type="checkbox" onclick="toggleAll(this)" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="ckRow" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Order_Time"
                        HeaderText="Thời gian đặt"
                        DataFormatString="{0:dd/MM/yyyy HH:mm}" HeaderStyle-BackColor="#d9d9d9"/>

                    <asp:TemplateField HeaderText="Mã đơn" HeaderStyle-BackColor="#d9d9d9">
                        <ItemTemplate>
                            <a class="order-id-link"
                               href='<%# "DonhangChitiet.aspx?id=" + Eval("Order_ID") %>'>
                                <%# Eval("Order_ID") %>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>


                    <asp:TemplateField HeaderText="Trạng thái" HeaderStyle-BackColor="#d9d9d9">
                        <ItemTemplate>
                            <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Order_Prod" HeaderText="Sản phẩm" HeaderStyle-BackColor="#d9d9d9"/>
                    <asp:BoundField DataField="Order_Cus" HeaderText="Khách hàng" HeaderStyle-BackColor="#d9d9d9"/>
                    <asp:BoundField DataField="Order_Address" HeaderText="Địa chỉ" HeaderStyle-BackColor="#d9d9d9"/>
                </Columns>

            </asp:GridView>
        </div>

        <asp:Label ID="lblMsg" runat="server" CssClass="text-danger fw-semibold" Visible="false"></asp:Label>
    </div>

    <script>
        function toggleAll(source) {
            var gv = document.getElementById('<%= gvOrders.ClientID %>');
            if (!gv) return;
            var inputs = gv.getElementsByTagName('input');
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].type === 'checkbox' && inputs[i].id.indexOf('ckRow') !== -1) {
                    inputs[i].checked = source.checked;
                }
            }
        }
    </script>
</asp:Content>
