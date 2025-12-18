<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.Master" AutoEventWireup="true" CodeBehind="SanphamChitiet.aspx.cs" Inherits="Aloladu.Admin.SanphamChitiet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <style>
        .pr-title{
            font-size: 34px;
            font-weight: 900;
            color: #0b0bbf;
            margin-bottom: 18px;
            letter-spacing: .3px;
        }

        .pr-grid{
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 48px;
            max-width: 1800px;
        }

        .pr-field{ width: 100%; }

        .pr-span2{ grid-column: span 2; }

        .pr-label{
            font-weight: 800;
            margin-bottom: 8px;
        }

        .pr-input{
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #0b0bbf;
            border-radius: 4px;
            font-weight: 600;
            background: #fff;
        }

        /* Disabled fields giống hình (xám) */
        .pr-input:disabled,
        .pr-input[disabled]{
            background: #e9e9e9;
            color: #222;
            opacity: 1;
        }

        /* dropdown có dấu > bên phải */
        .pr-select-wrap{ position: relative; }
        .pr-select{ appearance: none; padding-right: 36px; }
        .pr-arrow{
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: 900;
            color: #222;
            pointer-events: none;
        }

        .pr-note{ resize: none; }

        .pr-actions{
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
        .pr-image-section {
            display: flex;
            align-items: flex-start;
            gap: 20px;
        }

        .pr-upload-box {
            width: 150px;
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

        .pr-upload-box:hover {
            background: #f0f0ff;
            border-color: #0808aa;
        }

        .pr-upload-icon {
            font-size: 48px;
            color: #0b0bbf;
            font-weight: 300;
        }

        .pr-image-preview {
            position: relative;
            display: none;
        }

        .pr-image-preview.show {
            display: block;
        }

        .pr-preview-img {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 4px;
            border: 2px solid #0b0bbf;
        }

        .pr-image-name {
            margin-top: 8px;
            font-size: 12px;
            color: #666;
            text-align: center;
            word-break: break-all;
        }

        .pr-close-btn {
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

        .pr-close-btn:hover {
            background: #333;
        }

        .pr-upload-hint {
            color: #666;
            font-size: 13px;
            margin-top: 8px;
        }

        .pr-actions{
            margin-top: 22px;
            display: flex;
            gap: 16px;
            justify-content: right;
        }
        
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pr-title" runat="server" id="ProcTitle">SẢN PHẨM &gt; CHI TIẾT ĐƠN HÀNG</div>


    <div class="pr-grid">
        <!-- Row 1 -->
        <div class="pr-field">
            <div class="pr-label">Mã sản phẩm</div>
            <asp:TextBox ID="txtProcID" runat="server" CssClass="pr-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="pr-field">
            <div class="pr-label">Tên sản phẩm</div>
            <asp:TextBox ID="txtProcName" runat="server" CssClass="pr-input" Enabled="true"></asp:TextBox>
        </div>

        <!-- Row 2 -->
        <div class="pr-field">
            <div class="pr-label">Phân loại</div>
            <div class="pr-select-wrap">
                <asp:DropDownList ID="ddlProcCat" runat="server" CssClass="pr-input pr-select">
                    <asp:ListItem Text="Đồ bếp" Value="dobep" />
                    <asp:ListItem Text="Dọn nhà" Value="donha" />
                    <asp:ListItem Text="Sấy khô" Value="saykho" />
                    <asp:ListItem Text="Đồng hồ" Value="dongho" />
                    <asp:ListItem Text="Bóng đèn" Value="bongden" />
                    <asp:ListItem Text="Giặt là" Value="giatla" />
                </asp:DropDownList>
                <span class="pr-arrow">&gt;</span>
            </div>
        </div>
        <div class="pr-field">
            <div class="pr-label">Hãng sản xuất</div>
            <div class="pr-select-wrap">
                <asp:DropDownList ID="ddlProcBrand" runat="server" CssClass="pr-input pr-select">
                    <asp:ListItem Text="Sunhouse" Value="Sunhouse" />
                    <asp:ListItem Text="Lock&Lock" Value="Lock&Lock" />
                    <asp:ListItem Text="Panasonic" Value="Panasonic" />
                </asp:DropDownList>
                <span class="pr-arrow">&gt;</span>
            </div>
        </div>

        <!-- Row 3 -->
        <div class="pr-field">
            <div class="pr-label">Giá gốc</div>
            <asp:TextBox ID="txtProcOldPrice" runat="server" CssClass="pr-input" Enabled="true"></asp:TextBox>
        </div>
        <div class="pr-field">
            <div class="pr-label">Giá bán</div>
            <asp:TextBox ID="txtProcPrice" runat="server" CssClass="pr-input" Enabled="true"></asp:TextBox>
        </div>

        <!-- Row 4 -->
        <div class="pr-field">
            <div class="pr-label">Lượng bán</div>
            <asp:TextBox ID="txtProcQuan" runat="server" CssClass="pr-input" Enabled="false"></asp:TextBox>
        </div>
        <div class="pr-field">
            <div class="pr-label">Doanh thu</div>
            <asp:TextBox ID="txtTotal" runat="server" CssClass="pr-input" Enabled="false"></asp:TextBox>
        </div>
        <!-- Row 5 (full) -->
        <div class="pr-field pr-span2">
            <div class="pr-label">Ghi chú</div>
            <asp:TextBox ID="txtDes" runat="server" CssClass="pr-input" Enabled="true"></asp:TextBox>
        </div>
        <!-- Row 6: Image Upload -->
        <div class="pr-field pr-span2">
            <div class="pr-label">Ảnh sản phẩm</div>
            <div class="pr-image-section">
                <div class="pr-upload-box" id="uploadBox" onclick="document.getElementById('<%=fuProcImage.ClientID%>').click();">
                    <div class="pr-upload-icon">+</div>
                </div>
                
                <div class="pr-image-preview" id="imagePreview">
                    <asp:Image ID="imgPreview" runat="server" CssClass="pr-preview-img" />
                    <button type="button" class="pr-close-btn" onclick="removeImage()">×</button>
                    <div class="pr-image-name" id="imageName"></div>
                </div>

                <asp:FileUpload ID="fuProcImage" runat="server" style="display:none;" accept="image/*" onchange="previewImage(this);" />
                <asp:HiddenField ID="hdnImageUrl" runat="server" />
            </div>
            <div class="pr-upload-hint">Lưu ý: Chọn ảnh có kích tỷ lệ 1:1</div>
        </div>
    </div>



    <div class="pr-actions">
        <asp:Label ID="lblMsg" runat="server" CssClass="fw-semibold d-block mb-3" Visible="false"></asp:Label>
        <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-outline-primary" OnClick="btnBack_Click">
            Thoát
        </asp:LinkButton>

        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-dark"
            OnClientClick="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?');"
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
                imgElement.src = '../Images/' + hdnImageUrl.value;
                nameElement.textContent = hdnImageUrl.value;
                preview.classList.add('show');
                uploadBox.style.display = 'none';
            }
        };
        
    </script>
</asp:Content>