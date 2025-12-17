<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Sanpham.aspx.cs" Inherits="Aloladu.Client.Sanpham" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="ClientStyle.css" rel="stylesheet" />
    <style>
        .brand-viewport{
            overflow: hidden;   
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
                <img src="Images/download.png" alt="Đồ bếp" />
            </div>
            <div class="label">Đồ bếp</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=donha">
            <div class="thumb">
                <img src="Images/download.png" alt="Dọn nhà" />
            </div>
            <div class="label">Dọn nhà</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=saykho">
            <div class="thumb">
                <img src="Images/download.png" alt="Sấy khô" />
            </div>
            <div class="label">Sấy khô</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=dongho">
            <div class="thumb">
                <img src="Images/download.png" alt="Đồng hồ" />
            </div>
            <div class="label">Đồng hồ</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=bongden">
            <div class="thumb">
                <img src="Images/download.png" alt="Bóng đèn" />
            </div>
            <div class="label">Bóng đèn</div>
        </a>

        <a class="cat-card" href="Category.aspx?cat=giatla">
            <div class="thumb">
                <img src="Images/download.png" alt="Giặt là" />
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

        <div class="best-row" id="bestTrack">
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

        <div class="best-row" id="bestTrack">
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
