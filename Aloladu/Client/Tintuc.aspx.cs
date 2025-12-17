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
                JobPage = 1;
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
        private int StorePage
        {
            get => (ViewState["StorePage"] as int?) ?? 1;
            set => ViewState["StorePage"] = value;
        }

        protected void StorePrev_Click(object sender, EventArgs e)
        {
            if (StorePage > 1) StorePage--;
            BindStoreNews();
        }

        protected void StoreNext_Click(object sender, EventArgs e)
        {
            StorePage++;
            BindStoreNews();
        }

        protected void Range_Click(object sender, EventArgs e)
        {
            var arg = (sender as System.Web.UI.WebControls.LinkButton)?.CommandArgument;
            RangeKey = string.IsNullOrWhiteSpace(arg) ? "month" : arg;

            StorePage = 1;
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
            string category = "cua-hang";
            DateTime fromDate = GetFromDate();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // ----- Lấy featured + latest2 để biết các Id cần loại bỏ (tránh trùng) -----
                int featuredId = 0;
                List<int> excludeIds = new List<int>();

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

                if (dtFeatured.Rows.Count > 0)
                {
                    featuredId = Convert.ToInt32(dtFeatured.Rows[0]["Id"]);
                    excludeIds.Add(featuredId);

                    dtFeatured.Columns.Add("ShortContent", typeof(string));
                    dtFeatured.Rows[0]["ShortContent"] = MakeShort(dtFeatured.Rows[0]["Content"]?.ToString(), 260);
                    FixImageUrl(dtFeatured.Rows[0]);
                }

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

                foreach (DataRow r in dtLatest2.Rows)
                {
                    excludeIds.Add(Convert.ToInt32(r["Id"]));
                    FixImageUrl(r);
                }

                // ----- Render theo trang -----
                if (StorePage == 1)
                {
                    // show featured + latest2
                    pnFeatured.Visible = dtFeatured.Rows.Count > 0;
                    rptFeatured.DataSource = dtFeatured;
                    rptFeatured.DataBind();

                    rptLatest2.DataSource = dtLatest2;
                    rptLatest2.DataBind();

                    pnStorePage2.Visible = false;
                }
                else
                {
                    // hide block page1
                    pnFeatured.Visible = false;
                    // nếu bạn có panel bọc latest2 thì set Visible=false luôn (tuỳ UI bạn)
                    // vd: pnLatest2.Visible = false;

                    // page>=2: 4 bài / trang (offset bắt đầu từ page 2 => (page-2)*4)
                    int offset = (StorePage - 2) * 4;

                    // build điều kiện NOT IN động để tránh trùng 3 bài page1
                    string notInSql = "";
                    for (int i = 0; i < excludeIds.Count; i++)
                        notInSql += (i == 0 ? "" : ",") + "@ex" + i;

                    string sql = $@"
                            SELECT Id, Title, ImageUrl, CreatedAt
                            FROM News
                            WHERE Category = @cat AND CreatedAt >= @fromDate
                            {(excludeIds.Count > 0 ? $"AND Id NOT IN ({notInSql})" : "")}
                            ORDER BY CreatedAt DESC
                            OFFSET @offset ROWS FETCH NEXT 4 ROWS ONLY;";

                    DataTable dtPage2 = new DataTable();
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@cat", category);
                        cmd.Parameters.AddWithValue("@fromDate", fromDate);
                        cmd.Parameters.AddWithValue("@offset", offset);

                        for (int i = 0; i < excludeIds.Count; i++)
                            cmd.Parameters.AddWithValue("@ex" + i, excludeIds[i]);

                        new SqlDataAdapter(cmd).Fill(dtPage2);
                    }

                    foreach (DataRow r in dtPage2.Rows) FixImageUrl(r);

                    pnStorePage2.Visible = true;
                    rptStorePage2.DataSource = dtPage2;
                    rptStorePage2.DataBind();

                    // Nếu page hiện tại rỗng => lùi lại 1 trang
                    if (dtPage2.Rows.Count == 0 && StorePage > 1)
                    {
                        StorePage--;
                        BindStoreNews();
                        return;
                    }
                }

                // ----- Enable/Disable nav btn -----
                btnStorePrev.CssClass = "nav-btn" + (StorePage <= 1 ? " disabled" : "");
                btnStorePrev.Enabled = StorePage > 1;

                // check còn dữ liệu để next không (tồn tại bài kế tiếp)
                bool hasNext = CheckStoreHasNext(conn, category, fromDate, excludeIds);
                btnStoreNext.CssClass = "nav-btn" + (!hasNext ? " disabled" : "");
                btnStoreNext.Enabled = hasNext;

                pnEmpty.Visible = (StorePage == 1)
                    ? (dtFeatured.Rows.Count == 0 && dtLatest2.Rows.Count == 0)
                    : (!pnStorePage2.Visible);
            }
        }

        private bool CheckStoreHasNext(SqlConnection conn, string category, DateTime fromDate, List<int> excludeIds)
        {
            // page1: next tồn tại nếu còn >=1 bài ngoài featured+2latest
            // page>=2: next tồn tại nếu còn bài ở trang kế tiếp
            int offset = (StorePage == 1) ? 0 : (StorePage - 1) * 4; // page2=>4, page3=>8...

            // tổng số bài (trừ 3 bài page1)
            string notInSql = "";
            for (int i = 0; i < excludeIds.Count; i++)
                notInSql += (i == 0 ? "" : ",") + "@ex" + i;

            string sql = $@"
                SELECT COUNT(1)
                FROM News
                WHERE Category=@cat AND CreatedAt>=@fromDate
        {(excludeIds.Count > 0 ? $"AND Id NOT IN ({notInSql})" : "")};";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cat", category);
                cmd.Parameters.AddWithValue("@fromDate", fromDate);
                for (int i = 0; i < excludeIds.Count; i++)
                    cmd.Parameters.AddWithValue("@ex" + i, excludeIds[i]);

                int total = Convert.ToInt32(cmd.ExecuteScalar());

                if (StorePage == 1) return total > 0;                 // còn bài ngoài top3
                int alreadyShown = (StorePage - 1) * 4;               // page2 đang show 4 => alreadyShown=4
                return total > alreadyShown;                          // còn bài cho trang tiếp
            }
        }



        //SỨC KHỎE
        private int HealthPage
        {
            get => (ViewState["HealthPage"] as int?) ?? 1;
            set => ViewState["HealthPage"] = value;
        }
        protected void Range_Click2(object sender, EventArgs e)
        {
            var arg = (sender as System.Web.UI.WebControls.LinkButton)?.CommandArgument;
            RangeKey2 = string.IsNullOrWhiteSpace(arg) ? "month" : arg;

            HealthPage = 1;
            SetActiveChip2();
            BindHealthNews();
        }
        protected void HealthPrev_Click(object sender, EventArgs e)
        {
            if (HealthPage > 1) HealthPage--;
            BindHealthNews();
        }

        protected void HealthNext_Click(object sender, EventArgs e)
        {
            HealthPage++;
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

                // ----- Lấy featured + latest2 để biết các Id cần loại bỏ (tránh trùng) -----
                int featuredId = 0;
                List<int> excludeIds = new List<int>();

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

                if (dtFeatured.Rows.Count > 0)
                {
                    featuredId = Convert.ToInt32(dtFeatured.Rows[0]["Id"]);
                    excludeIds.Add(featuredId);

                    dtFeatured.Columns.Add("ShortContent", typeof(string));
                    dtFeatured.Rows[0]["ShortContent"] = MakeShort(dtFeatured.Rows[0]["Content"]?.ToString(), 260);
                    FixImageUrl(dtFeatured.Rows[0]);
                }

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

                foreach (DataRow r in dtLatest2.Rows)
                {
                    excludeIds.Add(Convert.ToInt32(r["Id"]));
                    FixImageUrl(r);
                }

                // ----- Render theo trang -----
                if (HealthPage == 1)
                {
                    // show featured + latest2
                    pnFeatured2.Visible = dtFeatured.Rows.Count > 0;
                    rptFeatured2.DataSource = dtFeatured;
                    rptFeatured2.DataBind();

                    rptLatest2_2.DataSource = dtLatest2;
                    rptLatest2_2.DataBind();

                    pnHealthPage2.Visible = false;
                }
                else
                {
                    // hide block page1
                    pnFeatured.Visible = false;
                    // nếu bạn có panel bọc latest2 thì set Visible=false luôn (tuỳ UI bạn)
                    // vd: pnLatest2.Visible = false;

                    // page>=2: 4 bài / trang (offset bắt đầu từ page 2 => (page-2)*4)
                    int offset = (HealthPage - 2) * 4;

                    // build điều kiện NOT IN động để tránh trùng 3 bài page1
                    string notInSql = "";
                    for (int i = 0; i < excludeIds.Count; i++)
                        notInSql += (i == 0 ? "" : ",") + "@ex" + i;

                    string sql = $@"
                        SELECT Id, Title, ImageUrl, CreatedAt
                        FROM News
                        WHERE Category = @cat AND CreatedAt >= @fromDate
                        {(excludeIds.Count > 0 ? $"AND Id NOT IN ({notInSql})" : "")}
                        ORDER BY CreatedAt DESC
                        OFFSET @offset ROWS FETCH NEXT 4 ROWS ONLY;";

                    DataTable dtPage2 = new DataTable();
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@cat", category);
                        cmd.Parameters.AddWithValue("@fromDate", fromDate);
                        cmd.Parameters.AddWithValue("@offset", offset);

                        for (int i = 0; i < excludeIds.Count; i++)
                            cmd.Parameters.AddWithValue("@ex" + i, excludeIds[i]);

                        new SqlDataAdapter(cmd).Fill(dtPage2);
                    }

                    foreach (DataRow r in dtPage2.Rows) FixImageUrl(r);

                    pnHealthPage2.Visible = true;
                    rptHealthPage2.DataSource = dtPage2;
                    rptHealthPage2.DataBind();

                    // Nếu page hiện tại rỗng => lùi lại 1 trang
                    if (dtPage2.Rows.Count == 0 && HealthPage > 1)
                    {
                        HealthPage--;
                        BindStoreNews();
                        return;
                    }
                }

                // ----- Enable/Disable nav btn -----
                btnHealthPrev.CssClass = "nav-btn" + (HealthPage <= 1 ? " disabled" : "");
                btnHealthPrev.Enabled = HealthPage > 1;

                // check còn dữ liệu để next không (tồn tại bài kế tiếp)
                bool hasNext = CheckHealthHasNext(conn, category, fromDate, excludeIds);
                btnHealthNext.CssClass = "nav-btn" + (!hasNext ? " disabled" : "");
                btnHealthNext.Enabled = hasNext;

                pnEmpty.Visible = (HealthPage == 1)
                    ? (dtFeatured.Rows.Count == 0 && dtLatest2.Rows.Count == 0)
                    : (!pnHealthPage2.Visible);
            }
        }

        private bool CheckHealthHasNext(SqlConnection conn, string category, DateTime fromDate, List<int> excludeIds)
        {
            // page1: next tồn tại nếu còn >=1 bài ngoài featured+2latest
            // page>=2: next tồn tại nếu còn bài ở trang kế tiếp
            int offset = (HealthPage == 1) ? 0 : (HealthPage - 1) * 4; // page2=>4, page3=>8...

            // tổng số bài (trừ 3 bài page1)
            string notInSql = "";
            for (int i = 0; i < excludeIds.Count; i++)
                notInSql += (i == 0 ? "" : ",") + "@ex" + i;

            string sql = $@"
            SELECT COUNT(1)
            FROM News
            WHERE Category=@cat AND CreatedAt>=@fromDate
            {(excludeIds.Count > 0 ? $"AND Id NOT IN ({notInSql})" : "")};";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cat", category);
                cmd.Parameters.AddWithValue("@fromDate", fromDate);
                for (int i = 0; i < excludeIds.Count; i++)
                    cmd.Parameters.AddWithValue("@ex" + i, excludeIds[i]);

                int total = Convert.ToInt32(cmd.ExecuteScalar());

                if (HealthPage == 1) return total > 0;                 // còn bài ngoài top3
                int alreadyShown = (HealthPage - 1) * 4;               // page2 đang show 4 => alreadyShown=4
                return total > alreadyShown;                          // còn bài cho trang tiếp
            }
        }



        //TUYỂN DỤNG
        private int JobPage
        {
            get => ViewState["JobPage"] == null ? 1 : (int)ViewState["JobPage"];
            set => ViewState["JobPage"] = value;
        }

        private const int JobPageSize = 4;

        private void BindRecruitments()
        {
            int offset = (JobPage - 1) * JobPageSize;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT Id, Position, CvDeadline, Salary, WorkType
                    FROM Recruitments
                    ORDER BY CreatedAt DESC
                    OFFSET @offset ROWS FETCH NEXT @take ROWS ONLY";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@take", JobPageSize + 1); // +1 để check còn trang sau

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                // nếu page hiện tại không có dữ liệu → lùi 1 page
                if (dt.Rows.Count == 0 && JobPage > 1)
                {
                    JobPage--;
                    BindRecruitments();
                    return;
                }

                bool hasNext = dt.Rows.Count > JobPageSize;
                if (hasNext)
                    dt.Rows.RemoveAt(dt.Rows.Count - 1);

                rptRecruitments.DataSource = dt;
                rptRecruitments.DataBind();

                // ===== NAV BUTTON =====
                btnJobPrev.Enabled = JobPage > 1;
                btnJobPrev.CssClass = btnJobPrev.Enabled ? "nav-btn" : "nav-btn opacity-50";

                btnJobNext.Enabled = hasNext;
                btnJobNext.CssClass = btnJobNext.Enabled ? "nav-btn" : "nav-btn opacity-50";
            }
        }

        protected void btnJobPrev_Click(object sender, EventArgs e)
        {
            if (JobPage > 1)
                JobPage--;

            BindRecruitments();
        }

        protected void btnJobNext_Click(object sender, EventArgs e)
        {
            JobPage++;
            BindRecruitments();
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
                img = "Aloladu/Images/download.png";

            img = img.Trim().Replace("\\", "/");

            if (!img.StartsWith("~/") && !img.StartsWith("/"))
            {
                if (!img.Contains("/")) img = "Aloladu/Images/" + img; 
                img = "~/" + img;
            }
            r["ImageUrl"] = ResolveUrl(img);
        }
    }
}