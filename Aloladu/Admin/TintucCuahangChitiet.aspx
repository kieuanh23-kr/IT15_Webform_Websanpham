<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.Master" AutoEventWireup="true" CodeBehind="TintucCuahangChitiet.aspx.cs" Inherits="Aloladu.Admin.TintucCuahangChitiet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <style>
            .news-title{
                font-size: 34px;
                font-weight: 900;
                color: #0b0bbf;
                margin-bottom: 18px;
                letter-spacing: .3px;
            }

            .news-grid{
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 18px 48px;
                max-width: 1800px;
            }

            .news-field{ width: 100%; }

            .news-span2{ grid-column: span 2; }
            

            .news-label{
                font-weight: 800;
                margin-bottom: 8px;
            }

            .news-input{
                width: 100%;
                padding: 10px 12px;
                border: 2px solid #0b0bbf;
                border-radius: 4px;
                font-weight: 600;
                background: #fff;
            }

            /* Disabled fields giống hình (xám) */
            .news-input:disabled,
            .news-input[disabled]{
                background: #e9e9e9;
                color: #222;
                opacity: 1;
            }

            /* dropdown có dấu > bên phải */
            .news-select-wrap{ position: relative; }
            .news-select{ appearance: none; padding-right: 36px; }
            .news-arrow{
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                font-weight: 900;
                color: #222;
                pointer-events: none;
            }

            .news-note{ resize: none; }

            .news-actions{
                margin-top: 22px;
                display: flex;
                gap: 16px;
                justify-content: right;
            }
            .btn {
                height: 45px;
                min-width: 110px;
                border-radius: 4px;
                font-weight: 700;
                padding: 0 14px;
                align-content: center;
            }
             /* Image Upload Section */
            .news-image-section {
                display: flex;
                align-items: flex-start;
                gap: 20px;
            }

            .news-upload-box {
                width: 300px;
                height: 150px;
                border: 2px dashed #0b0bbf;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                background: #f8f8ff;
                transition: all 0.3s;
            }

            .news-upload-box:hover {
                background: #f0f0ff;
                border-color: #0808aa;
            }

            .news-upload-icon {
                font-size: 48px;
                color: #0b0bbf;
                font-weight: 300;
            }

            .news-image-preview {
                position: relative;
                display: none;
            }

            .news-image-preview.show {
                display: block;
            }

            .news-preview-img {
                width: 300px;
                height: 150px;
                object-fit: cover;
                border-radius: 4px;
                border: 2px solid #0b0bbf;
            }

            .news-image-name {
                margin-top: 8px;
                font-size: 12px;
                color: #666;
                text-align: center;
                word-break: break-all;
            }

            .news-close-btn {
                position: absolute;
                top: -8px;
                right: -8px;
                width: 24px;
                height: 24px;
                border-radius: 50%;
                background: #000;
                color: #fff;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 16px;
                line-height: 1;
                font-weight: bold;
            }

            .news-close-btn:hover {
                background: #333;
            }

            .news-upload-hint {
                color: #666;
                font-size: 13px;
                margin-top: 8px;
            }

            .news-actions{
                margin-top: 22px;
                display: flex;
                gap: 16px;
                justify-content: right;
            }
    
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <div class="news-title" runat="server" id="ProcTitle">TIN TỨC &gt; CỬA HÀNG &gt; CHI TIẾT TIN TỨC</div>


     <div class="news-grid">
         <!-- Row 1 -->
         <div class="news-field">
             <div class="news-label">Thời gian đăng tải</div>
             <asp:TextBox ID="txtNewsTime" runat="server" CssClass="news-input" Enabled="false"></asp:TextBox>
         </div>
         <div class="news-field">
             <div class="news-field">
                <div class="news-label">Tin nổi bật</div>
                        <asp:RadioButton ID="rbYes" runat="server" GroupName="NewsFeature" Text="Có" Value="1" style="margin-right:50px"/>
                        <asp:RadioButton ID="rbNo" runat="server" GroupName="NewsFeature" Text="Không" Value="0" />
            </div>
         </div>

         <!-- Row 2 -->
         <div class="news-field news-span2">
            <div class="news-label">Tiêu đề</div>
            <asp:TextBox ID="txtNewsTitle" runat="server" CssClass="news-input" Enabled="true"></asp:TextBox>
        </div>

         <!-- Row 3 -->
         <div class="news-field news-span2">
            <div class="news-label">Nội dung</div>
            <asp:TextBox ID="txtNewsCont" runat="server" CssClass="news-input" Enabled="true" TextMode="MultiLine" Rows="5"></asp:TextBox>
        </div>

         <!-- Row 6: Image Upload -->
         <div class="news-field news-span2">
             <div class="news-label">Ảnh tin tức</div>
             <div class="news-image-section">
                 <div class="news-upload-box" id="uploadBox" onclick="document.getElementById('<%=fuProcImage.ClientID%>').click();">
                     <div class="news-upload-icon">+</div>
                 </div>
             
                 <div class="news-image-preview" id="imagePreview">
                     <asp:Image ID="imgPreview" runat="server" CssClass="news-preview-img" />
                     <button type="button" class="pr-close-btn" onclick="removeImage()">×</button>
                     <div class="news-image-name" id="imageName"></div>
                 </div>

                 <asp:FileUpload ID="fuProcImage" runat="server" style="display:none;" accept="image/*" onchange="previewImage(this);" />
                 <asp:HiddenField ID="hdnImageUrl" runat="server" />
             </div>
             <div class="news-upload-hint">Lưu ý: Chọn ảnh có kích tỷ lệ 2:1</div>
         </div>
     </div>



     <div class="news-actions">
         <asp:Label ID="lblMsg" runat="server" CssClass="fw-semibold d-block mb-3" Visible="false"></asp:Label>
         <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-outline-primary" OnClick="btnBack_Click">
             Thoát
         </asp:LinkButton>

         <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-dark"
             OnClientClick="return confirm('Bạn chắc chắn muốn xóa tin tức này?');"
             OnClick="btnDelete_Click">
             Xóa
         </asp:LinkButton>

         <asp:LinkButton ID="btnUpdate" runat="server" CssClass="btn btn-primary"
             OnClick="btnUpdate_Click">
             Cập nhật
         </asp:LinkButton>
     </div>

     <script type="text/javascript">
         function previewImage(input) {
             var preview = document.getElementById('imagePreview');
             var uploadBox = document.getElementById('uploadBox');
             var imgElement = document.getElementById('<%=imgPreview.ClientID%>');
             var nameElement = document.getElementById('imageName');
             var hdnImageUrl = document.getElementById('<%=hdnImageUrl.ClientID%>');

             if (input.files && input.files[0]) {
                 // Kiểm tra kích thước file (tối đa 5MB)
                 var fileSize = input.files[0].size / 1024 / 1024; // Convert to MB
                 if (fileSize > 5) {
                     alert('Kích thước ảnh không được vượt quá 5MB. Vui lòng chọn ảnh khác.');
                     input.value = ''; // Clear file input
                     return;
                 }

                 var reader = new FileReader();
             
                 reader.onload = function(e) {
                     imgElement.src = e.target.result;
                     nameElement.textContent = input.files[0].name;
                     preview.classList.add('show');
                     uploadBox.style.display = 'none';
                 };
             
                 reader.readAsDataURL(input.files[0]);
             }
             hdnImageUrl.value = 'new_upload'; // Mark as new upload
         };

         function removeImage() {
             var preview = document.getElementById('imagePreview');
             var uploadBox = document.getElementById('uploadBox');
             var imgElement = document.getElementById('<%=imgPreview.ClientID%>');
             var nameElement = document.getElementById('imageName');
             var hdnImageUrl = document.getElementById('<%=hdnImageUrl.ClientID%>');
             var fileInput = document.getElementById('<%=fuProcImage.ClientID%>');

             // Clear preview
             imgElement.src = '';
             nameElement.textContent = '';
             preview.classList.remove('show');
             uploadBox.style.display = 'flex';

             // Clear file input
             fileInput.value = '';

             // Clear hidden field (will delete image on save)
             hdnImageUrl.value = '';
         };


         // Load existing image on page load
         window.onload = function() {
             var hdnImageUrl = document.getElementById('<%=hdnImageUrl.ClientID%>');
             var imgElement = document.getElementById('<%=imgPreview.ClientID%>');
             var preview = document.getElementById('imagePreview');
             var uploadBox = document.getElementById('uploadBox');
             var nameElement = document.getElementById('imageName');

             if (hdnImageUrl.value && hdnImageUrl.value !== '' && hdnImageUrl.value !== 'new_upload') {
                 imgElement.src = '../Images_News/' + hdnImageUrl.value;
                 nameElement.textContent = hdnImageUrl.value;
                 preview.classList.add('show');
                 uploadBox.style.display = 'none';
             }
         };
     
     </script>
</asp:Content>
