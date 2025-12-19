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
    public partial class TintucTuyendung : System.Web.UI.Page
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
                BindRecs();
                if(gvRecs.HeaderRow != null)
                    gvRecs.HeaderRow.TableSection = TableRowSection.TableHeader;

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindRecs();
        }

        private void BindRecs()
        {
            lblMsg.Visible = false;

            string keyword = (txtKeyword.Text ?? "").Trim();
            
            string sql =
                @"SELECT Rec_ID, Rec_Pos, Rec_DL, Rec_Type, Rec_Time, Rec_Desc,Rec_Sal,Rec_Address,Rec_Create
                  FROM vw_News_Rec
                  WHERE (1=1) ";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = conn;

                // nếu keyword trống -> show all (không thêm điều kiện)
                if (!string.IsNullOrEmpty(keyword))
                {
                    sql += $" AND Rec_Pos LIKE @kw ";
                    cmd.Parameters.AddWithValue("@kw", "%" + keyword + "%");
                }

                sql += " ORDER BY Rec_Create DESC ";
                cmd.CommandText = sql;

                var dt = new DataTable();
                using (var da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }

                gvRecs.DataSource = dt;
                gvRecs.DataBind();
            }
            switch (gvRecs.Rows.Count)
            {
                case 0:
                    lblMsg.Text = "Không tìm thấy tin tuyển dụng nào.";
                    lblMsg.Visible = true;
                    break;
            }

        }


        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            var ids = new List<int>();

            foreach (GridViewRow row in gvRecs.Rows)
            {
                var ck = row.FindControl("ckRow") as CheckBox;
                if (ck != null && ck.Checked)
                {
                    int id = Convert.ToInt32(gvRecs.DataKeys[row.RowIndex].Value);
                    ids.Add(id);
                }
            }

            if (ids.Count == 0)
            {
                lblMsg.Text = "Bạn chưa chọn tin nào để xóa.";
                lblMsg.Visible = true;
                return;
            }

            // XÓA trong bảng Recruitments 
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

                    cmd.CommandText = $"DELETE FROM Recruitments WHERE Id IN ({string.Join(",", ps)})";

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

            BindRecs();
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            Response.Redirect("SanphamChitiet.aspx");
        }

    }
}