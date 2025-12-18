<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.Master" AutoEventWireup="true" CodeBehind="TintucTuyendung.aspx.cs" Inherits="Aloladu.Admin.TintucTuyendung" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <style>
             .recs-title{
                 font-size: 34px;
                 font-weight: 900;
                 color: #0b0bbf;
                 letter-spacing: .5px;
                 margin-bottom: 18px;
             }

          
             .recs-toolbar{
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 14px;
             }
             .recs-select{
                 min-width: 180px;
                 padding: 10px 12px;
                 border: 2px solid #1712c9;
                 border-radius: 4px;
                 font-weight: 700;
                 background: #fff;
             }

             .recs-input{
                 min-width: 320px;
                 padding: 10px 12px;
                 border: 2px solid #1712c9;
                 border-radius: 4px;
                 font-weight: 600;
             }

             /* vùng bảng có scroll, hiển thị 10 dòng */

             /* bảng */
             .recs-table{
                 margin: 0;
                 font-size: 15px;
             }
             .recs-table-wrap {
                 max-height: 600px; /* Tương đương ~10 dòng (mỗi dòng ~60px) */
                 overflow-y: auto;
                 overflow-x: auto;
                 border: 1px solid #e5e7eb;
                 border-radius: 8px;
                 position: relative;
             }

             /* header */
                 .recs-table thead th {
                     position: sticky !important;
                     top: 0;
                     z-index: 2;
                     font-weight: 700;
                     border-bottom: 1px solid #e6e6e6 !important;
                     white-space: nowrap;
                     padding: 12px 8px !important;
                 }

             /* cell */
                 .recs-table td {
                     border-bottom: 1px solid #f1f1f1;
                     vertical-align: middle;
                     padding: 12px 8px !important;
                 }

             /* hover */
             .recs-table tbody tr:hover{
                 background: #f9fbff;
             }

             /* cột checkbox */
             .col-check{
                 width: 48px;
                 text-align: center;
                 padding: 8px !important;
             }


             /* giới hạn chiều rộng chữ dài */
             .recs-table td:nth-child(5), /* Sản phẩm */
             .recs-table td:nth-child(6), /* Khách hàng */
             .recs-table td:nth-child(7)  /* Địa chỉ */
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
         <div class="recs-page">
    <div class="recs-title">TIN TỨC &gt; TUYỂN DỤNG</div>

    <div class="recs-toolbar">
        <asp:TextBox ID="txtKeyword" runat="server" CssClass="recs-input" placeholder="Nhập vị trí công việc cần tìm kiếm"></asp:TextBox>

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
                OnClientClick="return confirm('Bạn chắc chắn muốn xóa các sản phẩm đã chọn?');"
                OnClick="btnDelete_Click">
                Xóa
            </asp:LinkButton>
        </div>
    </div>

    <div class="recs-table-wrap">
        <asp:GridView ID="gvRecs" runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="Rec_ID"
            CssClass="table table-hover align-middle recs-table"
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

                <asp:TemplateField HeaderText="Mã công việc" HeaderStyle-BackColor="#d9d9d9">
                    <ItemTemplate>
                        <a class="recs-id-link"
                           href='<%# "TintucTuyendungChitiet.aspx?id=" + Eval("Rec_ID") %>' style="margin-left:30px">
                            <%# Eval("Rec_ID") %>
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:BoundField DataField="Rec_Pos" HeaderText="Vị trí" HeaderStyle-BackColor="#d9d9d9"/>


                <asp:BoundField DataField="Rec_DL"
                    HeaderText="Hạn nộp CV"
                    DataFormatString="{0:dd/MM/yyyy HH:mm}" HeaderStyle-BackColor="#d9d9d9"/>
                
                <asp:BoundField DataField="Rec_Type" HeaderText="Hình thức làm việc" HeaderStyle-BackColor="#d9d9d9"/>
                <asp:BoundField DataField="Rec_Sal" HeaderText="Mức lương" HeaderStyle-BackColor="#d9d9d9"/>
                <asp:BoundField DataField="Rec_Address" HeaderText="Địa điểm" HeaderStyle-BackColor="#d9d9d9"/>
            </Columns>

        </asp:GridView>
    </div>

    <asp:Label ID="lblMsg" runat="server" CssClass="text-danger fw-semibold" Visible="false"></asp:Label>
</div>

<script>
    function toggleAll(source) {
        var gv = document.getElementById('<%= gvRecs.ClientID %>');
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
