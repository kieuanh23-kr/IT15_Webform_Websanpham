<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.Master" AutoEventWireup="true" CodeBehind="TintucTuyendungChitiet.aspx.cs" Inherits="Aloladu.Admin.TintucTuyendungChitiet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style>
         .recs-title{
             font-size: 34px;
             font-weight: 900;
             color: #0b0bbf;
             margin-bottom: 18px;
             letter-spacing: .3px;
         }

         .recs-grid{
             display: grid;
             grid-template-columns: 1fr 1fr;
             gap: 18px 48px;
             max-width: 1800px;
         }

         .recs-field{ width: 100%; }

         .recs-span2{ grid-column: span 2; }

         .recs-label{
             font-weight: 800;
             margin-bottom: 8px;
         }

         .recs-input{
             width: 100%;
             padding: 10px 12px;
             border: 2px solid #0b0bbf;
             border-radius: 4px;
             font-weight: 600;
             background: #fff;
         }

         /* Disabled fields giống hình (xám) */
         .recs-input:disabled,
         .recs-input[disabled]{
             background: #e9e9e9;
             color: #222;
             opacity: 1;
         }

         /* dropdown có dấu > bên phải */
         .recs-select-wrap{ position: relative; }
         .recs-select{ appearance: none; padding-right: 36px; }
         .recs-arrow{
             position: absolute;
             right: 12px;
             top: 50%;
             transform: translateY(-50%);
             font-weight: 900;
             color: #222;
             pointer-events: none;
         }

         .recs-note{ resize: none; }

         .recs-actions{
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
     <div class="recs-title" runat="server" id="RecTitle">TIN TỨC &gt; TUYỂN DỤNG &gt; CHI TIẾT TIN TỨC </div>


     <div class="recs-grid">
         <!-- Row 1 -->
         <div class="recs-field">
             <div class="recs-label">Mã công việc</div>
             <asp:TextBox ID="txtRecID" runat="server" CssClass="recs-input" Enabled="false"></asp:TextBox>
         </div>
         <div class="recs-field">
             <div class="recs-label">Vị trí</div>
             <asp:TextBox ID="txtRecPos" runat="server" CssClass="recs-input" Enabled="true"></asp:TextBox>
         </div>

         <!-- Row 2 -->
         <div class="recs-field">
             <div class="recs-label">Hạn nộp CV</div>
             <asp:TextBox ID="txtRecDL" runat="server" CssClass="recs-input" TextMode="DateTimeLocal"></asp:TextBox>
         </div>
         <div class="recs-field">
            <div class="recs-label">Hình thức làm việc</div>
            <asp:TextBox ID="txtRecType" runat="server" CssClass="recs-input" Enabled="true"></asp:TextBox>
        </div>

         <!-- Row 3 -->
         <div class="recs-field">
             <div class="recs-label">Thời gian làm việc</div>
             <asp:TextBox ID="txtRecTime" runat="server" CssClass="recs-input" Enabled="true"></asp:TextBox>
         </div>
         <div class="recs-field">
             <div class="recs-label">Mức lương</div>
             <asp:TextBox ID="txtRecSal" runat="server" CssClass="recs-input" Enabled="true"></asp:TextBox>
         </div>

         <!-- Row 4 (full) -->
         <div class="recs-field recs-span2">
             <div class="recs-label">Địa chỉ</div>
             <asp:TextBox ID="txtRecAddress" runat="server" CssClass="recs-input" Enabled="true"></asp:TextBox>
         </div>


         <!-- Row 7 (full) -->
         <div class="recs-field recs-span2">
             <div class="recs-label">Mô tả công việc</div>
             <asp:TextBox ID="txtRecDesc" runat="server" CssClass="recs-input recs-note"
                 TextMode="MultiLine" Rows="2"></asp:TextBox>
         </div>
     </div>

     <div class="recs-actions">
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

