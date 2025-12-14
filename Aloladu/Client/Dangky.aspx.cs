using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Client
{
    public partial class Dangky : System.Web.UI.Page
    {
        private readonly string connStr =
             ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtName.Text = "";
            txtPhone.Text = "";
            txtCCCD.Text = "";
            txtEmail.Text = "";
            txtBirth.Text = "";
            ddlGender.SelectedIndex = 0;
            txtAddress.Text = "";
            lblMsg.Text = "";
            lblMsg.CssClass = "msg err";
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            lblMsg.Text = "";
            lblMsg.CssClass = "msg err";

            string name = (txtName.Text ?? "").Trim();
            string phone = (txtPhone.Text ?? "").Trim();
            string cccd = (txtCCCD.Text ?? "").Trim();
            string email = (txtEmail.Text ?? "").Trim();
            string gender = ddlGender.SelectedValue;
            string address = (txtAddress.Text ?? "").Trim();

            // Validate cơ bản
            if (string.IsNullOrWhiteSpace(name) ||
                string.IsNullOrWhiteSpace(phone) ||
                string.IsNullOrWhiteSpace(cccd))
            {
                lblMsg.Text = "Vui lòng nhập Họ tên, SĐT và CCCD.";
                return;
            }

            // Chỉ cho số (bạn có thể nới lỏng tùy ý)
            if (!Regex.IsMatch(phone, @"^\d{8,15}$"))
            {
                lblMsg.Text = "SĐT không hợp lệ (chỉ số, 8-15 ký tự).";
                return;
            }
            if (!Regex.IsMatch(cccd, @"^\d{9,15}$"))
            {
                lblMsg.Text = "CCCD không hợp lệ (chỉ số, 9-15 ký tự).";
                return;
            }

            DateTime? birth = null;
            if (!string.IsNullOrWhiteSpace(txtBirth.Text))
            {
                DateTime d;
                if (DateTime.TryParse(txtBirth.Text, out d))
                    birth = d.Date;
                else
                {
                    lblMsg.Text = "Ngày sinh không hợp lệ.";
                    return;
                }
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check trùng CCCD / Phone trước (để báo lỗi thân thiện)
                    using (SqlCommand check = new SqlCommand(@"
                            SELECT
                              (SELECT COUNT(1) FROM Customers WHERE CCCD = @cccd) AS CccdCount,
                              (SELECT COUNT(1) FROM Customers WHERE Phone = @phone) AS PhoneCount;", conn))
                    {
                        check.Parameters.AddWithValue("@cccd", cccd);
                        check.Parameters.AddWithValue("@phone", phone);

                        using (SqlDataReader rd = check.ExecuteReader())
                        {
                            rd.Read();

                            int cccdCount = Convert.ToInt32(rd["CccdCount"]);
                            int phoneCount = Convert.ToInt32(rd["PhoneCount"]);

                            if (cccdCount > 0) { lblMsg.Text = "CCCD đã tồn tại."; return; }
                            if (phoneCount > 0) { lblMsg.Text = "SĐT đã tồn tại."; return; }
                        }
                    }


                    // Insert
                    using (SqlCommand cmd = new SqlCommand(@"
                                    INSERT INTO Customers(FullName, Email, Phone, Address, CCCD, Gender, BirthDate)
                                    VALUES (@name, @email, @phone, @addr, @cccd, @gender, @birth);

                                    SELECT SCOPE_IDENTITY();", conn))
                    {
                        cmd.Parameters.AddWithValue("@name", name);
                        cmd.Parameters.AddWithValue("@email", (object)email ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@phone", phone);
                        cmd.Parameters.AddWithValue("@addr", (object)address ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@cccd", cccd);
                        cmd.Parameters.AddWithValue("@gender", (object)gender ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@birth", (object)birth ?? DBNull.Value);

                        int newId = Convert.ToInt32(cmd.ExecuteScalar());

                        // Lưu session đăng nhập luôn (vì bạn dùng CCCD/SĐT làm login)
                        Session["CustomerId"] = newId;
                        Session["CustomerName"] = name;
                        Session["CustomerPhone"] = phone;
                        Session["CustomerCCCD"] = cccd;

                        lblMsg.CssClass = "msg ok";
                        lblMsg.Text = "Đăng ký thành công!";

                        // tùy bạn: chuyển về trang sản phẩm / đặt hàng
                        // Response.Redirect("Sanpham.aspx");
                    }
                }
            }
            catch (SqlException ex)
            {
                // Nếu vẫn trùng do UNIQUE index (race condition)
                if (ex.Number == 2601 || ex.Number == 2627)
                {
                    lblMsg.Text = "SĐT hoặc CCCD đã tồn tại. Vui lòng nhập lại.";
                    return;
                }
                lblMsg.Text = "Có lỗi khi đăng ký. Vui lòng thử lại.";
            }
        }
        protected void btnGoLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dangnhap.aspx");
        }
    }
}