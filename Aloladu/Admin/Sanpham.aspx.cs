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
    public partial class Sanpham : System.Web.UI.Page
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
                BindProducts();
                if(gvProducts.HeaderRow != null)
                    gvProducts.HeaderRow.TableSection = TableRowSection.TableHeader;

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindProducts();
        }

        private void BindProducts()
        {
            lblMsg.Visible = false;

            string keyword = (txtKeyword.Text ?? "").Trim();
            string field = (ddlField.SelectedValue ?? "").Trim();

            // chỉ cho phép 3 field hợp lệ
            string safeField = GetSafeField(field);

            string sql =
                @"SELECT Proc_ID, Proc_Name, Proc_Cat, Proc_Brand, Proc_Price, Proc_Quan, Proc_OldPrice
                  FROM vw_Products
                  WHERE (1=1) ";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = conn;

                // nếu keyword trống -> show all (không thêm điều kiện)
                
                if (!string.IsNullOrEmpty(keyword))
                {
                    if (ddlField.SelectedValue == "Proc_Cat")
                    {
                        String CategoryKey = GetCategoryKey(keyword);
                        sql += $" AND {safeField} = @kw ";
                        cmd.Parameters.AddWithValue("@kw", CategoryKey);
                    }
                    else
                    {
                        sql += $" AND {safeField} LIKE @kw ";
                        cmd.Parameters.AddWithValue("@kw", "%" + keyword + "%");
                    }
                }

                sql += " ORDER BY Proc_ID DESC ";
                cmd.CommandText = sql;

                var dt = new DataTable();
                using (var da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }

                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
            switch (gvProducts.Rows.Count)
            {
                case 0:
                    lblMsg.Text = "Không tìm thấy sản phẩm nào.";
                    lblMsg.Visible = true;
                    break;
            }

        }

        private string GetSafeField(string field)
        {
            switch (field)
            {
                case "Proc_Name": return "Proc_Name";           // Tên sản phẩm
                case "Proc_Brand": return "Proc_Brand";         // Tên brand
                case "Proc_Cat": return "Proc_Cat";   // Category
                default: return "Proc_Name";
            }
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            Response.Redirect("SanphamChitiet.aspx");
        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            var ids = new List<int>();

            foreach (GridViewRow row in gvProducts.Rows)
            {
                var ck = row.FindControl("ckRow") as CheckBox;
                if (ck != null && ck.Checked)
                {
                    int id = Convert.ToInt32(gvProducts.DataKeys[row.RowIndex].Value);
                    ids.Add(id);
                }
            }

            if (ids.Count == 0)
            {
                lblMsg.Text = "Bạn chưa chọn sản phẩm nào để xóa.";
                lblMsg.Visible = true;
                return;
            }

            // XÓA trong bảng Products (không xóa từ view)
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

                    cmd.CommandText = $"DELETE FROM Products WHERE Id IN ({string.Join(",", ps)})";

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

            BindProducts();
        }

        protected string GetCategoryName(string procCat)
        {
            if (string.IsNullOrEmpty(procCat))
                return "Chưa phân loại";

            switch (procCat.Trim())
            {
                case "dobep": return "Đồ bếp";
                case "donha": return "Dọn nhà";
                case "saykho": return "Sấy khô";
                case "dongho": return "Đồng hồ";
                case "bongden": return "Bóng đèn";
                case "giatla": return "Giặt là";
                default:
                    return "Khác";
            }
        }

        protected string GetCategoryKey(string procCat)
        {
            string a = procCat.ToLower().Trim();
            string dobep = "đồ bếp";
            string donha = "dọn nhà";  
            string saykho = "sấy khô";
            string dongho = "đồng hồ";
            string bongden = "bóng đèn";
            string giatla = "giặt là";


            if(dobep.Contains(a))
            {
                return "dobep";
            }
            else if(donha.Contains(a))
            {
                return "donha";
            }
            else if(saykho.Contains(a))
            {
                return "saykho";
            }
            else if(dongho.Contains(a))
            {
                return "dongho";
            }
            else if(bongden.Contains(a))
            {
                return "bongden";
            }
            else if(giatla.Contains(a))
            {
                return "giatla";
            }
            else
            {
                return "khac";
            }
        }

    }
}