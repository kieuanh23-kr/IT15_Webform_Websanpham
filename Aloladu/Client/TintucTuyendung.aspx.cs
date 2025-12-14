using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Client
{
    public partial class TintucTuyendung : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id;
                if (!int.TryParse(Request.QueryString["id"], out id) || id <= 0)
                {
                    Response.Redirect("Tintuc.aspx");
                    return;
                }

                LoadRecruitment(id);
                ViewState["CurrentNewsId"] = id;
                BindRecruitments();
            }
        }

        private void LoadRecruitment(int id)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                DataTable dt = new DataTable();

                using (SqlCommand cmd = new SqlCommand(@"
                            SELECT TOP 1 Id, Position, CvDeadline, Salary, WorkType, WorkingTime, JobDescription, Location
                            FROM Recruitments
                            WHERE Id = @id;", conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    new SqlDataAdapter(cmd).Fill(dt);
                }

                if (dt.Rows.Count == 0)
                {
                    Response.Redirect("Tintuc.aspx");
                    return;
                }

                DataRow r = dt.Rows[0];

                litPosition.Text = Server.HtmlEncode(r["Position"]?.ToString() ?? "");

                DateTime deadline = r["CvDeadline"] == DBNull.Value ? DateTime.Now : Convert.ToDateTime(r["CvDeadline"]);
                litDeadline.Text = deadline.ToString("HH'h'mm dd/MM/yyyy");

                litSalary.Text = Server.HtmlEncode(r["Salary"]?.ToString() ?? "");
                litWorkType.Text = Server.HtmlEncode(r["WorkType"]?.ToString() ?? "");
                litWorkingTime.Text = Server.HtmlEncode(r["WorkingTime"]?.ToString() ?? "");

                // mô tả: hiển thị dạng text thường
                litJobDesc.Text = Server.HtmlEncode(r["JobDescription"]?.ToString() ?? "");

                litLocation.Text = Server.HtmlEncode(r["Location"]?.ToString() ?? "");
            }
        }

        private void BindRecruitments()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                int currentId = ViewState["CurrentNewsId"] == null ? 0 : (int)ViewState["CurrentNewsId"];
                // lấy 4 tin mới nhất (đúng như mockup 4 card)
                DataTable dt = new DataTable();
                using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 4 Id, Position, CvDeadline, Salary, WorkType
                FROM Recruitments WHERE Id <> @currentId
                ORDER BY CvDeadline DESC, Id DESC;", conn))

                {
                    cmd.Parameters.AddWithValue("@currentId", currentId);
                    new SqlDataAdapter(cmd).Fill(dt);
                }

                dt.Columns.Add("DeadlineText", typeof(string));

                foreach (DataRow r in dt.Rows)
                {
                    DateTime d = Convert.ToDateTime(r["CvDeadline"]);
                    r["DeadlineText"] = d.ToString("HH'h'mm dd/MM/yyyy");
                }

                rptRecruit.DataSource = dt;
                rptRecruit.DataBind();
            }
        }
    }
}