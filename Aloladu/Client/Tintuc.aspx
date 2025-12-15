<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Tintuc.aspx.cs" Inherits="Aloladu.Client.Tintuc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .news-header{
            background:#f3f0d6;
            padding:10px 16px;
            border-radius:6px;
            font-weight:900;
            color:#1d1bd9;
            font-size:18px;
            margin-bottom:12px;
        }

        .news-topbar{
            display:flex;
            align-items:center;
            justify-content:space-between;
            margin-bottom:12px;
        }
        .chips{ display:flex; gap:10px; }
        .chip{
            border:1.5px solid #2e2dfb;
            background:#fff;
            color:#111;
            border-radius:4px;
            padding:6px 10px;
            font-weight:800;
            font-size:13px;
            cursor:pointer;
        }
        .chip.active{
            background:#1712c9;
            color:#fff;
        }
         .chip,
            .chip:hover,
            .chip:focus {
                text-decoration: none !important;
            }


        .nav-btn {
            width: 30px; height: 30px;
            border-radius: 6px;
            border: 2px solid #2e2dfb;
            background: #1712c9;
            color: #fff;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration:none;
            user-select:none;
        }


        .news-feature{
            display:grid;
            grid-template-columns: 1.1fr 1fr;
            gap:18px;
            align-items:stretch;
            margin-bottom:16px;
            border:2px solid #2e2dfb;
            border-radius:10px;
            overflow:hidden;
            background:#fff;
        }
        .nf-img{
            height:260px;
            background:#fafafa;
            display:flex; align-items:center; justify-content:center;
        }
        .nf-img img{ width:100%; height:100%; object-fit:cover; }

        .nf-body{ padding:14px 16px; }
        .nf-title{
            color:#1712c9;
            font-weight:900;
            font-size:18px;
            margin-bottom:8px;
        }
        .nf-desc{
            font-size:13px;
            color:#333;
            line-height:1.4;
            height: 150px;
            overflow:hidden;
            text-align: justify;
        }
        .nf-more{
            display:block;              
            text-align:right;           
            margin-top:10px;
            font-size:12px;
            color:#777;
            text-decoration:none !important;  
        }

        .nf-more:hover{
            color:#1712c9;
            text-decoration:none !important;
        }

        .news-grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap:18px;
        }
        .news-card{
            border:2px solid #2e2dfb;
            border-radius:10px;
            overflow:hidden;
            background:#fff;
        }
        .nc-img{
            height:180px;
            background:#fafafa;
        }
        .nc-img img{ width:100%; height:100%; object-fit:cover; display:block; }
        .nc-title{
            padding:12px 14px;
            color:#1712c9;
            font-weight:900;
            font-size:18px;
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
        }

        /*Tin tức Tuyển dụng*/
        .recruit-wrap{
              margin-top: 50px;
              margin-bottom: 50px;
              background: #1712c9;
              border-radius: 10px;
              padding: 18px 18px 22px;
              color:#fff;
          }
          .recruit-head{
              display:flex;
              align-items:center;
              justify-content:space-between;
              margin-bottom:14px;
          }
          .recruit-title{
              font-weight:700;
              font-size:18px;
          }

          .recruit-grid{
              display:grid;
              grid-template-columns: repeat(4, 1fr);
              gap:18px;
              scroll-behavior:smooth;
          }

          .rc-card{
              background:#fff;
              color:#111;
              border-radius:10px;
              overflow:hidden;
              box-shadow: 0 0 0 0 rgba(0,0,0,0);
          }
          .rc-top{
              padding:16px 14px 12px;
              border-bottom: 2px solid #e7e7e7;
              font-weight:900;
              color:#1712c9;
              font-size:18px;
              text-align:center;
              letter-spacing:.5px;
          }
          .rc-body{ padding:14px 16px 14px; }
          .rc-label{
              font-weight:700;
              margin:10px 0 2px;
          }
          .rc-val{
              color:#333;
              font-size:14px;
          }
          .rc-more{
              display:block;              
                text-align:right;           
                margin-top:10px;
                font-size:12px;
                color:#777;
                text-decoration:none !important;  
          }
            .rc-more:hover{
                color:#1712c9;
                text-decoration:none !important;
            }
          .recruit-wrap .nav-btn {
              border: 2px solid #fff;
              background: #1712c9;
              color: #fff;
          }


    </style>

    
    <!--TIN TỨC CỬA HÀNG-->
    <div class="news-header">Tin tức cửa hàng</div>

    <div class="news-topbar">
        <div class="chips">
            <asp:LinkButton ID="btnDay" runat="server" CssClass="chip" OnClick="Range_Click" CommandArgument="day">Trong ngày</asp:LinkButton>
            <asp:LinkButton ID="btnWeek" runat="server" CssClass="chip" OnClick="Range_Click" CommandArgument="week">Trong tuần</asp:LinkButton>
            <asp:LinkButton ID="btnMonth" runat="server" CssClass="chip active" OnClick="Range_Click" CommandArgument="month">Trong tháng</asp:LinkButton>
        </div>

        <div style="display:flex; gap:10px;">
            <a class="nav-btn" href="javascript:void(0)">&#x2039;</a>
            <a class="nav-btn" href="javascript:void(0)">&#x203A;</a>
        </div>
    </div>

    <div class="news-wrap">

        <!-- BÀI CHÍNH -->
        <asp:Panel ID="pnFeatured" runat="server" Visible="false">
            <asp:Repeater ID="rptFeatured" runat="server">
                <ItemTemplate>
                    <a href='<%# "TintucChitiet.aspx?id=" + Eval("Id") %>' style="text-decoration:none; color:inherit;">
                        <div class="news-feature">
                            <div class="nf-img">
                                <img src="<%# Eval("ImageUrl") %>" alt="img" />
                            </div>
                            <div class="nf-body">
                                <div class="nf-title"><%# Eval("Title") %></div>
                                <div class="nf-desc"><%# Eval("ShortContent") %></div>
                                <asp:HyperLink runat="server" NavigateUrl='<%# "TintucChitiet.aspx?id=" + Eval("Id") %>' CssClass="nf-more">Xem thêm &gt;&gt;</asp:HyperLink>
                            </div>
                        </div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>

        <!-- 2 BÀI MỚI NHẤT -->
        <div class="news-grid">
            <asp:Repeater ID="rptLatest2" runat="server">
                <ItemTemplate>
                    <a href='<%# "TintucChitiet.aspx?id=" + Eval("Id") %>' style="text-decoration:none; color:inherit;">
                        <div class="news-card">
                            <div class="nc-img">
                                <img src="<%# Eval("ImageUrl") %>" alt="img" />
                            </div>
                            <div class="nc-title"><%# Eval("Title") %></div>
                        </div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnEmpty" runat="server" Visible="false" style="padding:10px; font-weight:800;">
            Chưa có bài viết nào.
        </asp:Panel>
    </div>

    <!-- TIN TỨC TUYỂN DỤNG -->
    <div class="recruit-wrap">
        <div class="recruit-head">
            <div class="recruit-title">Tin tức tuyển dụng</div>
            <div style="display:flex; gap:10px;">
                <a class="nav-btn" href="javascript:void(0)">&#x2039;</a>
                <a class="nav-btn" href="javascript:void(0)">&#x203A;</a>
            </div>
        </div>

       
        <div class="recruit-grid">
            <asp:Repeater ID="rptRecruit" runat="server">
                <ItemTemplate>
                    <div class="rc-card">
                        <div class="rc-top"><%# Eval("Position") %></div>

                        <div class="rc-body">
                            <div class="rc-label">Thời hạn tiếp nhận CV</div>
                            <div class="rc-val"><%# Eval("DeadlineText") %></div>

                            <div class="rc-label">Mức lương</div>
                            <div class="rc-val"><%# Eval("Salary") %></div>

                            <div class="rc-label">Hình thức làm việc</div>
                            <div class="rc-val"><%# Eval("WorkType") %></div>

                            <asp:HyperLink runat="server" NavigateUrl='<%# "TintucTuyendung.aspx?id=" + Eval("Id") %>' CssClass="rc-more">Xem thêm &gt;&gt;</asp:HyperLink>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>


    <!-- TIN TỨC SỨC KHỎE -->
    <div class="news-header" style="margin-top:18px;">Sức khỏe và đời sống</div>

    <div class="news-topbar">
        <div class="chips">
            <asp:LinkButton ID="btnDay2" runat="server" CssClass="chip" OnClick="Range_Click2" CommandArgument="day">Trong ngày</asp:LinkButton>
            <asp:LinkButton ID="btnWeek2" runat="server" CssClass="chip" OnClick="Range_Click2" CommandArgument="week">Trong tuần</asp:LinkButton>
            <asp:LinkButton ID="btnMonth2" runat="server" CssClass="chip active" OnClick="Range_Click2" CommandArgument="month">Trong tháng</asp:LinkButton>
        </div>

        <div style="display:flex; gap:10px;">
            <a class="nav-btn" href="javascript:void(0)">&#x2039;</a>
            <a class="nav-btn" href="javascript:void(0)">&#x203A;</a>
        </div>
    </div>

    <div class="news-wrap">

        <!-- BÀI CHÍNH -->
        <asp:Panel ID="pnFeatured2" runat="server" Visible="false">
            <asp:Repeater ID="rptFeatured2" runat="server">
                <ItemTemplate>
                    <a href='<%# "TintucChitiet.aspx?id=" + Eval("Id") %>' style="text-decoration:none; color:inherit;">
                        <div class="news-feature">
                            <div class="nf-img">
                                <img src="<%# Eval("ImageUrl") %>" alt="img" />
                            </div>
                            <div class="nf-body">
                                <div class="nf-title"><%# Eval("Title") %></div>
                                <div class="nf-desc"><%# Eval("ShortContent") %></div>
                                <asp:HyperLink runat="server" NavigateUrl='<%# "TintucChitiet.aspx?id=" + Eval("Id") %>' CssClass="nf-more">Xem thêm &gt;&gt;</asp:HyperLink>
                            </div>
                        </div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>

        <!-- 2 BÀI MỚI NHẤT -->
        <div class="news-grid">
            <asp:Repeater ID="rptLatest2_2" runat="server">
                <ItemTemplate>
                    <a href='<%# "TintucChitiet.aspx?id=" + Eval("Id") %>' style="text-decoration:none; color:inherit;">
                        <div class="news-card">
                            <div class="nc-img">
                                <img src="<%# Eval("ImageUrl") %>" alt="img" />
                            </div>
                            <div class="nc-title"><%# Eval("Title") %></div>
                        </div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnEmpty2" runat="server" Visible="false" style="padding:10px; font-weight:800;">
            Chưa có bài viết nào.
        </asp:Panel>

    </div>

</asp:Content>
