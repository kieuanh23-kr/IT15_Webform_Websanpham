<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Timkiem.aspx.cs" Inherits="Aloladu.Client.Timkiem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style>
        :root{ --brand:#1712c9; --cream:#f3f0da; --card:#ffffff; }

        .titlebar{
            background: var(--cream);
            padding: 10px 18px;
            border-radius: 4px;
            color: var(--brand);
            font-weight: 900;
            font-size: 18px;
            margin-top: 12px;
        }

        .filters{
            display:flex;
            gap: 24px;
            align-items:flex-end;
            margin: 14px 0 10px;
        }

        .filter-item label{
            display:block;
            font-weight: 900;
            margin-bottom: 6px;
            font-size: 13px;
        }

         .ddl {
             border: 1.5px solid var(--brand);
             border-radius: 4px;
             padding: 6px 10px;
             width: 120px;
             height: 32px;
             font-size: 13px;
             background: #fff;
         }

        .section-row{
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap: 12px;
        }

        .nav-btns{
            display:flex;
            gap: 10px;
        }

        .nav-btn{
            width: 40px;
            height: 40px;
            border: 2px solid #1712c9;
            border-radius: 4px;
            display:flex;
            align-items:center;
            justify-content:center;
            background:#ffffff;
            color: #1712c9;
            font-weight: 900;
            text-decoration:none;
            cursor:pointer;
        }

        /* ===== PRODUCT GRID ===== */
        .p-grid{
            display:grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 26px 26px;
            margin-top: 18px;
            margin-bottom: 20px;
        }

        @media(max-width:1200px){ .p-grid{ grid-template-columns: repeat(4, 1fr);} }
        @media(max-width:992px){ .p-grid{ grid-template-columns: repeat(3, 1fr);} }
        @media(max-width:768px){ .p-grid{ grid-template-columns: repeat(2, 1fr);} }
        @media(max-width:480px){ .p-grid{ grid-template-columns: 1fr;} }

        /* Card sản phẩm */
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
        .p-desc{ 
            color: #222;
            font-size: 13px;
            margin-bottom: 8px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            flex-shrink: 0;
        }
        .p-old{ 
            color: #777;
            text-decoration: line-through;
            font-size: 14px;
            margin-bottom: 6px;
            flex-shrink: 0;
        }
        .p-price{  
             color: #ff2b2b;
             font-weight: 700;
             font-size: 30px;
             margin: 0;
             flex-shrink: 0;
             line-height: 1.2;
             word-break: break-all;  

        }
        /* Tự động giảm font-size khi giá quá dài */
        .p-price:has(+ *) {
            font-size: clamp(15px, 5vw, 30px);
        }
        .p-buy{
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
        .p-buy:hover{
            opacity: 0.92;
        }
        /* Tablet */
        @media (max-width: 992px) {
            .p-price {
                font-size: 25px;
            }
        }
        /* ===== NEWS SECTION ===== */
        .news-wrap{
            margin-top: 26px;
        }

        .blue-bar{
            background: var(--brand);
            color:#fff;
            padding: 10px 14px;
            border-radius: 6px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            font-weight: 700;
        }

        .news-grid-2{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-top: 14px;
        }
        @media(max-width:900px){ .news-grid-2{ grid-template-columns:1fr; } }

        .news-card{
            border:2px solid var(--brand);
            border-radius: 10px;
            overflow:hidden;
            background:#fff;
        }
        .news-card img{
            width:100%;
            height: 230px;
            object-fit: cover;
            display:block;
        }
        .news-card .news-title{
            padding: 14px 14px;
            color: var(--brand);
            font-weight: 900;
            font-size: 20px;
        }
        .news-card a{ text-decoration:none; }

        /* ===== RECRUIT ===== */
        .recruit-grid{
            display:grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-top: 14px;
        }
        @media(max-width:1200px){ .recruit-grid{ grid-template-columns: repeat(2,1fr);} }
        @media(max-width:650px){ .recruit-grid{ grid-template-columns: 1fr;} }

        .job-card{
            border:1.5px solid #1712c9;
            border-radius: 10px;
            overflow:hidden;
            background:#fff;
            padding:18px 18px 22px;
        }
        .job-head{
            text-align:center;
            font-weight: 700;
            font-size: 18px;
            color: #1712c9;
            padding: 12px 10px;
            border-bottom:1.5px solid #1712c9;
        }
        .job-body{ padding: 14px 16px 14px; font-size: 14px; }
        .job-label{ font-weight: 700; margin:10px 0 2px; }
        .job-more{
            display:block;              
              text-align:right;           
              margin-top:10px;
              font-size:12px;
              color:#777;
              text-decoration:none !important; 
        }
        .job-more:hover{
            color:#1712c9;
            text-decoration:none !important;
        }

        .empty{
            margin: 14px 0;
            color:#777;
            font-weight:700;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- ====== PHẦN 1: SẢN PHẨM ====== -->
    <div class="titlebar">
        <asp:Literal ID="litTitleProducts" runat="server"></asp:Literal>
    </div>

    <div class="section-row">
        <div class="filters">
            <div class="filter-item">
                <label>Giá thành</label>
                <asp:DropDownList ID="ddlPrice" runat="server" CssClass="ddl" AutoPostBack="true"
                    OnSelectedIndexChanged="FilterChanged">
                    <asp:ListItem Value="default" Text="Ngẫu nhiên" />
                    <asp:ListItem Value="asc" Text="Giá tăng dần" />
                    <asp:ListItem Value="desc" Text="Giá giảm dần" />
                </asp:DropDownList>
            </div>

            <div class="filter-item">
                <label>Hãng</label>
                <asp:DropDownList ID="ddlBrand" runat="server" CssClass="ddl" AutoPostBack="true"
                    OnSelectedIndexChanged="FilterChanged">
                </asp:DropDownList>
            </div>

            <div class="filter-item">
                <label>Phân loại</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="ddl" AutoPostBack="true"
                    OnSelectedIndexChanged="FilterChanged">
                </asp:DropDownList>
            </div>
        </div>

        <div class="nav-btns">
            <asp:LinkButton ID="btnProdPrev" runat="server" CssClass="nav-btn" OnClick="btnProdPrev_Click" CausesValidation="false">&#10094;</asp:LinkButton>
            <asp:LinkButton ID="btnProdNext" runat="server" CssClass="nav-btn" OnClick="btnProdNext_Click" CausesValidation="false">&#10095;</asp:LinkButton>
        </div>
    </div>

    <asp:Panel ID="pnEmptyProducts" runat="server" Visible="false" CssClass="empty">
        Không tìm thấy sản phẩm phù hợp.
    </asp:Panel>

    <asp:Repeater ID="rptProducts" runat="server">
        <HeaderTemplate><div class="p-grid"></HeaderTemplate>
        <ItemTemplate>
            <div class="p-card">
                <div class="p-img">
                    <img src="<%# Eval("ImageUrlFixed") %>" alt="sp" />
                </div>
                <div class="p-divider"></div>
                <div class="p-body">
                    <div class="p-name"><%# Eval("Name") %></div>
                    <div class="p-desc"><%# Eval("Description") %></div>
                    <div class="p-old"><%# Eval("OldPriceText") %></div>
                    <div class="p-price"><%# Eval("PriceText") %></div>

                    <a class="p-buy" href='<%# "Dathang.aspx?id=" + Eval("Id") %>' title="Mua">+</a>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>

    <!-- ====== PHẦN 2: TIN TỨC ====== -->
    <div class="news-wrap">
        <div class="titlebar">
            <asp:Literal ID="litTitleNews" runat="server"></asp:Literal>
        </div>

        <!-- Tin tức Cửa hàng & Sức khỏe -->
        <div class="blue-bar" style="margin-top:12px;">
            <div>Tin tức Cửa hàng &amp; Sức khỏe</div>
            <div class="nav-btns">
                <asp:LinkButton ID="btnNewsPrev" runat="server" Class="nav-btn" OnClick="btnNewsPrev_Click" CausesValidation="false">&#10094;</asp:LinkButton>
                <asp:LinkButton ID="btnNewsNext" runat="server" Class="nav-btn" OnClick="btnNewsNext_Click" CausesValidation="false">&#10095;</asp:LinkButton>
            </div>
        </div>

        <asp:Panel ID="pnEmptyNews" runat="server" Visible="false" CssClass="empty">
            Không tìm thấy tin tức cửa hàng/sức khỏe phù hợp.
        </asp:Panel>

        <asp:Repeater ID="rptNews" runat="server">
            <HeaderTemplate><div class="news-grid-2"></HeaderTemplate>
            <ItemTemplate>
                <div class="news-card">
                    <a href='<%# "TintucChitiet.aspx?id=" + Eval("Id") %>'>
                        <img src="<%# Eval("ImageUrlFixed") %>" alt="news" />
                        <div class="news-title"><%# Eval("Title") %></div>
                    </a>
                </div>
            </ItemTemplate>
            <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>

        <!-- Tin tức tuyển dụng -->
        <div class="blue-bar" style="margin-top:18px;">
            <div>Tin tức Tuyển dụng</div>
            <div class="nav-btns">
                <asp:LinkButton ID="btnJobPrev" runat="server" Class="nav-btn" OnClick="btnJobPrev_Click" CausesValidation="false">&#10094;</asp:LinkButton>
                <asp:LinkButton ID="btnJobNext" runat="server" Class="nav-btn" OnClick="btnJobNext_Click" CausesValidation="false">&#10095;</asp:LinkButton>
            </div>
        </div>

        <asp:Panel ID="pnEmptyJobs" runat="server" Visible="false" CssClass="empty">
            Không tìm thấy tin tuyển dụng phù hợp.
        </asp:Panel>

        <asp:Repeater ID="rptJobs" runat="server">
            <HeaderTemplate><div class="recruit-grid"></HeaderTemplate>
            <ItemTemplate>
                <div class="job-card">
                    <div class="job-head"><%# Eval("Position") %></div>

                    <div class="job-body">
                        <div class="job-label">Thời hạn tiếp nhận CV</div>
                        <div><%# Eval("DeadlineText") %></div>

                        <div class="job-label">Mức lương</div>
                        <div><%# Eval("Salary") %></div>

                        <div class="job-label">Hình thức làm việc</div>
                        <div><%# Eval("WorkType") %></div>
                    </div>

                    <a class="job-more" href='<%# "TintucTuyendung.aspx?id=" + Eval("Id") %>'>Xem thêm &gt;&gt;</a>
                </div>
            </ItemTemplate>
            <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
