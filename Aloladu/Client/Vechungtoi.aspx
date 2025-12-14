<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="Vechungtoi.aspx.cs" Inherits="Aloladu.Client.Vechungtoi" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
      .about-crumb{
          background:#f3f0d6;
          padding:10px 16px;
          font-weight:900;
          font-size:18px;
          color:#1712c9;
          border-radius:6px;
          margin: 10px 0 18px;
      }

      .about-wrap{
          max-width: 980px;
          margin: 0 auto;
          padding: 6px 0 24px;
      }

      .about-title{
          text-align:center;
          font-size:28px;
          font-weight:900;
          color:#1712c9;
          margin: 8px 0 26px;
          letter-spacing:.6px;
          text-transform: uppercase;
      }

      .info-grid{
          display:grid;
          grid-template-columns: repeat(4, 1fr);
          gap: 24px;
          margin-bottom: 22px;
      }

      .info-grid-2{
          display:grid;
          grid-template-columns: 1.4fr 1fr;
          gap: 24px;
          margin-bottom: 24px;
      }

      .item .lbl{
          font-weight:900;
          margin-bottom:4px;
      }
      .item .val{
          color:#333;
          font-size:14px;
      }

      .section{
          margin-top: 10px;
      }
      .section .lbl{
          font-weight:900;
          margin-bottom:10px;
      }
      .section .desc{
          color:#333;
          font-size:14px;
          line-height:1.85;
      }

      .brand-big{
          text-align:center;
          font-weight:900;
          font-size:86px;
          letter-spacing: 18px;
          color:#1712c9;
          margin: 24px 0 10px;
          user-select:none;
      }

      .timeline-title{
          font-weight:900;
          margin: 14px 0 14px;
      }

      .timeline{
          display:grid;
          grid-template-columns: 120px 30px 1fr;
          gap: 10px 12px;
          align-items:start;
      }
      .t-date{
          font-weight:900;
          color:#1712c9;
      }
      .t-mid{
          position:relative;
          height: 100%;
      }
      .t-mid:before{
          content:"";
          position:absolute;
          left: 13px;
          top: 0;
          bottom: 0;
          width:4px;
          background:#1712c9;
          border-radius:2px;
      }
      .t-dot{
          width:14px;
          height:14px;
          border-radius:50%;
          background:#1712c9;
          margin-left: 8px;
          margin-top: 3px;
      }
      .t-text{
          color:#333;
          font-size:14px;
          line-height:1.7;
          padding-bottom: 12px;
      }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="about-crumb">Về chúng tôi</div>
    <div class="about-wrap">

        <div class="about-title">GIỚI THIỆU DOANH NGHIỆP</div>

        <!-- Hàng 1 -->
        <div class="info-grid">
            <div class="item">
                <div class="lbl">Tên doanh nghiệp</div>
                <div class="val">ALOLADU</div>
            </div>
            <div class="item">
                <div class="lbl">Số đăng ký kinh doanh</div>
                <div class="val">03154578652</div>
            </div>
            <div class="item">
                <div class="lbl">Năm thành lập</div>
                <div class="val">12/12/2020</div>
            </div>
            <div class="item">
                <div class="lbl">Quy mô nhân sự</div>
                <div class="val">100~120 người</div>
            </div>

            <div class="item" style="grid-column: span 2;">
                <div class="lbl">Địa chỉ</div>
                <div class="val">
                    Ngõ 3 Đường Tôn Thất Thuyết, Phường Cầu Giấy, Hà Nội.
                </div>
            </div>

            <!-- 👉 CỘT 3: THẲNG VỚI "NĂM THÀNH LẬP" -->
            <div class="item">
                <div class="lbl">Thông tin liên hệ</div>
                <div class="val">aloladu.nhansu@gmail.com</div>
            </div>

            <!-- 👉 CỘT 4: TRỐNG (GIỮ CĂN LỀ) -->
            <div></div>
        </div>

      

        <!-- Lĩnh vực -->
        <div class="section">
            <div class="lbl">Lĩnh vực hoạt động</div>
            <div class="desc">
                Aloladu là hệ thống bán lẻ đồ gia dụng và thiết bị nhà bếp hướng tới trải nghiệm mua sắm đơn giản – tiện lợi – đáng tin cậy.
                Chúng tôi cung cấp đa dạng sản phẩm phục vụ đời sống hằng ngày như đồ bếp, thiết bị vệ sinh – dọn dẹp, đồ điện gia dụng, đồ trang trí,
                cùng các phụ kiện thông minh cho căn hộ hiện đại.

                <br /><br />
                Bên cạnh hoạt động thương mại, Aloladu chú trọng xây dựng nội dung tư vấn sử dụng sản phẩm, mẹo chăm sóc nhà cửa và hướng dẫn chọn mua đúng nhu cầu.
                Mục tiêu của chúng tôi là giúp khách hàng tiết kiệm thời gian, tối ưu chi phí và nâng cao chất lượng cuộc sống thông qua những lựa chọn phù hợp,
                chính hãng và có chính sách bảo hành rõ ràng.
            </div>
        </div>

        <div class="brand-big">ALOLADU</div>

        <!-- Timeline -->
        <div class="timeline-title">Quá trình phát triển</div>

        <div class="timeline">
            <div class="t-date">12/2020</div>
            <div class="t-mid"><div class="t-dot"></div></div>
            <div class="t-text">Chính thức thành lập và đưa doanh nghiệp vào hoạt động.</div>

            <div class="t-date">02/2021</div>
            <div class="t-mid"><div class="t-dot"></div></div>
            <div class="t-text">Đạt giải thưởng sáng tạo và phát triển của Bộ Kế hoạch và đầu tư.</div>

            <div class="t-date">02/2022</div>
            <div class="t-mid"><div class="t-dot"></div></div>
            <div class="t-text">Đạt giải thưởng sáng tạo và phát triển của Bộ Kế hoạch và đầu tư.</div>

            <div class="t-date">02/2023</div>
            <div class="t-mid"><div class="t-dot"></div></div>
            <div class="t-text">Mở chi nhánh 2 tại Hồ Chí Minh.</div>

            <div class="t-date">10/2025</div>
            <div class="t-mid"><div class="t-dot"></div></div>
            <div class="t-text">Mở chi nhánh 3 tại Đà Nẵng.</div>
        </div>

    </div>
</asp:Content>
