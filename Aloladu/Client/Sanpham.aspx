<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Sanpham.aspx.cs" Inherits="Aloladu.Client.Sanpham" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="ClientStyle.css" rel="stylesheet" />
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
    <!-- Track -->
        <div id="brandTrack" class="brand-row">
            <asp:Repeater ID="rptBrandProducts" runat="server">
                <ItemTemplate>
                    <div class="brand-item">
                        <!-- Reuse card sản phẩm (gọn) -->
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

                            <a class="p-add"
                               href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Footer brand + buttons -->
        <div class="brand-footer">
            <p class="brand-title">
                <asp:Literal ID="litBrandName" runat="server" />
            </p>

            <div class="brand-nav">
                <button type="button" id="btnPrev" class="brand-btn">&#x2039;</button>
                <button type="button" id="btnNext" class="brand-btn">&#x203A;</button>
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
     <!-- Track -->
         <div id="brandTrack" class="brand-row">
             <asp:Repeater ID="rptBrandProducts2" runat="server">
                 <ItemTemplate>
                     <div class="brand-item">
                         <!-- Reuse card sản phẩm (gọn) -->
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

                             <a class="p-add"
                                href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                         </div>
                     </div>
                 </ItemTemplate>
             </asp:Repeater>
         </div>

         <!-- Footer brand + buttons -->
         <div class="brand-footer">
             <p class="brand-title">
                 <asp:Literal ID="litBrandName2" runat="server" />
             </p>

             <div class="brand-nav">
                 <button type="button" id="btnPrev" class="brand-btn">&#x2039;</button>
                 <button type="button" id="btnNext" class="brand-btn">&#x203A;</button>
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
     <!-- Track -->
         <div id="brandTrack" class="brand-row">
             <asp:Repeater ID="rptBrandProducts3" runat="server">
                 <ItemTemplate>
                     <div class="brand-item">
                         <!-- Reuse card sản phẩm (gọn) -->
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

                             <a class="p-add"
                                href='<%# "Dathang.aspx?productId=" + Eval("Id") %>' title="Đặt hàng">+</a>
                         </div>
                     </div>
                 </ItemTemplate>
             </asp:Repeater>
         </div>

         <!-- Footer brand + buttons -->
         <div class="brand-footer">
             <p class="brand-title">
                 <asp:Literal ID="litBrandName3" runat="server" />
             </p>

             <div class="brand-nav">
                 <button type="button" id="btnPrev" class="brand-btn">&#x2039;</button>
                 <button type="button" id="btnNext" class="brand-btn">&#x203A;</button>
             </div>
         </div>
     </div>

    <script>
        (function () {
            const track = document.getElementById('brandTrack');
            const btnPrev = document.getElementById('btnPrev');
            const btnNext = document.getElementById('btnNext');

            if (!track) return;

            // Nếu ít item quá thì khỏi làm infinite
            function setupInfinite() {
                const items = Array.from(track.children);
                if (items.length < 2) return;

                // clone đầu & cuối để tạo hiệu ứng nối đuôi
                const firstClone = items[0].cloneNode(true);
                const lastClone = items[items.length - 1].cloneNode(true);

                firstClone.setAttribute('data-clone', '1');
                lastClone.setAttribute('data-clone', '1');

                track.insertBefore(lastClone, items[0]);
                track.appendChild(firstClone);

                // scroll tới item thật đầu tiên
                requestAnimationFrame(() => {
                    const step = getStep();
                    track.scrollLeft = step;
                });

                // khi chạm clone thì nhảy “không giật”
                track.addEventListener('scroll', onScrollLoop);
            }

            function getStep() {
                const first = track.querySelector('.brand-item');
                if (!first) return 0;

                // bước = width item + gap
                const style = getComputedStyle(track);
                const gap = parseFloat(style.columnGap || style.gap || 0);
                return first.getBoundingClientRect().width + gap;
            }

            let isJumping = false;
            function onScrollLoop() {
                if (isJumping) return;

                const step = getStep();
                const maxScroll = track.scrollWidth - track.clientWidth;

                // Nếu kéo về đầu (đụng clone cuối)
                if (track.scrollLeft <= 0) {
                    isJumping = true;
                    // nhảy tới vị trí item thật cuối
                    track.scrollLeft = maxScroll - step;
                    requestAnimationFrame(() => isJumping = false);
                }
                // Nếu kéo tới cuối (đụng clone đầu)
                else if (track.scrollLeft >= maxScroll) {
                    isJumping = true;
                    // nhảy tới vị trí item thật đầu
                    track.scrollLeft = step;
                    requestAnimationFrame(() => isJumping = false);
                }
            }

            function scrollByStep(dir) {
                const step = getStep();
                track.scrollBy({ left: dir * step, behavior: 'smooth' });
            }

            // Buttons
            btnPrev && btnPrev.addEventListener('click', () => scrollByStep(-1));
            btnNext && btnNext.addEventListener('click', () => scrollByStep(1));

            // Kéo chuột (drag to scroll) cho desktop
            let isDown = false;
            let startX = 0;
            let startScroll = 0;

            track.addEventListener('mousedown', (e) => {
                isDown = true;
                startX = e.pageX;
                startScroll = track.scrollLeft;
                track.style.cursor = 'grabbing';
                track.style.userSelect = 'none';
            });

            window.addEventListener('mouseup', () => {
                isDown = false;
                track.style.cursor = 'grab';
                track.style.userSelect = 'auto';
            });

            window.addEventListener('mousemove', (e) => {
                if (!isDown) return;
                const dx = e.pageX - startX;
                track.scrollLeft = startScroll - dx;
            });

            // Touch devices kéo tự nhiên (overflow hidden nên vẫn kéo được theo scrollLeft)
            // Nếu bạn muốn “kéo finger” mượt hơn, có thể thêm pointer events, nhưng hiện tại ổn.

            // init
            setupInfinite();
            track.style.cursor = 'grab';
        })();
    </script>
</asp:Content>
