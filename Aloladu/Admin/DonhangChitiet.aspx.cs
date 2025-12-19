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
    public partial class DonhangChitiet : System.Web.UI.Page
    {
        private readonly string connStr =
           ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private int OrderId
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
                if (OrderId <= 0)
                {
                    Response.Redirect("Donhang.aspx");
                }

                LoadOrder();
            }
        }

        private void LoadOrder()
        {
            const string sql = @"
                SELECT 
                  Order_ID, Order_Time, Status, Order_Cus, Order_Prod, Order_Address,
                  Order_Rec, Order_Phone, Order_Unit, Order_Quan, Order_Toltal, Order_Note
                FROM vw_Orders_Customers
                WHERE Order_ID = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", OrderId);
                conn.Open();

                using (var rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        ShowMsg("Không tìm thấy đơn hàng.", "red");
                        DisableActions();
                        return;
                    }

                    txtOrderId.Text = rd["Order_ID"].ToString();
                    txtCustomer.Text = rd["Order_Cus"]?.ToString();
                    txtProduct.Text = rd["Order_Prod"]?.ToString();
                    txtAddress.Text = rd["Order_Address"]?.ToString();
                    txtReceiver.Text = rd["Order_Rec"]?.ToString();
                    txtPhone.Text = rd["Order_Phone"]?.ToString();
                    txtQuantity.Text = rd["Order_Quan"]?.ToString();

                    if (rd["Order_Time"] != DBNull.Value)
                    {
                        var t = Convert.ToDateTime(rd["Order_Time"]);
                        txtTime.Text = t.ToString("HH:mm:ss dd/MM/yyyy");
                    }

                    string status = rd["Status"]?.ToString() ?? "";
                    if (ddlStatus.Items.FindByValue(status) != null)
                        ddlStatus.SelectedValue = status;

                    txtNote.Text = rd["Order_Note"]?.ToString();

                    txtUnit.Text = FormatMoney(rd["Order_Unit"]);
                    txtTotal.Text = FormatMoney(rd["Order_Toltal"]);
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
            Response.Redirect("Donhang.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (OrderId <= 0) { ShowMsg("Mã đơn không hợp lệ.", "red"); return; }

            // Giả sử Orders có cột Note (vì bạn đã thêm Order_Note vào view)
            const string sql = @"UPDATE Orders SET Status = @st, Note = @note WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@st", ddlStatus.SelectedValue);
                cmd.Parameters.AddWithValue("@note", (txtNote.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@id", OrderId);

                conn.Open();
                int n = cmd.ExecuteNonQuery();
                if (n <= 0)
                {
                    ShowMsg("Cập nhật thất bại (không tìm thấy đơn).","red");
                    return;
                }
            }

            LoadOrder();
            ShowMsg("Cập nhật thành công!", "green");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (OrderId <= 0) { ShowMsg("Mã đơn không hợp lệ.", "red"); return; }

            const string sql = @"DELETE FROM Orders WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", OrderId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("Donhang.aspx");
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