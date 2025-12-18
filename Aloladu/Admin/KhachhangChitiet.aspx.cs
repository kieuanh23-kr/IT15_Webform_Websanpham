using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Admin
{
    public partial class KhachhangChitiet : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private int CustomerID
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
                LoadCustomer();
            }
        }

        private void LoadCustomer()
        {
            if (CustomerID <= 0)
            {
                btnUpdate.Text = "Thêm mới";
                btnDelete.Visible = false;
                RecTitle.InnerText = "KHÁCH HÀNG > THÊM MỚI";
                return;
            }
            const string sql = @"
                SELECT 
                  Cus_ID, Cus_Name, Cus_Phone, Cus_CCCD, Cus_Gender, Cus_Mail, Cus_Create, Cus_Address, Cus_Order_Quan, Cus_Total, Cus_Birth
                FROM vw_Customers
                WHERE Cus_ID = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", CustomerID);
                conn.Open();

                using (var rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        ShowMsg("Không tìm thấy khách hàng nào.", "red");
                        DisableActions();
                        return;
                    }

                    txtCusID.Text = rd["Cus_ID"].ToString();
                    txtCusName.Text = rd["Cus_Name"]?.ToString();
                    txtCusPhone.Text = rd["Cus_Phone"]?.ToString();
                    txtCusCCCD.Text = rd["Cus_CCCD"]?.ToString();
                   
                    txtCusMail.Text = rd["Cus_Mail"]?.ToString();
                    txtCusAddress.Text = rd["Cus_Address"]?.ToString();
                    txtCusQuan.Text = rd["Cus_Order_Quan"]?.ToString();

                    string CusGender = rd["Cus_Gender"]?.ToString() ?? "";
                    if (ddlCusGender.Items.FindByValue(CusGender) != null)
                        ddlCusGender.SelectedValue = CusGender;

                    if (rd["Cus_Create"] != DBNull.Value)
                    {
                        var t = Convert.ToDateTime(rd["Cus_Create"]);
                        txtCusCreate.Text = t.ToString("HH:mm:ss dd/MM/yyyy");
                    }
                    if (rd["Cus_Birth"] != DBNull.Value)
                    {
                        var t = Convert.ToDateTime(rd["Cus_Birth"]);
                        txtCusBirth.Text = t.ToString("yyyy-MM-dd");
                    }

                    txtCusTotal.Text = FormatMoney(rd["Cus_Total"]);
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
            Response.Redirect("Khachhang.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            DateTime CusBirth;
            if (!DateTime.TryParse(txtCusBirth.Text, out CusBirth))
            {
                lblMsg.Text = "Ngày hạn nộp không hợp lệ. Vui lòng nhập đúng định dạng ngày.";
                lblMsg.Visible = true;
                return;
            }

            if (CustomerID <= 0)
            {

                const string sqlInsert = @"INSERT INTO Customers (FullName, Email, Phone, Address, CCCD, Gender, BirthDate)
                                        VALUES ( @Cus_Name, @Cus_Mail, @Cus_Phone, @Cus_Address, @Cus_CCCD, @Cus_Gender, @Cus_Birth)";

                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand(sqlInsert, conn))
                {
                    cmd.Parameters.AddWithValue("@Cus_Name", (txtCusName.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Cus_Mail", (txtCusMail.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Cus_Phone", (txtCusPhone.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Cus_Address", (txtCusAddress.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Cus_CCCD", (txtCusCCCD.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Cus_Gender", ddlCusGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@Cus_Birth", CusBirth);

                    conn.Open();
                    int n = cmd.ExecuteNonQuery();
                    if (n <= 0)
                    {
                        ShowMsg("Thêm tin khách hàng thất bại", "red");
                        return;
                    }
                    else
                    {
                        ShowMsg("Thêm tin khách hàng thành công!", "green");
                    }
                }
                return;
            }

            const string sql = @"UPDATE Customers 
                                        SET  FullName=@Cus_Name, Email=@Cus_Mail, Phone=@Cus_Phone, Address=@Cus_Address, CCCD=@Cus_CCCD, Gender=@Cus_Gender, BirthDate=@Cus_Birth 
                                        WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Cus_Name", (txtCusName.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Cus_Mail", (txtCusMail.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Cus_Phone", (txtCusPhone.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Cus_Address", (txtCusAddress.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Cus_CCCD", (txtCusCCCD.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Cus_Gender", ddlCusGender.SelectedValue);
                cmd.Parameters.AddWithValue("@Cus_Birth", CusBirth);
                cmd.Parameters.AddWithValue("@id", CustomerID);

                conn.Open();
                int n = cmd.ExecuteNonQuery();
                if (n <= 0)
                {
                    ShowMsg("Cập nhật thất bại (không tìm thấy khách hàng).", "red");
                    return;
                }
            }

            LoadCustomer();
            ShowMsg("Cập nhật thành công!", "green");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (CustomerID <= 0) { ShowMsg("Mã khách hàng không hợp lệ.", "red"); return; }

            const string sql = @"DELETE FROM Customers WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", CustomerID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("Khachhang.aspx");
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