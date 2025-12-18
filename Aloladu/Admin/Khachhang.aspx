<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.Master" AutoEventWireup="true" CodeBehind="Khachhang.aspx.cs" Inherits="Aloladu.Admin.Khachhang" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
         .cus-title{
             font-size: 34px;
             font-weight: 900;
             color: #0b0bbf;
             letter-spacing: .5px;
             margin-bottom: 18px;
         }

  
         .cus-toolbar{
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
         }
         .cus-select{
             min-width: 180px;
             padding: 10px 12px;
             border: 2px solid #1712c9;
             border-radius: 4px;
             font-weight: 700;
             background: #fff;
         }

         .cus-input{
             min-width: 320px;
             padding: 10px 12px;
             border: 2px solid #1712c9;
             border-radius: 4px;
             font-weight: 600;
         }

         /* vùng bảng có scroll, hiển thị 10 dòng */

         /* bảng */
         .cus-table{
             margin: 0;
             font-size: 15px;
         }
         .cus-table-wrap {
             max-height: 600px; /* Tương đương ~10 dòng (mỗi dòng ~60px) */
             overflow-y: auto;
             overflow-x: auto;
             border: 1px solid #e5e7eb;
             border-radius: 8px;
             position: relative;
         }

         /* header */
             .cus-table thead th {
                 position: sticky !important;
                 top: 0;
                 z-index: 2;
                 font-weight: 700;
                 border-bottom: 1px solid #e6e6e6 !important;
                 white-space: nowrap;
                 padding: 12px 8px !important;
             }

         /* cell */
             .cus-table td {
                 border-bottom: 1px solid #f1f1f1;
                 vertical-align: middle;
                 padding: 12px 8px !important;
             }

         /* hover */
         .cus-table tbody tr:hover{
             background: #f9fbff;
         }

         /* cột checkbox */
         .col-check{
             width: 48px;
             text-align: center;
             padding: 8px !important;
         }


         /* giới hạn chiều rộng chữ dài */
         .cus-table td:nth-child(5), /* Sản phẩm */
         .cus-table td:nth-child(6), /* Khách hàng */
         .cus-table td:nth-child(7)  /* Địa chỉ */
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

         .btn-create{
             display:block;
             background: #1712c9;
             color: #fff;
             min-width: 110px;
             height: 45px;
             border-radius: 4px;
             font-weight: 700;
             padding: 0 14px;
             cursor: pointer;
             align-content: center;
             border: 2px solid #1712c9;
         }
         .btn-create:hover {
             background: #004aad;
             color: #fff;
             border-color: #004aad;
         }
     </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
             <div class="cus-page">
        <div class="cus-title">KHÁCH HÀNG</div>

        <div class="cus-toolbar">
            <asp:DropDownList ID="ddlField" runat="server" CssClass="cus-select">
                <asp:ListItem Text="Tên khách hàng" Value="Cus_Name" />
                <asp:ListItem Text="SĐT" Value="Cus_Phone" />
                <asp:ListItem Text="Địa chỉ" Value="Cus_Address" />
                <asp:ListItem Text="Mã khách" Value="Cus_ID" />
            </asp:DropDownList>
            <asp:TextBox ID="txtKeyword" runat="server" CssClass="cus-input" placeholder="Nhập thông tin cần tìm kiếm"></asp:TextBox>

            <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-search"
                OnClick="btnSearch_Click">
                <i class="bi bi-search"></i>
            </asp:LinkButton>

            <div class="d-flex ms-auto gap-2">
                <asp:LinkButton ID="btnCreate" runat="server" CssClass="btn btn-create"
                       OnClick="btnCreate_Click">
                       Thêm mới
                </asp:LinkButton>
                <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-del"
                    OnClientClick="return confirm('Bạn chắc chắn muốn xóa các khách hàng đã chọn?');"
                    OnClick="btnDelete_Click">
                    Xóa
                </asp:LinkButton>
            </div>
        </div>

        <div class="cus-table-wrap">
            <asp:GridView ID="gvCus" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="Cus_ID"
                CssClass="table table-hover align-middle cus-table"
                GridLines="None" 
                UseAccessibleHeader="true">

                <Columns>
                    <asp:TemplateField HeaderStyle-CssClass="col-check" ItemStyle-CssClass="col-check" HeaderStyle-BackColor="#d9d9d9">
                        <HeaderTemplate>
                            <input type="checkbox" onclick="toggleAll(this)" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="ckRow" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Mã khách" HeaderStyle-BackColor="#d9d9d9">
                        <ItemTemplate>
                            <a class="cus-id-link"
                               href='<%# "KhachhangChitiet.aspx?id=" + Eval("Cus_ID") %>' style="margin-left:30px">
                                <%# Eval("Cus_ID") %>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>
                
                    <asp:BoundField DataField="Cus_Name" HeaderText="Tên khách hàng" HeaderStyle-BackColor="#d9d9d9"/>

                
                    <asp:BoundField DataField="Cus_Phone" HeaderText="SĐT" HeaderStyle-BackColor="#d9d9d9"/>
                    <asp:BoundField DataField="Cus_Address" HeaderText="Địa chỉ" HeaderStyle-BackColor="#d9d9d9"/>
                    <asp:BoundField DataField="Cus_Total" HeaderText="Doanh thu" HeaderStyle-BackColor="#d9d9d9"  DataFormatString="{0:N0}" HtmlEncode="false"/>
                </Columns>

            </asp:GridView>
        </div>

        <asp:Label ID="lblMsg" runat="server" CssClass="text-danger fw-semibold" Visible="false"></asp:Label>
    </div>

    <script>
        function toggleAll(source) {
            var gv = document.getElementById('<%= gvCus.ClientID %>');
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

