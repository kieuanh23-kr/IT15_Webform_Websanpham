<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Sanpham.aspx.cs" Inherits="Aloladu.Client.Sanpham" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>

        /* Category Grid */
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

        /* CARD SẢN PHẨM - CỠ CỐ ĐỊNH*/
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

        .p-divider {
            height: 2px;
            background-color: #2e2dfb;
            flex-shrink: 0;
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

        .p-decrition {
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

        /*BRAND BOX - HIỂN THỊ 5 SẢN PHẨM VỚI SCROLL*/
        .brand-box {
            border: 3px solid #2e2dfb;
            border-radius: 14px;
            padding: 18px;
            margin-top: 18px;
            background: #fff;
        }

        .brand-viewport {
            overflow-x: auto;
            overflow-y: hidden;
            margin: 0 -18px; /* Bù lại padding để scroll full width */
            padding: 0 18px;
            scroll-behavior: smooth;
        }

        /* Ẩn scrollbar nhưng vẫn scroll được */
        .brand-viewport::-webkit-scrollbar {
            height: 8px;
        }

        .brand-viewport::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }

        .brand-viewport::-webkit-scrollbar-thumb {
            background: #2e2dfb;
            border-radius: 4px;
        }

        .brand-viewport::-webkit-scrollbar-thumb:hover {
            background: #1d1bd9;
        }

        .brand-row {
            display: flex;
            gap: 18px;
        }

        /* Mỗi sản phẩm có width cố định */
        .brand-item {
            flex: 0 0 calc((100% - 72px) / 5); 
            min-width: 200px; /* Width tối thiểu */
            max-width: 280px; /* Width tối đa */
        }

        /* ===== SẢN PHẨM BÁN CHẠY & GIẢM GIÁ - TƯƠNG TỰ ===== */
        .best-wrap {
            background: #1712c9;
            border-radius: 10px;
            padding: 15px;
            margin-top: 22px;
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
            gap: 18px;
            overflow-x: auto;
            padding: 0 8px 10px 8px;
            scroll-behavior: smooth;
            margin: 0 -15px; /* Bù lại padding */
            padding-left: 15px;
            padding-right: 15px;
        }

        .best-row::-webkit-scrollbar {
            height: 8px;
        }

        .best-row::-webkit-scrollbar-track {
            background: rgba(255,255,255,0.2);
            border-radius: 4px;
        }

        .best-row::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.5);
            border-radius: 4px;
        }

        .best-row::-webkit-scrollbar-thumb:hover {
            background: rgba(255,255,255,0.7);
        }

        .best-item {
            flex: 0 0 calc((100% - 72px) / 5);
            min-width: 200px;
            max-width: 280px;
        }

        /* Thanh brand footer */
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

        .brand-btn[disabled],
        .brand-btn.disabled {
            opacity: .4;
            pointer-events: none;
        }

        

        /* Tablet lớn */
        @media (max-width: 1200px) {
            .brand-item{
                flex: 0 0 calc((100% - 54px) / 4); /* 4 items */
            }
            .best-item {
                flex: 0 0 calc((100% - 54px) / 4); /* 4 items */
            }
        }

        /* Tablet */
        @media (max-width: 992px) {
            .cat-grid {
                grid-template-columns: repeat(3, 1fr);
            }
    
            .brand-item {
                flex: 0 0 calc((100% - 36px) / 3); /* 3 items */
            }
            .best-item {
                flex: 0 0 calc((100% - 36px) / 3); /* 3 items */
            }
            .p-price {
                font-size: 25px;
            }
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
                                    <img src='<%# Eval("Proc_Image") %>' alt='<%# Eval("Proc_Name") %>' />
                                </div>
                                <div class="p-divider"></div>
                                <div class="p-body">
                                    <div class="p-name"><%# Eval("Proc_Name") %></div>
                                    <div class="p-decrition"><%# Eval("Proc_Des") %></div>
                                    <div class="p-old"><%# FormatMoney(Eval("Proc_OldPrice")) %></div>
                                    <p class="p-price"><%# FormatMoney(Eval("Proc_Price")) %></p>
                                </div>

                                <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Proc_ID") %>' title="Đặt hàng">+</a>
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
                                <img src='<%# Eval("Proc_Image") %>' alt='<%# Eval("Proc_Name") %>' />
                            </div>
                            <div class="p-divider"></div>
                            <div class="p-body">
                                <div class="p-name"><%# Eval("Proc_Name") %></div>
                                <div class="p-decrition"><%# Eval("Proc_Des") %></div>
                                <div class="p-old"><%# FormatMoney(Eval("Proc_OldPrice")) %></div>
                                <p class="p-price"><%# FormatMoney(Eval("Proc_Price")) %></p>
                            </div>

                            <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Proc_ID") %>' title="Đặt hàng">+</a>
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
                                    <img src='<%# Eval("Proc_Image") %>' alt='<%# Eval("Proc_Name") %>' />
                                </div>
                                <div class="p-divider"></div>
                                <div class="p-body">
                                    <div class="p-name"><%# Eval("Proc_Name") %></div>
                                    <div class="p-decrition"><%# Eval("Proc_Des") %></div>
                                    <div class="p-old"><%# FormatMoney(Eval("Proc_OldPrice")) %></div>
                                    <p class="p-price"><%# FormatMoney(Eval("Proc_Price")) %></p>
                                </div>

                                <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Proc_ID") %>' title="Đặt hàng">+</a>
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
                                <img src='<%# Eval("Proc_Image") %>' alt='<%# Eval("Proc_Name") %>' />
                            </div>
                            <div class="p-divider"></div>
                            <div class="p-body">
                                <div class="p-name"><%# Eval("Proc_Name") %></div>
                                <div class="p-decrition"><%# Eval("Proc_Des") %></div>
                                <div class="p-old"><%# FormatMoney(Eval("Proc_OldPrice")) %></div>
                                <p class="p-price"><%# FormatMoney(Eval("Proc_Price")) %></p>
                            </div>

                            <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Proc_ID") %>' title="Đặt hàng">+</a>
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
                                    <img src='<%# Eval("Proc_Image") %>' alt='<%# Eval("Proc_Name") %>' />
                                </div>
                                <div class="p-divider"></div>
                                <div class="p-body">
                                    <div class="p-name"><%# Eval("Proc_Name") %></div>
                                    <div class="p-decrition"><%# Eval("Proc_Des") %></div>
                                    <div class="p-old"><%# FormatMoney(Eval("Proc_OldPrice")) %></div>
                                    <p class="p-price"><%# FormatMoney(Eval("Proc_Price")) %></p>
                                </div>

                                <a class="p-add" href='<%# "Dathang.aspx?productId=" + Eval("Proc_ID") %>' title="Đặt hàng">+</a>
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
