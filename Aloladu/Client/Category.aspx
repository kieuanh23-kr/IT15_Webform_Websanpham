<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" 
    CodeBehind="Category.aspx.cs" Inherits="Aloladu.Client.Category" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /*Card sản phẩm*/
        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(240px, 1fr));
            gap: 24px;
        }

        
        /* ===== CARD SẢN PHẨM - CỠ CỐ ĐỊNH ===== */
        .p-card {
            border: 2px solid #2e2dfb;
            border-radius: 18px;
            overflow: hidden;
            background: #fff;
            position: relative;
            height: 380px; /* Chiều cao cố định */
            width: 100%;
            display: flex;
            flex-direction: column;
        }

         .p-img {
             height: 220px; /* Chiều cao cố định cho ảnh */
             background: #fff;
             display: flex;
             align-items: center;
             justify-content: center;
             flex-shrink: 0;
         }

         .p-img img {
             width: 100%;
             height: 100%;
             object-fit: contain;
             padding: 14px;
         }


        .p-body {
            padding: 16px;
            padding-right: 64px; /* chừa chỗ cho nút + */
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

         .p-name {
            font-weight: 700;
             font-size: 15px;
             color: #1d1bd9;
             margin: 0 0 4px 0;
             white-space: nowrap;
             overflow: hidden;
             text-overflow: ellipsis;
             flex-shrink: 0;
         }

        .p-sub {
            color: #222;
            font-size: 13px;
            margin-bottom: 8px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            flex-shrink: 0;
        }

        .p-old {
            color: #777;
            text-decoration: line-through;
            font-size: 14px;
            margin-bottom: 6px;
            flex-shrink: 0;
        }

        .p-price {
            color: #ff2b2b;
            font-weight: 700;
            font-size: 30px;
            margin: 0;
            flex-shrink: 0;
            line-height: 1.2;
            word-break: break-all; /* Cho phép break nếu số quá dài */
        }

        /* Tự động giảm font-size khi giá quá dài */
        .p-price:has(+ *) {
            font-size: clamp(15px, 5vw, 30px);
        }
        .p-add {
             position: absolute;
             right: 16px;
             bottom: 16px;
             width: 40px;
             height: 40px;
             border-radius: 8px;
             border: none;
             background: #1d1bd9;
             color: #fff;
             display: flex;
             align-items: center;
             justify-content: center;
             font-size: 26px;
             text-decoration: none;
             flex-shrink: 0;
         }

         .p-add:hover {
             opacity: 0.92;
         }

        .p-divider {
            height: 2px;
            background-color: #2e2dfb;
            flex-shrink: 0;
        }
        
        
        .cat-header {
            background: #f3f0d6;
            padding: 10px 16px;
            border-radius: 6px;
            margin-bottom: 10px;
            font-weight: 900;
            color: #1d1bd9;
            font-size: 18px;
        }

        .filter-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 12px;
        }

        .filter-left {
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .filter-group label {
            font-size: 13px;
            font-weight: 700;
            display: block;
            margin-bottom: 4px;
        }

        .filter-group select,
        .filter-group .ddl {
            width:120px;
            height:34px;
            border:1.5px solid #2e2dfb;
            border-radius:6px;
            padding:3px 8px;
            background:#fff;
            font-size:13px;
        }

        .filter-right {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .nav-btn {
            width: 34px;
            height:34px;
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
        .nav-btn.disabled {
                opacity: 0.5;
                cursor: not-allowed;
                pointer-events: none;
            }

        .grid-5 {
            display: grid;
            grid-template-columns: repeat(5, 1fr); /* 5 card / hàng */
            gap: 20px;
            align-items: stretch;
        }

        /*Table*/
        @media (max-width: 992px) {
            .grid-5{
                grid-template-columns: repeat(3, 1fr);
            }
            .p-price {
                font-size: 25px;
            }
        }
       

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb -->
    <div class="cat-header">
        Sản phẩm &gt; <asp:Literal ID="litCatName" runat="server" />
    </div>

    <!-- Filters + paging buttons -->
    <div class="filter-bar">
        <div class="filter-left">
            <div class="filter-group">
                <label>Giá thành</label>
                <asp:DropDownList ID="ddlPrice" runat="server" CssClass="ddl"
                    AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    <asp:ListItem Value="default" Text="Ngẫu nhiên" />
                    <asp:ListItem Value="asc" Text="Tăng dần" />
                    <asp:ListItem Value="desc" Text="Giảm dần" />
                </asp:DropDownList>
            </div>

            <div class="filter-group">
                <label>Hãng</label>
                <asp:DropDownList ID="ddlBrand" runat="server" CssClass="ddl"
                    AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                </asp:DropDownList>
            </div>
        </div>

        <div class="filter-right">
            <asp:LinkButton ID="btnPrev" runat="server" CssClass="nav-btn" OnClick="btnPrev_Click" Style="width:34px; height:34px">&#10094;</asp:LinkButton>
            <asp:LinkButton ID="btnNext" runat="server" CssClass="nav-btn" OnClick="btnNext_Click" Style="width:34px; height:34px">&#10095;</asp:LinkButton>
        </div>
    </div>

    <!-- Grid products -->
    <div class="grid-5">
        <asp:Repeater ID="rptCatProducts" runat="server">
            <ItemTemplate>
                <div class="p-card">
                    <div class="p-img">
                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' />
                    </div>
                    <div class="p-divider"></div>
                    <div class="p-body">
                        <div class="p-name"><%# Eval("Name") %></div>
                        <div class="p-sub"><%# Eval("Description") %></div>
                        <div class="p-old"><%# FormatMoney(Eval("OldPrice")) %></div>
                        <p class="p-price"><%# FormatMoney(Eval("Price")) %></p>
                    </div>

                    <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
