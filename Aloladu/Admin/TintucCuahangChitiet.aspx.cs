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

namespace Aloladu.Admin
{
    public partial class TintucCuahangChitiet : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private int NestId
        {
            get
            {
                int.TryParse(Request.QueryString["id"], out int id);
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadNews();
            }
        }

        private void LoadNews()
        {

            if (NestId <= 0)
            {
                btnUpdate.Text = "Thêm mới";
                btnDelete.Visible = false;
                ProcTitle.InnerText = "TIN TỨC > CỬA HÀNG > THÊM MỚI";
                return;
            }
            if (NestId > 0)
            {
                btnUpdate.Text = "Cập nhật";
                btnDelete.Visible = true;
                const string sql = @"
                    SELECT 
                      Nest_ID,Nest_Time, Nest_Featured, Nest_Title, Nest_Cont, Nest_Ima
                    FROM vw_News_Store
                    WHERE Nest_ID = @id";

                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@id", NestId);
                    conn.Open();

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                        {
                            ShowMsg("Không tìm thấy tin tức.", "red");
                            DisableActions();
                            return;
                        }

                        txtNewsTitle.Text = rd["Nest_Title"].ToString();
                        txtNewsCont.Text = rd["Nest_Cont"]?.ToString();

                        if (rd["Nest_Time"] != DBNull.Value)
                        {
                            var t = Convert.ToDateTime(rd["Nest_Time"]);
                            txtNewsTime.Text = t.ToString("HH:mm:ss dd/MM/yyyy");
                        }
                        if (Convert.ToBoolean(rd["Nest_Featured"]))
                        {
                            rbYes.Checked = true;
                        }
                        else { rbNo.Checked = true; }

                        string imageUrl = rd["Nest_Ima"]?.ToString();
                        if (!string.IsNullOrEmpty(imageUrl))
                        {
                            hdnImageUrl.Value = imageUrl;
                        }
                    }
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("TintucCuahang.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;
            string imageUrl = hdnImageUrl.Value; // Keep existing image
            if (string.IsNullOrEmpty(hdnImageUrl.Value) && NestId > 0)
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
                    string imagePath = Server.MapPath("~/Images_News/");

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

            if (NestId <= 0)
            {
                const string sqlInsert = @"INSERT INTO  News ( Title, Content, Category, ImageUrl, IsFeatured)
                                            VALUES (@Nest_Title, @Nest_Cont, 'cua-hang', @Nest_Ima,@Nest_Featured)
                                            SELECT SCOPE_IDENTITY();";

                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand(sqlInsert, conn))
                {
                    cmd.Parameters.AddWithValue("@Nest_Title", (txtNewsTitle.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Nest_Cont", (txtNewsCont.Text ?? "").Trim());
                    if(rbYes.Checked)
                    {
                        cmd.Parameters.AddWithValue("@Nest_Featured", 1);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Nest_Featured", 0);
                    }  
                    cmd.Parameters.AddWithValue("@Nest_Ima", string.IsNullOrEmpty(imageUrl) ? (object)DBNull.Value : imageUrl);

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    int n = Convert.ToInt32(result);
                    if (n > 0)
                    {
                        ShowMsg("Thêm mới thành công!", "green");
                        Response.Redirect("TintucCuahangChitiet.aspx?id=" + n);
                        return;
                    }
                    else
                    {
                        ShowMsg("Thêm mới thất bại.", "red");
                    }
                }
                return;
            }

            // Cập nhật sản phẩm
            const string sql = @"UPDATE News SET Title=@Nest_Title, Content=@Nest_Cont, ImageUrl=@Nest_Ima,IsFeatured=@Nest_Featured
                                 WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Nest_Title", (txtNewsTitle.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Nest_Cont", (txtNewsCont.Text ?? "").Trim());
                if (rbYes.Checked)
                {
                    cmd.Parameters.AddWithValue("@Nest_Featured", 1);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Nest_Featured", 0);
                }
                cmd.Parameters.AddWithValue("@Nest_Ima", string.IsNullOrEmpty(imageUrl) ? (object)DBNull.Value : imageUrl);
                cmd.Parameters.AddWithValue("@id", NestId);

                conn.Open();
                int n = cmd.ExecuteNonQuery();
                if (n <= 0)
                {
                    ShowMsg("Cập nhật thất bại (không tìm thấy tin tức).", "red");
                    return;
                }
            }

            LoadNews();
            ShowMsg("Cập nhật thành công!", "green");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (NestId <= 0) { ShowMsg("Mã tin tức không hợp lệ.", "red"); return; }
            // Get image URL before deleting
            string imageUrl = "";
            const string sqlGetImage = @"SELECT ImageUrl FROM News WHERE Id = @id";
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sqlGetImage, conn))
            {
                cmd.Parameters.AddWithValue("@id", NestId);
                conn.Open();
                var result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    imageUrl = result.ToString();
                }
            }

            const string sql = @"DELETE FROM News WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", NestId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            // Delete image file if exists
            if (!string.IsNullOrEmpty(imageUrl))
            {
                try
                {
                    string imagePath = Server.MapPath("~/Images_News/" + imageUrl);
                    if (File.Exists(imagePath))
                    {
                        File.Delete(imagePath);
                    }
                }
                catch { lblMsg.Text = "Không tìm thấy ảnh xóa"; }
            }

            Response.Redirect("TintucCuahang.aspx");
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