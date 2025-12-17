using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Admin
{
    public partial class Donhang : System.Web.UI.Page
    {
        private readonly string connStr =
             ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindOrders();
                gvOrders.HeaderRow.TableSection = TableRowSection.TableHeader;

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindOrders();
        }

        private void BindOrders()
        {
            lblMsg.Visible = false;

            string keyword = (txtKeyword.Text ?? "").Trim();
            string field = (ddlField.SelectedValue ?? "").Trim();

            // chỉ cho phép 4 field hợp lệ
            string safeField = GetSafeField(field);

            string sql =
                @"SELECT Order_ID, Order_Time, Status, Order_Prod, Order_Cus, Order_Address
                  FROM vw_Orders_Customers
                  WHERE (1=1) ";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = conn;

                // nếu keyword trống -> show all (không thêm điều kiện)
                if (!string.IsNullOrEmpty(keyword))
                {
                    sql += $" AND {safeField} LIKE @kw ";
                    cmd.Parameters.AddWithValue("@kw", "%" + keyword + "%");
                }

                sql += " ORDER BY Order_Time DESC ";
                cmd.CommandText = sql;

                var dt = new DataTable();
                using (var da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }

                gvOrders.DataSource = dt;
                gvOrders.DataBind();
            }
            switch(gvOrders.Rows.Count)
            {
                case 0:
                    lblMsg.Text = "Không tìm thấy đơn hàng nào.";
                    lblMsg.Visible = true;
                    break;
            }
            
        }

        private string GetSafeField(string field)
        {
            switch (field)
            {
                case "Order_Cus": return "Order_Cus";           // Tên khách hàng
                case "Order_Prod": return "Order_Prod";         // Tên sản phẩm
                case "Order_Address": return "Order_Address";   // Địa chỉ
                case "Status": return "Status";                 // Trạng thái đơn
                default: return "Order_Cus";
            }
        }


        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            var ids = new List<int>();

            foreach (GridViewRow row in gvOrders.Rows)
            {
                var ck = row.FindControl("ckRow") as CheckBox;
                if (ck != null && ck.Checked)
                {
                    int id = Convert.ToInt32(gvOrders.DataKeys[row.RowIndex].Value);
                    ids.Add(id);
                }
            }

            if (ids.Count == 0)
            {
                lblMsg.Text = "Bạn chưa chọn đơn hàng nào để xóa.";
                lblMsg.Visible = true;
                return;
            }

            // XÓA trong bảng Orders (không xóa từ view)
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (var tran = conn.BeginTransaction())
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.Transaction = tran;

                    // Build IN (@p0,@p1,...)
                    var ps = new List<string>();
                    for (int i = 0; i < ids.Count; i++)
                    {
                        string p = "@p" + i;
                        ps.Add(p);
                        cmd.Parameters.AddWithValue(p, ids[i]);
                    }

                    cmd.CommandText = $"DELETE FROM Orders WHERE Id IN ({string.Join(",", ps)})";

                    try
                    {
                        cmd.ExecuteNonQuery();
                        tran.Commit();
                    }
                    catch
                    {
                        tran.Rollback();
                        lblMsg.Text = "Xóa thất bại. Vui lòng kiểm tra ràng buộc dữ liệu.";
                        lblMsg.Visible = true;
                        return;
                    }
                }
            }

            BindOrders();
        }
        protected string GetStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status))
                return "badge bg-secondary px-3 py-2 rounded-pill";

            switch (status.Trim().ToLower())
            {
                case "chờ xử lý":
                    return "badge bg-warning text-dark px-3 py-2 rounded-pill";

                case "chuẩn bị giao":
                    return "badge bg-info px-3 py-2 rounded-pill";

                case "đang giao":
                    return "badge bg-success px-3 py-2 rounded-pill";

                case "hoàn thành":
                    return "badge bg-danger px-3 py-2 rounded-pill";

                default:
                    return "badge bg-secondary px-3 py-2 rounded-pill";
            }
        }
    }
}