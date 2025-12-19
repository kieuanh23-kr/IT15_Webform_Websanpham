using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Net.Mime.MediaTypeNames;

namespace Aloladu.Admin
{
    public partial class SanphamChitiet : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private int ProcId
        {
            get
            {
                int.TryParse(Request.QueryString["id"], out int id);
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["ADMIN_USER"] == null)
            {
                Response.Redirect("Dangnhap.aspx");
            }
            if (!IsPostBack)
            {
                LoadProducts();
            }
        }

        private void LoadProducts()
        {
            
            if(ProcId <= 0)
            {
                btnUpdate.Text = "Thêm mới";
                btnDelete.Visible= false;
                ProcTitle.InnerText = "SẢN PHẨM > THÊM MỚI";
                return;
            }
            if (ProcId > 0)
            {
                btnUpdate.Text = "Cập nhật";
                btnDelete.Visible =true;
                const string sql = @"
                    SELECT 
                      Proc_ID,Proc_Name, Proc_Cat, Proc_Brand, Proc_Price, Proc_Quan, Proc_OldPrice,Proc_Image,Proc_Total,Proc_Des
                    FROM vw_Products
                    WHERE Proc_ID = @id";

                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@id", ProcId);
                    conn.Open();

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                        {
                            ShowMsg("Không tìm thấy sản phẩm.", "red");
                            DisableActions();
                            return;
                        }

                        txtProcID.Text = rd["Proc_ID"].ToString();
                        txtProcName.Text = rd["Proc_Name"]?.ToString();
                        txtProcQuan.Text = rd["Proc_Quan"]?.ToString();
                        txtDes.Text = rd["Proc_Des"]?.ToString();


                        string ProcCat = rd["Proc_Cat"]?.ToString() ?? "";
                        if (ddlProcCat.Items.FindByValue(ProcCat) != null)
                            ddlProcCat.SelectedValue = ProcCat;

                        string ProcBrand = rd["Proc_Brand"]?.ToString() ?? "";
                        if (ddlProcBrand.Items.FindByValue(ProcBrand) != null)
                            ddlProcBrand.SelectedValue = ProcBrand;

                        string imageUrl = rd["Proc_Image"]?.ToString();
                        if (!string.IsNullOrEmpty(imageUrl))
                        {
                            hdnImageUrl.Value = imageUrl;
                        }

                        txtProcOldPrice.Text = FormatMoney(rd["Proc_OldPrice"]);
                        txtProcPrice.Text = FormatMoney(rd["Proc_Price"]);
                        txtTotal.Text = FormatMoney(rd["Proc_Total"]);
                    }
                }
            }
        }

        private string FormatMoney(object value)
        {
            if (value == null || value == DBNull.Value) return "";
            if (!decimal.TryParse(value.ToString(), out decimal d)) return value.ToString();
            // format kiểu 1.500.000
            return d.ToString("#,0", new CultureInfo("vi-VN"));
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Sanpham.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;
            string imageUrl = hdnImageUrl.Value; // Keep existing image
            if (string.IsNullOrEmpty(hdnImageUrl.Value) && ProcId > 0)
            {
                imageUrl = null; // Will update to NULL in database
            }
            if (fuProcImage.HasFile)
            {
                try
                {
                    string fileName = Path.GetFileName(fuProcImage.FileName);
                    string extension = Path.GetExtension(fileName).ToLower();

                    // Validate file extension
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp" };
                    if (!allowedExtensions.Contains(extension))
                    {
                        ShowMsg("Chỉ chấp nhận file ảnh (jpg, jpeg, png, gif, bmp).", "red");
                        return;
                    }

                    // Generate unique filename
                    string uniqueFileName = DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + fileName;
                    string imagePath = Server.MapPath("~/Images/");

                    // Create Images folder if not exists
                    if (!Directory.Exists(imagePath))
                    {
                        Directory.CreateDirectory(imagePath);
                    }

                    string fullPath = Path.Combine(imagePath, uniqueFileName);
                    fuProcImage.SaveAs(fullPath);

                    imageUrl = uniqueFileName;
                }
                catch (Exception ex)
                {
                    ShowMsg("Lỗi khi tải ảnh lên: " + ex.Message, "red");
                    return;
                }
            }

            if (ProcId <= 0) {
                const string sqlInsert = @"INSERT INTO  Products (Name,OldPrice,Price,BrandName,CategoryKey,Description,ImageUrl)
                                            VALUES (@Name,@OldPrice,@Price,@BrandName,@CategoryKey,@Des,@ImageUrl)";

                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand(sqlInsert, conn))
                {
                    cmd.Parameters.AddWithValue("@BrandName", ddlProcBrand.SelectedValue);
                    cmd.Parameters.AddWithValue("@CategoryKey", ddlProcCat.SelectedValue);
                    cmd.Parameters.AddWithValue("@Name", (txtProcName.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@OldPrice", (txtProcOldPrice.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Price", (txtProcPrice.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Des", (txtDes.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@ImageUrl", string.IsNullOrEmpty(imageUrl) ? (object)DBNull.Value : imageUrl);

                    conn.Open();
                    int n = cmd.ExecuteNonQuery();
                    if (n <= 0)
                    {
                        ShowMsg("Thêm mới thất bại.", "red");
                        return;
                    }
                    else
                    {
                        ShowMsg("Thêm mới thành công!", "green");
             
                    }
                }
                return; 
            }

            // Cập nhật sản phẩm
            const string sql = @"UPDATE Products SET Name=@Name,OldPrice=@OldPrice,Price=@Price,
                                                    BrandName=@BrandName,CategoryKey=@CategoryKey,Description=@Des, ImageUrl=@ImageUrl 
                                 WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@BrandName", ddlProcBrand.SelectedValue);
                cmd.Parameters.AddWithValue("@CategoryKey", ddlProcCat.SelectedValue);
                cmd.Parameters.AddWithValue("@Name", (txtProcName.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@OldPrice", RemoveMoneyFormat(txtProcOldPrice.Text));
                cmd.Parameters.AddWithValue("@Price", RemoveMoneyFormat(txtProcPrice.Text));
                cmd.Parameters.AddWithValue("@Des", (txtDes.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@ImageUrl", string.IsNullOrEmpty(imageUrl) ? (object)DBNull.Value : imageUrl);
                cmd.Parameters.AddWithValue("@id", ProcId);

                conn.Open();
                int n = cmd.ExecuteNonQuery();
                if (n <= 0)
                {
                    ShowMsg("Cập nhật thất bại (không tìm thấy sản phẩm).", "red");
                    return;
                }
            }

            LoadProducts();
            ShowMsg("Cập nhật thành công!", "green");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (ProcId <= 0) { ShowMsg("Mã sản phẩm không hợp lệ.", "red"); return; }
            // Get image URL before deleting
            string imageUrl = "";
            const string sqlGetImage = @"SELECT ImageUrl FROM Products WHERE Id = @id";
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sqlGetImage, conn))
            {
                cmd.Parameters.AddWithValue("@id", ProcId);
                conn.Open();
                var result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    imageUrl = result.ToString();
                }
            }

            const string sql = @"DELETE FROM Products WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", ProcId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            // Delete image file if exists
            if (!string.IsNullOrEmpty(imageUrl))
            {
                try
                {
                    string imagePath = Server.MapPath("~/Images/" + imageUrl);
                    if (File.Exists(imagePath))
                    {
                        File.Delete(imagePath);
                    }
                }
                catch { lblMsg.Text = "Không tìm thấy ảnh xóa"; }
            }

            Response.Redirect("Sanpham.aspx");
        }

        private string RemoveMoneyFormat(string value)
        {
            if (string.IsNullOrWhiteSpace(value)) return "0";
            // Xóa dấu chấm phân cách hàng nghìn
            return value.Replace(".", "").Trim();
        }

        private void ShowMsg(string msg, string color)
        {
            lblMsg.Text = msg;
            lblMsg.Visible = true;
            lblMsg.ForeColor = Color.FromName(color);
        }

        private void DisableActions()
        {
            btnUpdate.Enabled = false;
            btnDelete.Enabled = false;
        }
    }
}