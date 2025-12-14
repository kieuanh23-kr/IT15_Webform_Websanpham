using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Client
{
    public partial class Dangnhap : System.Web.UI.Page
    {
        private readonly string connStr =
           ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Nếu đã login thì quay về trang trước/hoặc Home
            if (!IsPostBack && Session["CustomerId"] != null)
            {
                RedirectAfterLogin();
            }
        }

        protected void btnGoRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dangky.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblMsg.Text = "";

            string cccd = (txtCCCD.Text ?? "").Trim();
            string phone = (txtPhone.Text ?? "").Trim();

            if (string.IsNullOrWhiteSpace(cccd) || string.IsNullOrWhiteSpace(phone))
            {
                lblMsg.Text = "Vui lòng nhập CCCD và SĐT.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT TOP 1 Id, FullName, CCCD, Phone
                        FROM Customers
                        WHERE CCCD = @cccd AND Phone = @phone;", conn))
                    {
                        cmd.Parameters.AddWithValue("@cccd", cccd);
                        cmd.Parameters.AddWithValue("@phone", phone);

                        using (SqlDataReader rd = cmd.ExecuteReader())
                        {
                            if (rd.Read())
                            {
                                int id = Convert.ToInt32(rd["Id"]);
                                string name = rd["FullName"]?.ToString() ?? "";

                                // ✅ Lưu session để dùng chặn Dathang/Donhang
                                Session["CustomerId"] = id;
                                Session["CustomerName"] = name;
                                Session["CustomerCCCD"] = cccd;
                                Session["CustomerPhone"] = phone;

                                RedirectAfterLogin();
                                return;
                            }
                        }
                    }
                }

                lblMsg.Text = "Sai CCCD hoặc SĐT. Vui lòng thử lại.";
            }
            catch
            {
                lblMsg.Text = "Có lỗi khi đăng nhập. Vui lòng thử lại.";
            }
        }

        private void RedirectAfterLogin()
        {
            string returnUrl = Request.QueryString["returnUrl"];
            if (!string.IsNullOrWhiteSpace(returnUrl))
            {
                Response.Redirect(returnUrl);
                return;
            }

            // Mặc định về trang Sản phẩm hoặc Home
            Response.Redirect("Sanpham.aspx");
        }
    }
}