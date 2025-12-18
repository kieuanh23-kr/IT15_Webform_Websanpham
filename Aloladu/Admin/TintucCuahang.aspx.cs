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
    public partial class TintucCuahang : System.Web.UI.Page
    {
        private readonly string connStr =
             ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
          
            if (!IsPostBack)
            {
                BindNest();
                gvNest.HeaderRow.TableSection = TableRowSection.TableHeader;

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindNest();
        }

        private void BindNest()
        {
            lblMsg.Visible = false;

            string keyword = (txtKeyword.Text ?? "").Trim();

            string sql =
                @"SELECT Nest_ID, Nest_Time, Nest_Featured, Nest_Title, Nest_Cont, Nest_Ima
                  FROM vw_News_Store
                  WHERE (1=1) ";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = conn;

                // nếu keyword trống -> show all (không thêm điều kiện)
                if (!string.IsNullOrEmpty(keyword))
                {
                    sql += $" AND Nest_Title LIKE @kw ";
                    cmd.Parameters.AddWithValue("@kw", "%" + keyword + "%");
                }

                sql += " ORDER BY Nest_Time DESC ";
                cmd.CommandText = sql;

                var dt = new DataTable();
                using (var da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }

                gvNest.DataSource = dt;
                gvNest.DataBind();
            }
            switch (gvNest.Rows.Count)
            {
                case 0:
                    lblMsg.Text = "Không tìm thấy đơn hàng nào.";
                    lblMsg.Visible = true;
                    break;
            }

        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            var ids = new List<int>();

            foreach (GridViewRow row in gvNest.Rows)
            {
                var ck = row.FindControl("ckRow") as CheckBox;
                if (ck != null && ck.Checked)
                {
                    int id = Convert.ToInt32(gvNest.DataKeys[row.RowIndex].Value);
                    ids.Add(id);
                }
            }

            if (ids.Count == 0)
            {
                lblMsg.Text = "Bạn chưa chọn tin nào để xóa.";
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

                    cmd.CommandText = $"DELETE FROM News WHERE Id IN ({string.Join(",", ps)})";

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

            BindNest();
        }
        protected string GetNestClass(string Nest_Featured)
        {
            if (string.IsNullOrEmpty(Nest_Featured))
                return "badge bg-secondary px-3 py-2 rounded-pill";

            switch (Nest_Featured.Trim())
            {
                case "True":
                    return "badge bg-warning text-dark px-3 py-2 rounded-pill";

                case "False":
                    return "badge bg-info px-3 py-2 rounded-pill";
                default:
                    return "badge bg-secondary px-3 py-2 rounded-pill";
            }
        }

        protected string GetNestText(string Nest_Featured)
        {
            if (string.IsNullOrEmpty(Nest_Featured))
                return "Không xác định";

            switch (Nest_Featured.Trim())
            {
                case "False":
                    return "Tin thường";
                case "True":
                    return "Tin nổi bật";
                default:
                    return "Không xác định";
            }
        }


        protected void btnCreate_Click(object sender, EventArgs e)
        {
            Response.Redirect("TintucCuahangChitiet.aspx");
        }
    }
}