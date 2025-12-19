<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="TintucChitiet.aspx.cs" Inherits="Aloladu.Client.TintucChitiet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
      .crumb{
          background:#f3f0d6;
          padding:10px 16px;
          border-radius:6px;
          font-weight:900;
          color:#1712c9;
          margin-bottom:12px;
          font-size:18px;
      }
     
      .title{
          text-align:center;
          font-size:28px;
          font-weight:700;
          color:#1712c9;
          margin: 8px 0 4px;
          text-transform: uppercase;
      }
      .time{
          text-align:center;
          color:#777;
          font-size:12px;
          margin-bottom:12px;
      }
      .hero{
          width:100%;
          border-radius:10px;
          overflow:hidden;
          border:2px solid #e6e6e6;
          background:#fafafa;
      }
      .hero img{
          width:100%;
          height: 360px;
          object-fit: cover;
          display:block;
      }
      .content{
          margin-top:14px;
          color:#222;
          font-size:14px;
          line-height:1.7;
          white-space: pre-line; /* giữ xuống dòng nếu content là text thường */
      }
      .content h3{ margin-top:16px; }
      }

        /*BÀI VIẾT ĐỀ XUẤT*/
      .suggest-wrap{
          margin-top:22px;
          background:#1712c9 !important;         
          border-radius:12px;
          padding:18px;
      }
      .suggest-head{
          display:flex;
          align-items:center;
          justify-content:space-between;
          margin-bottom:14px;
          color:#fff;
      }
      .suggest-title{
          font-weight:900;
          font-size:18px;
      }
      .suggest-grid{
          display:grid;
          grid-template-columns: 1fr 1fr;
          gap:18px;

      }
      .sug-card{
          background:#fff;
          border-radius:12px;
          overflow:hidden;
          text-decoration:none !important;
          color:inherit;
          display:block;
      }
      .sug-img{
          height:260px;                
          background:#f3f3f3;
      }
      .sug-img img{
          width:100%;
          height:100%;
          object-fit:cover;
          display:block;
      }
      .sug-title{
          padding:12px 14px;
          color:#1712c9;
          font-weight:900;
          font-size:18px;
          text-align:center;
          white-space:nowrap;
          overflow:hidden;
          text-overflow:ellipsis;
      }
       .nav-btn {
             width: 30px; height: 30px;
             border-radius: 6px;
             border: 2px solid #fff;
             background: #1712c9;
             color: #fff;
             font-weight: 900;
             display: inline-flex;
             align-items: center;
             justify-content: center;
             text-decoration:none;
             user-select:none;
         }

    </style>

    <div class="wrap">

        <div class="crumb">
            Tin tức &gt; <asp:Literal ID="litBread" runat="server" />
        </div>

        <div class="title">
            <asp:Literal ID="litTitle" runat="server" />
        </div>

        <div class="time">
            Đăng tải lúc <asp:Literal ID="litTime" runat="server" />
        </div>

        <div class="hero">
            <asp:Image ID="imgCover" runat="server" AlternateText="Ảnh tin tức" />
        </div>

        <div class="content">
            <asp:Literal ID="litContent" runat="server" />
        </div>

    </div>

    
    <!--BÀI VIẾT ĐỀ XUÁT-->
    <div class="suggest-wrap" style="background:#1712c9 !important; padding:18px !important; border-radius:12px; margin-top:50px">
        <div class="suggest-head">
            <div class="suggest-title">Gợi ý các tin tức khác</div>
            <div style="display:flex; gap:10px;">
                <asp:LinkButton ID="btnSugPrev" runat="server" CssClass="nav-btn" OnClick="btnSugPrev_Click">&#10094;</asp:LinkButton>
                <asp:LinkButton ID="btnSugNext" runat="server" CssClass="nav-btn" OnClick="btnSugNext_Click">&#10095;</asp:LinkButton>
            </div>
        </div>

        <asp:Repeater ID="rptSuggest" runat="server">
            <HeaderTemplate>
                <div class="suggest-grid">
            </HeaderTemplate>

            <ItemTemplate>
                <a class="sug-card" href='<%# "TintucChitiet.aspx?id=" + Eval("Id") %>'>
                    <div class="sug-img">
                        <img src="<%# Eval("ImageUrl") %>" alt="img" />
                    </div>
                    <div class="sug-title"><%# Eval("Title") %></div>
                </a>
            </ItemTemplate>

            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>

    <!-- Lưu trạng thái phân trang gợi ý -->
    <asp:HiddenField ID="hdSugPage" runat="server" Value="1" />

</asp:Content>
