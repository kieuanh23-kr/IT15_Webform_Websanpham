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
    public partial class Tintuc : System.Web.UI.Page
    {
        private readonly string connStr =
             ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        // mặc định trong tháng
        private string RangeKey
        {
            get => (ViewState["RangeKey"] as string) ?? "month";
            set => ViewState["RangeKey"] = value;
        }
        private string RangeKey2
        {
            get => (ViewState["RangeKey2"] as string) ?? "month";
            set => ViewState["RangeKey2"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RangeKey = "month";
                RangeKey2 = "month";

                SetActiveChip();
                SetActiveChip2();

                BindStoreNews();     // cua-hang
                BindHealthNews();    // suc-khoe
                BindRecruitments();// tuyen-dung
            }
        }

        //CỬA HÀNG
        protected void Range_Click(object sender, EventArgs e)
        {
            var arg = (sender as System.Web.UI.WebControls.LinkButton)?.CommandArgument;
            RangeKey = string.IsNullOrWhiteSpace(arg) ? "month" : arg;

            SetActiveChip();
            BindStoreNews();
        }

       

        private void SetActiveChip()
        {
            btnDay.CssClass = "chip" + (RangeKey == "day" ? " active" : "");
            btnWeek.CssClass = "chip" + (RangeKey == "week" ? " active" : "");
            btnMonth.CssClass = "chip" + (RangeKey == "month" ? " active" : "");
        }

        private DateTime GetFromDate()
        {
            var now = DateTime.Now;
            switch (RangeKey)
            {
                case "day": return now.AddDays(-1);
                case "week": return now.AddDays(-7);
                default: return now.AddMonths(-1); // month
            }
        }

        private void BindStoreNews()
        {
            // Cửa hàng
            string category = "cua-hang";
            DateTime fromDate = GetFromDate();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1) Lấy bài chính mới nhất (IsFeatured=1)
                DataTable dtFeatured = new DataTable();
                using (SqlCommand cmd = new SqlCommand(@"
                        SELECT TOP 1 Id, Title, Content, ImageUrl, CreatedAt
                        FROM News
                        WHERE Category = @cat AND IsFeatured = 1 AND CreatedAt >= @fromDate
                        ORDER BY CreatedAt DESC;", conn))
                {
                    cmd.Parameters.AddWithValue("@cat", category);
                    cmd.Parameters.AddWithValue("@fromDate", fromDate);
                    new SqlDataAdapter(cmd).Fill(dtFeatured);
                }

                int featuredId = 0;
                if (dtFeatured.Rows.Count > 0)
                {
                    featuredId = Convert.ToInt32(dtFeatured.Rows[0]["Id"]);
                    dtFeatured.Columns.Add("ShortContent", typeof(string));
                    dtFeatured.Rows[0]["ShortContent"] = MakeShort(dtFeatured.Rows[0]["Content"]?.ToString(), 260);

                    FixImageUrl(dtFeatured.Rows[0]);
                    rptFeatured.DataSource = dtFeatured;
                    rptFeatured.DataBind();

                    pnFeatured.Visible = true;
                }
                else
                {
                    pnFeatured.Visible = false;
                }

                // 2) Lấy 2 bài mới nhất còn lại (không trùng bài chính)
                DataTable dtLatest2 = new DataTable();
                using (SqlCommand cmd = new SqlCommand(@"
                        SELECT TOP 2 Id, Title, ImageUrl, CreatedAt
                        FROM News
                        WHERE Category = @cat AND CreatedAt >= @fromDate
                          AND (@featuredId = 0 OR Id <> @featuredId)
                        ORDER BY CreatedAt DESC;", conn))
                {
                    cmd.Parameters.AddWithValue("@cat", category);
                    cmd.Parameters.AddWithValue("@fromDate", fromDate);
                    cmd.Parameters.AddWithValue("@featuredId", featuredId);
                    new SqlDataAdapter(cmd).Fill(dtLatest2);
                }

                foreach (DataRow r in dtLatest2.Rows) FixImageUrl(r);

                rptLatest2.DataSource = dtLatest2;
                rptLatest2.DataBind();

                bool empty = (dtFeatured.Rows.Count == 0 && dtLatest2.Rows.Count == 0);
                pnEmpty.Visible = empty;
            }
        }


        //SỨC KHỎE
        protected void Range_Click2(object sender, EventArgs e)
        {
            var arg = (sender as System.Web.UI.WebControls.LinkButton)?.CommandArgument;
            RangeKey2 = string.IsNullOrWhiteSpace(arg) ? "month" : arg;

            SetActiveChip2();
            BindHealthNews();
        }

        private void SetActiveChip2()
        {
            btnDay2.CssClass = "chip" + (RangeKey2 == "day" ? " active" : "");
            btnWeek2.CssClass = "chip" + (RangeKey2 == "week" ? " active" : "");
            btnMonth2.CssClass = "chip" + (RangeKey2 == "month" ? " active" : "");
        }

        private DateTime GetFromDate2()
        {
            var now = DateTime.Now;
            switch (RangeKey2)
            {
                case "day": return now.AddDays(-1);
                case "week": return now.AddDays(-7);
                default: return now.AddMonths(-1);
            }
        }

        private void BindHealthNews()
        {
            string category = "suc-khoe";
            DateTime fromDate = GetFromDate2();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1) tin chính
                DataTable dtFeatured = new DataTable();
                using (SqlCommand cmd = new SqlCommand(@"
                        SELECT TOP 1 Id, Title, Content, ImageUrl, CreatedAt
                        FROM News
                        WHERE Category = @cat AND IsFeatured = 1 AND CreatedAt >= @fromDate
                        ORDER BY CreatedAt DESC;", conn))
                {
                    cmd.Parameters.AddWithValue("@cat", category);
                    cmd.Parameters.AddWithValue("@fromDate", fromDate);
                    new SqlDataAdapter(cmd).Fill(dtFeatured);
                }

                int featuredId = 0;
                if (dtFeatured.Rows.Count > 0)
                {
                    featuredId = Convert.ToInt32(dtFeatured.Rows[0]["Id"]);
                    dtFeatured.Columns.Add("ShortContent", typeof(string));
                    dtFeatured.Rows[0]["ShortContent"] =
                        MakeShort(dtFeatured.Rows[0]["Content"]?.ToString(), 260);

                    FixImageUrl(dtFeatured.Rows[0]);
                    rptFeatured2.DataSource = dtFeatured;
                    rptFeatured2.DataBind();

                    pnFeatured2.Visible = true;
                }
                else
                {
                    pnFeatured2.Visible = false;
                }

                // 2) 2 bài mới nhất còn lại
                DataTable dtLatest2 = new DataTable();
                using (SqlCommand cmd = new SqlCommand(@"
                        SELECT TOP 2 Id, Title, ImageUrl, CreatedAt
                        FROM News
                        WHERE Category = @cat AND CreatedAt >= @fromDate
                          AND (@featuredId = 0 OR Id <> @featuredId)
                        ORDER BY CreatedAt DESC;", conn))
                {
                    cmd.Parameters.AddWithValue("@cat", category);
                    cmd.Parameters.AddWithValue("@fromDate", fromDate);
                    cmd.Parameters.AddWithValue("@featuredId", featuredId);
                    new SqlDataAdapter(cmd).Fill(dtLatest2);
                }

                foreach (DataRow r in dtLatest2.Rows) FixImageUrl(r);

                rptLatest2_2.DataSource = dtLatest2;
                rptLatest2_2.DataBind();

                pnEmpty2.Visible = (dtFeatured.Rows.Count == 0 && dtLatest2.Rows.Count == 0);
            }
        }


        //TUYỂN DỤNG
        private void BindRecruitments()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // lấy 4 tin mới nhất (đúng như mockup 4 card)
                DataTable dt = new DataTable();
                using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 4 Id, Position, CvDeadline, Salary, WorkType
                FROM Recruitments
                ORDER BY CvDeadline DESC, Id DESC;", conn))
                {
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


        private string MakeShort(string s, int max)
        {
            if (string.IsNullOrWhiteSpace(s)) return "";
            s = s.Trim();
            if (s.Length <= max) return s;
            return s.Substring(0, max) + "...";
        }

        private void FixImageUrl(DataRow r)
        {
            string img = r["ImageUrl"]?.ToString();
            if (string.IsNullOrWhiteSpace(img))
                img = "Images/download.png"; // đổi vị trí ảnh

            img = img.Trim().Replace("\\", "/");

            if (!img.StartsWith("~/") && !img.StartsWith("/"))
            {
                if (!img.Contains("/")) img = "Images/" + img;
                img = "~/" + img;
            }

            r["ImageUrl"] = ResolveUrl(img);
        }
    }
}