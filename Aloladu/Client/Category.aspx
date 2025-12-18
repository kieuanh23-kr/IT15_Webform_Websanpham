<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" 
    CodeBehind="Category.aspx.cs" Inherits="Aloladu.Client.Category" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="ClientStyle.css" rel="stylesheet" />
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
                <asp:DropDownList ID="ddlPrice" runat="server" CssClass="asp-ddl"
                    AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    <asp:ListItem Value="default" Text="Ngẫu nhiên" />
                    <asp:ListItem Value="asc" Text="Tăng dần" />
                    <asp:ListItem Value="desc" Text="Giảm dần" />
                </asp:DropDownList>
            </div>

            <div class="filter-group">
                <label>Hãng</label>
                <asp:DropDownList ID="ddlBrand" runat="server" CssClass="asp-ddl"
                    AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                </asp:DropDownList>
            </div>
        </div>

        <div class="filter-right">
            <asp:LinkButton ID="btnPrev" runat="server" CssClass="nav-btn" OnClick="btnPrev_Click">&#x2039;</asp:LinkButton>
            <asp:LinkButton ID="btnNext" runat="server" CssClass="nav-btn" OnClick="btnNext_Click">&#x203A;</asp:LinkButton>
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
