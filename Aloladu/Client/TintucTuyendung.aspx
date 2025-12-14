<%@ Page Title="" Language="C#" MasterPageFile="~/Client/ClientMaster.Master" AutoEventWireup="true" CodeBehind="TintucTuyendung.aspx.cs" Inherits="Aloladu.Client.TintucTuyendung" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
      .crumb{
          background:#f3f0d6;
          padding:10px 16px;
          border-radius:6px;
          font-weight:900;
          color:#1712c9;
          margin: 10px 0 18px;
      }
      .title{
          text-align:center;
          font-size:28px;
          font-weight:700;
          color:#1712c9;
          margin: 10px 0 28px;
          text-transform: uppercase;
          letter-spacing:.5px;
      }

      .wrap-content{
            max-width:900px;
            margin:0 auto;
        }
      .grid{
          display:grid;
          grid-template-columns: 1fr 1fr;
          gap: 30px 60px;
          padding: 0 6px;
          margin-bottom: 26px;
      }
      .info-item .lbl{
          font-weight:900;
          margin-bottom:4px;
      }
      .info-item .val{
          color:#333;
          font-size:14px;
      }

      .section-title{
          font-weight:900;
          margin: 24px 0 10px;
          letter-spacing:.5px;
      }
      .desc{
          color:#333;
          line-height:1.8;
          font-size:14px;
          white-space: pre-line; 
          height: auto;

      }
      .block{
          margin-top: 22px;
      }
      .block .lbl{
          font-weight:900;
          margin-bottom:6px;
      }
      .block .val{
          color:#333;
          font-size:14px;
      }

       /*Gợi ý Tin tức Tuyển dụng*/
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
           font-weight:900;
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
           font-weight:900;
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

       .nav-btn {
          width: 30px; height: 30px;
          border-radius: 6px;
          border: 2px solid #fff;
          background: #1712c9;
          color: #fff;
          font-weight: 900;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          text-decoration:none;
          user-select:none;
        }
     
    </style>

    <div class="wrap">

        <div class="crumb">
            Tin tức &gt; Tin tức tuyển dụng
        </div>

        <div class="title">
            <asp:Literal ID="litPosition" runat="server" />
        </div>

        <div class ="wrap-content">
            <!-- 4 thông tin đầu -->
            <div class="grid">
                <div class="info-item">
                    <div class="lbl">Thời hạn tiếp nhận CV</div>
                    <div class="val"><asp:Literal ID="litDeadline" runat="server" /></div>
                </div>

                <div class="info-item">
                    <div class="lbl">Hình thức làm việc</div>
                    <div class="val"><asp:Literal ID="litWorkType" runat="server" /></div>
                </div>

                <div class="info-item">
                    <div class="lbl">Mức lương</div>
                    <div class="val"><asp:Literal ID="litSalary" runat="server" /></div>
                </div>

                <div class="info-item">
                    <div class="lbl">Thời gian làm việc</div>
                    <div class="val"><asp:Literal ID="litWorkingTime" runat="server" /></div>
                </div>
            </div>

            <!-- Mô tả -->
            <div class="section-title">Mô tả công việc</div>
            <div class="desc">
                <asp:Literal ID="litJobDesc" runat="server" />
            </div>

            <!-- Địa chỉ -->
            <div class="block">
                <div class="lbl">Địa chỉ</div>
                <div class="val"><asp:Literal ID="litLocation" runat="server" /></div>
            </div>

            <!-- Liên hệ (fix cứng) -->
            <div class="block" style="margin-bottom:30px;">
                <div class="lbl">Thông tin liên hệ</div>
                <div class="val">aloladu.nhansu@gmail.com</div>
            </div>
        </div>
    </div>

    <!--Gợi ý tin tức tuyển dụng khác-->
    <div class="recruit-wrap">
        <div class="recruit-head">
            <div class="recruit-title">Các tin tức tuyển dụng khác</div>
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
    
</asp:Content>
