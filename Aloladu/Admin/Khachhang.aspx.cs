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
    public partial class Khachhang : System.Web.UI.Page
    {
        private readonly string connStr =
               ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["ADMIN_USER"] == null)
            {
                Response.Redirect("Dangnhap.aspx");
            }

            if (!IsPostBack)
            {
                BindCustomers();
                if (gvCus.HeaderRow != null)
                {
                    gvCus.HeaderRow.TableSection = TableRowSection.TableHeader;
                }

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindCustomers();
        }
        private string GetSafeField(string field)
        {
            switch (field)
            {
                case "Cus_Name": return "Cus_Name";         
                case "Cus_Phone": return "Cus_Phone";        
                case "Cus_ID": return "Cus_ID";
                case "Cus_Address": return "Cus_Address";
                default: return "Cus_Name";
            }
        }

        private void BindCustomers()
        {
            lblMsg.Visible = false;

            string keyword = (txtKeyword.Text ?? "").Trim();
            string field = (ddlField.SelectedValue ?? "").Trim();
            string safeField = GetSafeField(field);

            string sql =
                @"SELECT Cus_ID, Cus_Name, Cus_Phone, Cus_CCCD, Cus_Gender, Cus_Mail, Cus_Create, Cus_Address, Cus_Order_Quan, Cus_Total
                  FROM vw_Customers
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

                sql += " ORDER BY Cus_Create DESC ";
                cmd.CommandText = sql;

                var dt = new DataTable();
                using (var da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }

                gvCus.DataSource = dt;
                gvCus.DataBind();
            }
            switch (gvCus.Rows.Count)
            {
                case 0:
                    lblMsg.Text = "Không tìm thấy khách hàng nào.";
                    lblMsg.Visible = true;
                    break;
            }

        }


        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            var ids = new List<int>();

            foreach (GridViewRow row in gvCus.Rows)
            {
                var ck = row.FindControl("ckRow") as CheckBox;
                if (ck != null && ck.Checked)
                {
                    int id = Convert.ToInt32(gvCus.DataKeys[row.RowIndex].Value);
                    ids.Add(id);
                }
            }

            if (ids.Count == 0)
            {
                lblMsg.Text = "Bạn chưa chọn khách hàng nào để xóa.";
                lblMsg.Visible = true;
                return;
            }

            // XÓA trong bảng Customers 
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

                    cmd.CommandText = $"DELETE FROM Customers WHERE Id IN ({string.Join(",", ps)})";

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

            BindCustomers();
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            Response.Redirect("KhachhangChitiet.aspx");
        }
    }
}