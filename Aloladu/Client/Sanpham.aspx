<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Sanpham.aspx.cs" Inherits="Aloladu.Client.Sanpham" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>

        .cat-grid {
            display: grid;
            grid-template-columns: repeat(6, minmax(120px, 1fr));
            gap: 24px;
            margin-bottom: 24px;
            width: 100%;
        }

        .cat-card {
            text-decoration: none;
            color: #111;
            text-align: center;
        }

            .cat-card .thumb {
                border: 2px solid #3b2bf6;
                border-radius: 14px;
                height: 240px;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 12px;
                background: #fff;
            }

            .cat-card img {
                max-width: 100%;
                max-height: 100%;
                object-fit: contain;
            }

            .cat-card .label {
                margin-top: 10px;
                font-weight: 700;
            }

        /*Card sản phẩm*/
        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(240px, 1fr));
            gap: 24px;
        }

        .p-card {
            border: 2px solid #2e2dfb;
            border-radius: 18px;
            overflow: hidden;
            background: #fff;
            position: relative;
            height: 100%;
            margin-right: 8px;
        }

        .p-img {
            height: 200px;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
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
        }

        .p-name {
            font-weight: 700;
            font-size: 15px;
            color: #1d1bd9;
            margin: 2px 0 2px;
            white-space: nowrap; /* KHÔNG cho xuống dòng */
            overflow: hidden; /* Ẩn phần dư */
            text-overflow: ellipsis;
        }

        .p-sub {
            color: #222;
            font-size: 15px;
            margin-bottom: 10px;
        }

        .p-old {
            color: #777;
            text-decoration: line-through;
            font-size: 15px;
            margin-bottom: 6px;
        }

        .p-price {
            color: #ff2b2b;
            font-weight: 700;
            font-size: 30px;
            margin: 0;
        }

        .p-add {
            position: absolute;
            right: 16px;
            bottom: 16px;
            width: 44px;
            height: 44px;
            border-radius: 8px;
            border: none;
            background: #1d1bd9;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            text-decoration: none;
        }

            .p-add:hover {
                opacity: 0.92;
            }

        .p-divider {
            height: 2px;
            background-color: #2e2dfb; /* cùng màu viền card */
        }


        /* ===== Brand carousel wrapper ===== */
        .brand-box {
            border: 3px solid #2e2dfb;
            border-radius: 14px;
            padding: 18px;
            margin-top: 18px;
            background: #fff;
        }

        .brand-row {
            display: flex;
            gap: 16px;
            overflow: hidden;
            flex-wrap: nowrap;
        }

        /* mỗi item có width cố định để scroll theo “bước” */
        .brand-item {
            flex: 0 0 220px;
        }

        /* Thanh brand dưới */
        .brand-footer {
            margin-top: 16px;
            background: #1712c9;
            border-radius: 10px;
            padding: 14px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: #fff;
        }

        .brand-title {
            font-size: 20px;
            font-weight: 800;
            margin: 0;
        }

        .brand-nav {
            display: flex;
            gap: 10px;
            text-decoration: none !important;
        }

        .brand-btn {
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

            .brand-btn:hover {
                opacity: 0.9;
            }

            /*Sản phẩm bán chạy*/
        .best-wrap {
            background: #1712c9;
            border-radius: 10px;
            padding: 15px;
            margin-top: 22px;
            justify-content: space-evenly;
        }

        .best-title {
            color: #fff;
            text-align: center;
            font-weight: 700;
            letter-spacing: .5px;
            margin: 0 0 16px;
            text-transform: uppercase;
        }

        .best-row {
            display: flex;
            gap: 25px;
            overflow-x: auto;
            padding: 0 8px 10px 8px; /* Thêm padding-bottom */
            scroll-behavior: smooth;
            justify-content: center;

        }
        .best-row .p-name {
            font-weight: 700;
            font-size: 15px;
            color: #1d1bd9;
            margin: 2px 0 2px;
            white-space: nowrap; /* KHÔNG cho xuống dòng */
            overflow: hidden; /* Ẩn phần dư */
            text-overflow: ellipsis;
        }
        .best-item {
            flex: 0 0 230px;
            min-width: 200px;
        }



        .brand-btn[disabled],
        .brand-btn.disabled{
            opacity: .4;
            pointer-events: none;
        }



    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!--Category đầu trang-->
    <div class="cat-grid">
        <a class="cat-card" href="Category.aspx?cat=dobep">
            <div class="thumb">
                <img src="<%= ResolveUrl("~/Images/do-bep.png") %>" alt="Đồ bếp" />
            </div>
            <div class="label">Đồ bếp</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=donha">
            <div class="thumb">
                <img src="<%= ResolveUrl("~/Images/don-nha.png") %>" alt="Dọn nhà" />
            </div>
            <div class="label">Dọn nhà</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=saykho">
            <div class="thumb">
                <img src="<%= ResolveUrl("~/Images/may-say.png") %>" alt="Sấy khô" />
            </div>
            <div class="label">Sấy khô</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=dongho">
            <div class="thumb">
                <img src="<%= ResolveUrl("~/Images/dong-ho.png") %>" alt="Đồng hồ" />
            </div>
            <div class="label">Đồng hồ</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=bongden">
            <div class="thumb">
                <img src="<%= ResolveUrl("~/Images/bong-den.png") %>" alt="Bóng đèn" />
            </div>
            <div class="label">Bóng đèn</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=giatla">
            <div class="thumb">
                <img src="<%= ResolveUrl("~/Images/ban-la.png") %>" alt="Giặt là" />
            </div>
            <div class="label">Giặt là</div>
        </a>
    </div>


    <!--Sản phẩm theo brand 1-->
    <div class="brand-box">
        <div class="brand-viewport">
            <div class="brand-row">
                <asp:Repeater ID="rptBrandProducts" runat="server">
                    <ItemTemplate>
                        <div class="brand-item">
                            <div class="p-card">
                                <div class="p-img">
                                    <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' />
                                </div>
                                <div class="p-divider"></div>
                                <div class="p-body">
                                    <div class="p-name"><%# Eval("Name") %></div>
                                    <div class="p-decrition"><%# Eval("Description") %></div>
                                    <div class="p-old"><%# FormatMoney(Eval("OldPrice")) %></div>
                                    <p class="p-price"><%# FormatMoney(Eval("Price")) %></p>
                                </div>

                                <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="brand-footer">
            <p class="brand-title">
                <asp:Literal ID="litBrandName" runat="server" />
            </p>

            <div class="brand-nav">
                <asp:LinkButton ID="btnPrevBrand1" runat="server" CssClass="brand-btn"
                    OnClick="btnPrevBrand1_Click" CausesValidation="false">&#10094;</asp:LinkButton>

                <asp:LinkButton ID="btnNextBrand1" runat="server" CssClass="brand-btn"
                    OnClick="btnNextBrand1_Click" CausesValidation="false">&#10095;</asp:LinkButton>
            </div>
        </div>
    </div>


    <!--Sản phẩm bán chạy-->
    <div class="best-wrap">
        <h4 class="best-title">SẢN PHẨM BÁN CHẠY</h4>

        <div class="best-row" id="bestTrack" >
            <asp:Repeater ID="rptTopSelling" runat="server">
                <ItemTemplate>
                    <div class="best-item">
                        <div class="p-card">
                            <div class="p-img">
                                <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' />
                            </div>
                            <div class="p-divider"></div>
                            <div class="p-body">
                                <div class="p-name"><%# Eval("Name") %></div>
                                <div class="p-decrition"><%# Eval("Description") %></div>
                                <div class="p-old"><%# FormatMoney(Eval("OldPrice")) %></div>
                                <p class="p-price"><%# FormatMoney(Eval("Price")) %></p>
                            </div>

                            <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

     <!--Sản phẩm theo brand 2-->
    <div class="brand-box">
            <div class="brand-viewport">
                <div class="brand-row">
                    <asp:Repeater ID="rptBrandProducts2" runat="server">
                    <ItemTemplate>
                        <div class="brand-item">
                            <div class="p-card">
                                <div class="p-img">
                                    <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' />
                                </div>
                                <div class="p-divider"></div>
                                <div class="p-body">
                                    <div class="p-name"><%# Eval("Name") %></div>
                                    <div class="p-decrition"><%# Eval("Description") %></div>
                                    <div class="p-old"><%# FormatMoney(Eval("OldPrice")) %></div>
                                    <p class="p-price"><%# FormatMoney(Eval("Price")) %></p>
                                </div>

                                <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="brand-footer">
            <p class="brand-title"><asp:Literal ID="litBrandName2" runat="server" /></p>
            <div class="brand-nav">
                <asp:LinkButton ID="btnPrevBrand2" runat="server" CssClass="brand-btn"
                    OnClick="btnPrevBrand2_Click" CausesValidation="false">&#10094;</asp:LinkButton>
                <asp:LinkButton ID="btnNextBrand2" runat="server" CssClass="brand-btn"
                    OnClick="btnNextBrand2_Click" CausesValidation="false">&#10095;</asp:LinkButton>
            </div>
        </div>
    </div>

    <!--Sản phẩm giảm giá nhiều nhất-->
    <div class="best-wrap">
        <h4 class="best-title">SẢN PHẨM GIẢM GIÁ NHIỀU NHẤT</h4>

        <div class="best-row" id="bestSale">
            <asp:Repeater ID="rptTopDeals" runat="server">
                <ItemTemplate>
                    <div class="best-item">
                        <div class="p-card">
                            <div class="p-img">
                                <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' />
                            </div>
                            <div class="p-divider"></div>
                            <div class="p-body">
                                <div class="p-name"><%# Eval("Name") %></div>
                                <div class="p-decrition"><%# Eval("Description") %></div>
                                <div class="p-old"><%# FormatMoney(Eval("OldPrice")) %></div>
                                <p class="p-price"><%# FormatMoney(Eval("Price")) %></p>
                            </div>

                            <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

     <!--Sản phẩm theo brand 3-->
    <div class="brand-box">
        <div class="brand-viewport">
            <div class="brand-row">
                <asp:Repeater ID="rptBrandProducts3" runat="server">
                    <ItemTemplate>
                        <div class="brand-item">
                            <div class="p-card">
                                <div class="p-img">
                                    <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Name") %>' />
                                </div>
                                <div class="p-divider"></div>
                                <div class="p-body">
                                    <div class="p-name"><%# Eval("Name") %></div>
                                    <div class="p-decrition"><%# Eval("Description") %></div>
                                    <div class="p-old"><%# FormatMoney(Eval("OldPrice")) %></div>
                                    <p class="p-price"><%# FormatMoney(Eval("Price")) %></p>
                                </div>

                                <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="brand-footer">
            <p class="brand-title"><asp:Literal ID="litBrandName3" runat="server" /></p>
            <div class="brand-nav">
                <asp:LinkButton ID="btnPrevBrand3" runat="server" CssClass="brand-btn"
                    OnClick="btnPrevBrand3_Click" CausesValidation="false">&#10094;</asp:LinkButton>
                <asp:LinkButton ID="btnNextBrand3" runat="server" CssClass="brand-btn"
                    OnClick="btnNextBrand3_Click" CausesValidation="false">&#10095;</asp:LinkButton>
            </div>
        </div>
    </div>
</asp:Content>
