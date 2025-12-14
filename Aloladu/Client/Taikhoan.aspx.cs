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
    public partial class Taikhoan : System.Web.UI.Page
    {
        private readonly string connStr =
           ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Bắt buộc login
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("DangNhap.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (!IsPostBack)
            {
                LoadCustomer();
            }
        }

        private void LoadCustomer()
        {
            lblMsg.Text = "";

            int customerId = Convert.ToInt32(Session["CustomerId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                        SELECT TOP 1 FullName, Phone, CCCD, Email, Address, BirthDate, Gender
                        FROM Customers
                        WHERE Id = @id;", conn))
                {
                    cmd.Parameters.AddWithValue("@id", customerId);

                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                        {
                            Session.Clear();
                            Response.Redirect("DangNhap.aspx");
                            return;
                        }

                        txtName.Text = rd["FullName"]?.ToString() ?? "";
                        txtPhone.Text = rd["Phone"]?.ToString() ?? "";
                        txtCCCD.Text = rd["CCCD"]?.ToString() ?? "";
                        txtEmail.Text = rd["Email"] == DBNull.Value ? "" : rd["Email"].ToString();
                        txtAddress.Text = rd["Address"] == DBNull.Value ? "" : rd["Address"].ToString();

                        // ✅ BirthDate -> yyyy-MM-dd cho TextMode="Date"
                        if (rd["BirthDate"] == DBNull.Value)
                        {
                            txtBirth.Text = "";
                        }
                        else
                        {
                            DateTime birth = Convert.ToDateTime(rd["BirthDate"]);
                            txtBirth.Text = birth.ToString("yyyy-MM-dd");
                        }

                        // ✅ Gender -> set selected value (nếu có trong dropdown)
                        string gender = rd["Gender"] == DBNull.Value ? "" : rd["Gender"].ToString().Trim();
                        if (!string.IsNullOrEmpty(gender) && ddlGender.Items.FindByValue(gender) != null)
                            ddlGender.SelectedValue = gender;
                        else
                            ddlGender.SelectedIndex = 0; // mặc định item đầu tiên
                    }
                }
            }
        }


        protected void btnBack_Click(object sender, EventArgs e)
        {
            // quay lại trang trước nếu có
            if (Request.UrlReferrer != null)
            {
                Response.Redirect(Request.UrlReferrer.ToString());
                return;
            }

            Response.Redirect("Sanpham.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.CssClass = "msg text-danger";
            lblMsg.Text = "";

            string name = (txtName.Text ?? "").Trim();
            string email = (txtEmail.Text ?? "").Trim();
            string address = (txtAddress.Text ?? "").Trim();
            string gender = (ddlGender.SelectedValue ?? "").Trim();
            string birthStr = (txtBirth.Text ?? "").Trim();

            if (string.IsNullOrWhiteSpace(name))
            {
                lblMsg.Text = "Họ và tên không được để trống.";
                return;
            }

            // ✅ Parse ngày sinh (cho phép bỏ trống)
            DateTime birthDate;
            bool hasBirth = DateTime.TryParse(birthStr, out birthDate);

            int customerId = Convert.ToInt32(Session["CustomerId"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(@"
                                UPDATE Customers
                                SET FullName  = @name,
                                    Email     = @email,
                                    Address   = @addr,
                                    BirthDate = @birth,
                                    Gender    = @gender
                                WHERE Id = @id;", conn))
                    {
                        cmd.Parameters.AddWithValue("@name", name);
                        cmd.Parameters.AddWithValue("@email", string.IsNullOrWhiteSpace(email) ? (object)DBNull.Value : email);
                        cmd.Parameters.AddWithValue("@addr", string.IsNullOrWhiteSpace(address) ? (object)DBNull.Value : address);
                        cmd.Parameters.AddWithValue("@gender", string.IsNullOrWhiteSpace(gender) ? (object)DBNull.Value : gender);
                        cmd.Parameters.AddWithValue("@birth", hasBirth ? (object)birthDate.Date : DBNull.Value);
                        cmd.Parameters.AddWithValue("@id", customerId);

                        cmd.ExecuteNonQuery();
                    }
                }

                Session["CustomerName"] = name;

                lblMsg.CssClass = "msg text-success";
                lblMsg.Text = "Cập nhật thông tin thành công!";
            }
            catch
            {
                lblMsg.Text = "Có lỗi khi cập nhật. Vui lòng thử lại.";
            }
        }


        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Sanpham.aspx");
        }
    }
}