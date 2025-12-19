using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;

namespace Aloladu.Client
{
    public partial class Tintuc : System.Web.UI.Page
    {
        private readonly string connStr =
             ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                JobPage = 1;
                StoreRangeKey = "month";
                HealthRangeKey = "month";

                SetActiveChip(GetStoreSection());
                SetActiveChip(GetHealthSection());

                BindNews(GetStoreSection());
                BindNews(GetHealthSection());
                BindRecruitments();
            }
        }

        // Cấu trúc để quản lý từng loại tin tức: CỬA HÀNG VÀ SỨC KHỎE
        private class NewsSection
        {
            public string Category { get; set; }
            public string RangeKey { get; set; }
            public int CurrentPage { get; set; }
            public Panel FeaturedPanel { get; set; }
            public Panel Latest2Panel { get; set; }
            public Panel Page2Panel { get; set; }
            public Repeater FeaturedRepeater { get; set; }
            public Repeater Latest2Repeater { get; set; }
            public Repeater Page2Repeater { get; set; }
            public WebControl PrevButton { get; set; }
            public WebControl NextButton { get; set; }
            public LinkButton DayChip { get; set; }
            public LinkButton WeekChip { get; set; }
            public LinkButton MonthChip { get; set; }
        }

        private string StoreRangeKey
        {
            get => (ViewState["StoreRangeKey"] as string) ?? "month";
            set => ViewState["StoreRangeKey"] = value;
        }

        private string HealthRangeKey
        {
            get => (ViewState["HealthRangeKey"] as string) ?? "month";
            set => ViewState["HealthRangeKey"] = value;
        }

        private int StorePage
        {
            get => (ViewState["StorePage"] as int?) ?? 1;
            set => ViewState["StorePage"] = value;
        }

        private int HealthPage
        {
            get => (ViewState["HealthPage"] as int?) ?? 1;
            set => ViewState["HealthPage"] = value;
        }

        private int JobPage
        {
            get => ViewState["JobPage"] == null ? 1 : (int)ViewState["JobPage"];
            set => ViewState["JobPage"] = value;
        }

        private const int JobPageSize = 4;

       

        // CỬA HÀNG
        private NewsSection GetStoreSection()
        {
            return new NewsSection
            {
                Category = "cua-hang",
                RangeKey = StoreRangeKey,
                CurrentPage = StorePage,
                FeaturedPanel = pnFeatured,
                Latest2Panel = pnLatest2_1,
                Page2Panel = pnStorePage2,
                FeaturedRepeater = rptFeatured,
                Latest2Repeater = rptLatest2,
                Page2Repeater = rptStorePage2,
                PrevButton = btnStorePrev,
                NextButton = btnStoreNext,
                DayChip = btnDay,
                WeekChip = btnWeek,
                MonthChip = btnMonth
            };
        }

        protected void StorePrev_Click(object sender, EventArgs e)
        {
            if (StorePage > 1) StorePage--;
            BindNews(GetStoreSection());
        }

        protected void StoreNext_Click(object sender, EventArgs e)
        {
            StorePage++;
            BindNews(GetStoreSection());
        }

        protected void Range_Click(object sender, EventArgs e)
        {
            var arg = (sender as LinkButton)?.CommandArgument;
            StoreRangeKey = string.IsNullOrWhiteSpace(arg) ? "month" : arg;
            StorePage = 1;

            var section = GetStoreSection();
            SetActiveChip(section);
            BindNews(section);
        }

        // SỨC KHỎE
        private NewsSection GetHealthSection()
        {
            return new NewsSection
            {
                Category = "suc-khoe",
                RangeKey = HealthRangeKey,
                CurrentPage = HealthPage,
                FeaturedPanel = pnFeatured2,
                Latest2Panel = pnLatest2_2,
                Page2Panel = pnHealthPage2,
                FeaturedRepeater = rptFeatured2,
                Latest2Repeater = rptLatest2_2,
                Page2Repeater = rptHealthPage2,
                PrevButton = btnHealthPrev,
                NextButton = btnHealthNext,
                DayChip = btnDay2,
                WeekChip = btnWeek2,
                MonthChip = btnMonth2
            };
        }

        protected void HealthPrev_Click(object sender, EventArgs e)
        {
            if (HealthPage > 1) HealthPage--;
            BindNews(GetHealthSection());
        }

        protected void HealthNext_Click(object sender, EventArgs e)
        {
            HealthPage++;
            BindNews(GetHealthSection());
        }

        protected void Range_Click2(object sender, EventArgs e)
        {
            var arg = (sender as LinkButton)?.CommandArgument;
            HealthRangeKey = string.IsNullOrWhiteSpace(arg) ? "month" : arg;
            HealthPage = 1;

            var section = GetHealthSection();
            SetActiveChip(section);
            BindNews(section);
        }


        private void SetActiveChip(NewsSection section)
        {
            section.DayChip.CssClass = "chip" + (section.RangeKey == "day" ? " active" : "");
            section.WeekChip.CssClass = "chip" + (section.RangeKey == "week" ? " active" : "");
            section.MonthChip.CssClass = "chip" + (section.RangeKey == "month" ? " active" : "");
        }

        private DateTime GetFromDate(string rangeKey)
        {
            var now = DateTime.Now;
            switch (rangeKey)
            {
                case "day": return now.AddDays(-0);
                case "week": return now.AddDays(-7);
                default: return now.AddMonths(-1);
            }
        }

        private void BindNews(NewsSection section)
        {
            DateTime fromDate = GetFromDate(section.RangeKey);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Lấy featured + latest2
                var (dtFeatured, dtLatest2, excludeIds) = GetFeaturedAndLatest(conn, section.Category, fromDate);

                // Render theo trang
                if (section.CurrentPage == 1)
                {
                    RenderPage1(section, dtFeatured, dtLatest2);
                }
                else
                {
                    var dtPage2 = GetPageData(conn, section.Category, fromDate, excludeIds, section.CurrentPage);
                    RenderPage2Plus(section, dtPage2);

                    // Nếu page rỗng => lùi lại
                    if (dtPage2.Rows.Count == 0 && section.CurrentPage > 1)
                    {
                        UpdatePageNumber(section, section.CurrentPage - 1);
                        BindNews(section);
                        return;
                    }
                }

                // Enable/Disable nav buttons
                UpdateNavButtons(section, conn, fromDate, excludeIds);

                // Empty state
                pnEmpty.Visible = (section.CurrentPage == 1)
                    ? (dtFeatured.Rows.Count == 0 && dtLatest2.Rows.Count == 0)
                    : (!section.Page2Panel.Visible);
            }
        }

        private (DataTable featured, DataTable latest2, List<int> excludeIds) GetFeaturedAndLatest(
            SqlConnection conn, string category, DateTime fromDate)
        {
            int featuredId = 0;
            List<int> excludeIds = new List<int>();

            // Featured
            DataTable dtFeatured = new DataTable();
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 1 Id, Title, Content, ImageUrl, CreatedAt
                FROM News
                WHERE Category = @cat AND IsFeatured = 1 AND CreatedAt >= @fromDate
                ORDER BY CreatedAt DESC", conn))
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

            // Latest 2
            DataTable dtLatest2 = new DataTable();
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 2 Id, Title, ImageUrl, CreatedAt
                FROM News
                WHERE Category = @cat AND CreatedAt >= @fromDate
                  AND (@featuredId = 0 OR Id <> @featuredId)
                ORDER BY CreatedAt DESC", conn))
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

            return (dtFeatured, dtLatest2, excludeIds);
        }

        private DataTable GetPageData(SqlConnection conn, string category, DateTime fromDate,
            List<int> excludeIds, int currentPage)
        {
            int offset = (currentPage - 2) * 4;
            string notInSql = BuildNotInClause(excludeIds);

            string sql = $@"
                SELECT Id, Title, ImageUrl, CreatedAt
                FROM News
                WHERE Category = @cat AND CreatedAt >= @fromDate
                {(excludeIds.Count > 0 ? $"AND Id NOT IN ({notInSql})" : "")}
                ORDER BY CreatedAt DESC
                OFFSET @offset ROWS FETCH NEXT 4 ROWS ONLY";

            DataTable dt = new DataTable();
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cat", category);
                cmd.Parameters.AddWithValue("@fromDate", fromDate);
                cmd.Parameters.AddWithValue("@offset", offset);
                AddExcludeParameters(cmd, excludeIds);
                new SqlDataAdapter(cmd).Fill(dt);
            }

            foreach (DataRow r in dt.Rows) FixImageUrl(r);
            return dt;
        }

        private void RenderPage1(NewsSection section, DataTable dtFeatured, DataTable dtLatest2)
        {
            section.FeaturedPanel.Visible = dtFeatured.Rows.Count > 0;
            section.Latest2Panel.Visible = true;
            section.FeaturedRepeater.DataSource = dtFeatured;
            section.FeaturedRepeater.DataBind();
            section.Latest2Repeater.DataSource = dtLatest2;
            section.Latest2Repeater.DataBind();
            section.Page2Panel.Visible = false;
        }

        private void RenderPage2Plus(NewsSection section, DataTable dtPage2)
        {
            section.FeaturedPanel.Visible = false;
            section.Latest2Panel.Visible = false;
            section.Page2Panel.Visible = true;
            section.Page2Repeater.DataSource = dtPage2;
            section.Page2Repeater.DataBind();
        }

        private void UpdateNavButtons(NewsSection section, SqlConnection conn,
            DateTime fromDate, List<int> excludeIds)
        {
            section.PrevButton.CssClass = "nav-btn" + (section.CurrentPage <= 1 ? " disabled" : "");
            section.PrevButton.Enabled = section.CurrentPage > 1;

            bool hasNext = CheckHasNext(conn, section.Category, fromDate, excludeIds, section.CurrentPage);
            section.NextButton.CssClass = "nav-btn" + (!hasNext ? " disabled" : "");
            section.NextButton.Enabled = hasNext;
        }

        private bool CheckHasNext(SqlConnection conn, string category, DateTime fromDate,
            List<int> excludeIds, int currentPage)
        {
            string notInSql = BuildNotInClause(excludeIds);
            string sql = $@"
                SELECT COUNT(1)
                FROM News
                WHERE Category=@cat AND CreatedAt>=@fromDate
                {(excludeIds.Count > 0 ? $"AND Id NOT IN ({notInSql})" : "")}";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cat", category);
                cmd.Parameters.AddWithValue("@fromDate", fromDate);
                AddExcludeParameters(cmd, excludeIds);

                int total = Convert.ToInt32(cmd.ExecuteScalar());

                if (currentPage == 1) return total > 0;
                int alreadyShown = (currentPage - 1) * 4;
                return total > alreadyShown;
            }
        }

        private void UpdatePageNumber(NewsSection section, int newPage)
        {
            if (section.Category == "cua-hang")
                StorePage = newPage;
            else if (section.Category == "suc-khoe")
                HealthPage = newPage;
        }

        private string BuildNotInClause(List<int> excludeIds)
        {
            return string.Join(",", excludeIds.Select((_, i) => "@ex" + i));
        }

        private void AddExcludeParameters(SqlCommand cmd, List<int> excludeIds)
        {
            for (int i = 0; i < excludeIds.Count; i++)
                cmd.Parameters.AddWithValue("@ex" + i, excludeIds[i]);
        }

        // TUYỂN DỤNG

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
                cmd.Parameters.AddWithValue("@take", JobPageSize + 1);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

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

                btnJobPrev.Enabled = JobPage > 1;
                btnJobPrev.CssClass = btnJobPrev.Enabled ? "nav-btn" : "nav-btn opacity-50";

                btnJobNext.Enabled = hasNext;
                btnJobNext.CssClass = btnJobNext.Enabled ? "nav-btn" : "nav-btn opacity-50";
            }
        }

        protected void btnJobPrev_Click(object sender, EventArgs e)
        {
            if (JobPage > 1) JobPage--;
            BindRecruitments();
        }

        protected void btnJobNext_Click(object sender, EventArgs e)
        {
            JobPage++;
            BindRecruitments();
        }

        //Các hàm hỗ trợ
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
            {
                img = "Cua-hang-do-gia-dung.jpg";
            }
            else
            {
                img = System.IO.Path.GetFileName(img);
            }

            r["ImageUrl"] = ResolveUrl("~/Images_News/" + img);
        }
    }
}