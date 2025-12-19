<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Donhang.aspx.cs" Inherits="Aloladu.Client.Donhang" %>
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

        .filter-bar{
            display:flex;
            align-items:flex-end;
            justify-content:space-between;
            gap:18px;
            margin-bottom:18px;
        }
        .filter-left{
            display:flex;
            gap:22px;
            flex-wrap:wrap;
            align-items:flex-end;
        }
        .fg label{
            display:block;
            font-weight:900;
            margin-bottom:6px;
            font-size: 13px;
        }
        .fg .ddl{
            width:120px;
            height:34px;
            border:1.5px solid #2e2dfb;
            border-radius:6px;
            padding:3px 8px;
            background:#fff;
            font-size:13px;
        }

        .nav-btn {
            width: 34px;
            height: 34px;
            border: 2px solid #1b1bd6;
            background: #fff;
            color: #1b1bd6;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none !important;
            cursor: pointer;
            user-select: none;
        }
        .nav-btn.opacity-50{ opacity:.45; pointer-events:none; }

        /* Card đơn hàng */
        .order-card{
            background:#fff7f7;
            border-radius:14px;
            padding:18px 18px 16px;
            margin-bottom:16px;
        }
        .order-top{
            display:flex;
            justify-content:space-between;
            align-items:center;
            font-weight:900;
            margin-bottom:12px;
        }
        .order-status{
            font-weight:900;
        }
        
        .st-wait{ color:#ff9800; }      /* Chờ xử lý (xanh như hình) */
        .st-prep{ color:#000000; }      /* Chuẩn bị giao */
        .st-ship{ color:#2bbf69; }      /* Đang giao */
        .st-done{ color:#2e2dfb; }      /* Hoàn thành*/

        .order-body{
            border-radius:12px;
            padding:14px;
            display:grid;
            grid-template-columns:110px 1fr 220px;
            gap:16px;
            align-items:center;
        }

        .o-img{
            width:110px; height:110px;
            border-radius:10px;
            background:#fff;
            display:flex; align-items:center; justify-content:center;
            overflow:hidden;
        }
        .o-img img{ width:100%; height:100%; object-fit:contain; padding:10px; }

        .o-name{
            font-size:22px;
            font-weight:900;
            color:#1712c9;
            margin-bottom:8px;
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
            max-width:520px;
        }
        .o-meta{ font-size:14px; margin:2px 0; }
        .o-meta b{ font-weight:900; }

        .o-price{
            text-align:right;
            font-size:14px;
        }
        .o-old{ color:#666; text-decoration:line-through; font-size:14px; }
        .o-new{ color:#ff2b2b; font-weight:900; font-size:16px; margin-top:4px; }
        .o-qty{ font-weight:900; margin-top:6px; }
        .o-total{ color:#1712c9; font-weight:900; font-size:26px; margin-top:10px; }

        .empty{
            background:#fff7f7;
            border-radius:14px;
            padding:18px;
            font-weight:800;
        }
        .lbDangnhap{
            margin: 14px 0;
            color:#777;
            font-weight:700;
        }

     .order-divider{
        height: 2px;
        background: #fff; 
        margin: 10px 0 14px;
        border-radius: 2px;
     }

    </style>

    <div class="page-title">Đơn hàng</div>

    <div class="filter-bar">
        <div class="filter-left">
            <div class="fg">
                <label>Trạng thái</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="ddl"
                    AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    <asp:ListItem Text="Tất cả" Value="all" />
                    <asp:ListItem Text="Chờ xử lý" Value="Chờ xử lý" />
                    <asp:ListItem Text="Chuẩn bị giao" Value="Chuẩn bị giao" />
                    <asp:ListItem Text="Đang giao" Value="Đang giao" />
                    <asp:ListItem Text="Hoàn thành" Value="Hoàn thành" />
                </asp:DropDownList>
            </div>

            <div class="fg">
                <label>Hãng</label>
                <asp:DropDownList ID="ddlBrand" runat="server" CssClass="ddl"
                    AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" />
            </div>

            <div class="fg">
                <label>Phân loại</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="ddl"
                    AutoPostBack="true" OnSelectedIndexChanged="FilterChanged" />
            </div>
        </div>

        <div style="display:flex; gap:10px;">
            <asp:LinkButton ID="btnPrev" runat="server" CssClass="nav-btn" OnClick="btnPrev_Click">&#10094;</asp:LinkButton>
            <asp:LinkButton ID="btnNext" runat="server" CssClass="nav-btn" OnClick="btnNext_Click">&#10095;</asp:LinkButton>
        </div>
    </div>


    <asp:Panel ID="pnEmpty" runat="server" CssClass="empty" Visible="false">
        Chưa có đơn hàng nào.
    </asp:Panel>

    <asp:Panel ID="pnDangnhap" runat="server"  Visible="false"> 
        <asp:Label runat="server" class="lbDangnhap" Text="Vui lòng "/><a href="Dangnhap.aspx" style="font-weight:700 "> Đăng nhập </a>
        <asp:Label runat="server" class="lbDangnhap" Text="  để xem giỏ hàng!"></asp:Label>
    </asp:Panel>

    <asp:Repeater ID="rptOrders" runat="server">
        <ItemTemplate>
            <div class="order-card">
                <div class="order-top">
                    <div>Ngày đặt: <span><%# Eval("CreatedText") %></span></div>
                    <div class='order-status <%# Eval("StatusClass") %>'><%# Eval("Status") %></div>
                </div>
                <div class="order-divider"></div>

                <div class="order-body">
                    <div class="o-img">
                        <img src="<%# Eval("ImageUrl") %>" alt="img" />
                    </div>

                    <div>
                        <div class="o-name"><%# Eval("ProductName") %></div>
                        <div class="o-meta"><b>Phân loại:</b> <%# Eval("CategoryKey") %></div>
                        <div class="o-meta"><b>Hãng:</b> <%# Eval("BrandName") %></div>
                        <div class="o-meta"><b>Mô tả:</b> <%# Eval("Description") %></div>
                    </div>

                    <div class="o-price">
                        <div class="o-old"><%# Eval("OldPriceText") %></div>
                        <div class="o-new"><%# Eval("PriceText") %></div>
                        <div class="o-qty">x<%# Eval("Quantity") %></div>
                        <div class="o-total"><%# Eval("TotalText") %></div>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>
