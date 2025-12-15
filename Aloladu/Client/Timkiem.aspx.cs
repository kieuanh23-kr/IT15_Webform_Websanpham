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
    public partial class Timkiem : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private const int ProductPageSize = 10;
        private const int NewsPageSize = 2;
        private const int JobPageSize = 4;

        private int ProductPage
        {
            get => ViewState["ProductPage"] == null ? 1 : (int)ViewState["ProductPage"];
            set => ViewState["ProductPage"] = value < 1 ? 1 : value;
        }
        private int NewsPage
        {
            get => ViewState["NewsPage"] == null ? 1 : (int)ViewState["NewsPage"];
            set => ViewState["NewsPage"] = value < 1 ? 1 : value;
        }
        private int JobPage
        {
            get => ViewState["JobPage"] == null ? 1 : (int)ViewState["JobPage"];
            set => ViewState["JobPage"] = value < 1 ? 1 : value;
        }

        private string Keyword => (Request.QueryString["q"] ?? "").Trim();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                litTitleProducts.Text = $"Tìm kiếm &gt; Sản phẩm “{Server.HtmlEncode(Keyword)}”";
                litTitleNews.Text = $"Tìm kiếm &gt; Tin tức “{Server.HtmlEncode(Keyword)}”";

                BindProductFilterOptions();
                BindProducts();
                BindNews();
                BindJobs();
            }
        }

        // ====== FILTERS ======
        private void BindProductFilterOptions()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Brand
                ddlBrand.Items.Clear();
                ddlBrand.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả", "all"));

                using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT BrandName FROM Products WHERE BrandName IS NOT NULL AND LTRIM(RTRIM(BrandName))<>'' ORDER BY BrandName", conn))
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                        ddlBrand.Items.Add(new System.Web.UI.WebControls.ListItem(rd["BrandName"].ToString(), rd["BrandName"].ToString()));
                }

                // Category
                ddlCategory.Items.Clear();
                ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả", "all"));

                using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT CategoryKey FROM Products WHERE CategoryKey IS NOT NULL AND LTRIM(RTRIM(CategoryKey))<>'' ORDER BY CategoryKey", conn))
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        string key = rd["CategoryKey"].ToString();
                        ddlCategory.Items.Add(new System.Web.UI.WebControls.ListItem(MapCatToName(key), key));
                    }
                }
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            ProductPage = 1;
            BindProducts();
        }

        // ====== PRODUCTS ======
        private void BindProducts()
        {
            string kw = Keyword;
            string brand = ddlBrand.SelectedValue;
            string cat = ddlCategory.SelectedValue;
            string priceSort = ddlPrice.SelectedValue;

            int offset = (ProductPage - 1) * ProductPageSize;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string orderBy = "ORDER BY NEWID()";
                if (priceSort == "asc") orderBy = "ORDER BY p.Price ASC";
                else if (priceSort == "desc") orderBy = "ORDER BY p.Price DESC";

                string sql = $@"
                        SELECT p.Id, p.Name, p.Description, p.OldPrice, p.Price, p.ImageUrl, p.BrandName, p.CategoryKey
                        FROM Products p
                        WHERE (@kw = '' OR
                               p.Name LIKE @kwLike OR
                               p.BrandName LIKE @kwLike OR
                               p.CategoryKey LIKE @kwLike)
                          AND (@brand = 'all' OR p.BrandName = @brand)
                          AND (@cat = 'all' OR LTRIM(RTRIM(p.CategoryKey)) = @cat)
                        {orderBy}
                        OFFSET @offset ROWS FETCH NEXT @size ROWS ONLY;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@kw", kw);
                cmd.Parameters.AddWithValue("@kwLike", "%" + kw + "%");
                cmd.Parameters.AddWithValue("@brand", brand);
                cmd.Parameters.AddWithValue("@cat", cat);
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@size", ProductPageSize);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                // lùi trang nếu hết data
                if (dt.Rows.Count == 0 && ProductPage > 1)
                {
                    ProductPage--;
                    BindProducts();
                    return;
                }

                dt.Columns.Add("OldPriceText", typeof(string));
                dt.Columns.Add("PriceText", typeof(string));
                dt.Columns.Add("ImageUrlFixed", typeof(string));

                foreach (DataRow r in dt.Rows)
                {
                    decimal oldP = r["OldPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(r["OldPrice"]);
                    decimal price = r["Price"] == DBNull.Value ? 0 : Convert.ToDecimal(r["Price"]);
                    r["OldPriceText"] = oldP > 0 ? FormatMoney(oldP) : "";
                    r["PriceText"] = FormatMoney(price);

                    r["ImageUrlFixed"] = FixImageUrl(r["ImageUrl"]?.ToString());
                }

                pnEmptyProducts.Visible = dt.Rows.Count == 0;
                rptProducts.DataSource = dt;
                rptProducts.DataBind();

                btnProdPrev.Enabled = ProductPage > 1;
                btnProdPrev.CssClass = btnProdPrev.Enabled ? "nav-btn" : "nav-btn opacity-50";
            }
        }

        protected void btnProdPrev_Click(object sender, EventArgs e) { ProductPage--; BindProducts(); }
        protected void btnProdNext_Click(object sender, EventArgs e) { ProductPage++; BindProducts(); }

        // ====== NEWS (Cửa hàng + Sức khỏe) ======
        private void BindNews()
        {
            string kw = Keyword;
            int offset = (NewsPage - 1) * NewsPageSize;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Category: cua_hang + suc_khoe (tuỳ bạn lưu)
                // Ở đây mình lọc theo 2 loại: 'cua_hang' và 'suc_khoe'
                string sql = @"
                        SELECT Id, Title, Content, Category, ImageUrl, CreatedAt
                        FROM News
                        WHERE @kw = '' OR Title LIKE @kwLike OR Content LIKE @kwLike
                        ORDER BY CreatedAt DESC
                        OFFSET @offset ROWS FETCH NEXT @size ROWS ONLY;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@kw", kw);
                cmd.Parameters.AddWithValue("@kwLike", "%" + kw + "%");
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@size", NewsPageSize);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                if (dt.Rows.Count == 0 && NewsPage > 1)
                {
                    NewsPage--;
                    BindNews();
                    return;
                }

                dt.Columns.Add("ImageUrlFixed", typeof(string));
                foreach (DataRow r in dt.Rows)
                    r["ImageUrlFixed"] = FixImageUrl(r["ImageUrl"]?.ToString());

                pnEmptyNews.Visible = dt.Rows.Count == 0;
                rptNews.DataSource = dt;
                rptNews.DataBind();

                btnNewsPrev.Enabled = NewsPage > 1;
                btnNewsPrev.CssClass = btnNewsPrev.Enabled ? "nav-btn" : "nav-btn opacity-50";
            }
        }

        protected void btnNewsPrev_Click(object sender, EventArgs e) { NewsPage--; BindNews(); }
        protected void btnNewsNext_Click(object sender, EventArgs e) { NewsPage++; BindNews(); }

        // ====== JOBS (Tuyển dụng) ======
        private void BindJobs()
        {
            string kw = Keyword;
            int offset = (JobPage - 1) * JobPageSize;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = @"
                        SELECT Id, Position, CvDeadline, Salary, WorkType
                        FROM Recruitments
                        WHERE (@kw = '' OR Position LIKE @kwLike OR JobDescription LIKE @kwLike)
                        ORDER BY CvDeadline DESC
                        OFFSET @offset ROWS FETCH NEXT @size ROWS ONLY;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@kw", kw);
                cmd.Parameters.AddWithValue("@kwLike", "%" + kw + "%");
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@size", JobPageSize);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                if (dt.Rows.Count == 0 && JobPage > 1)
                {
                    JobPage--;
                    BindJobs();
                    return;
                }

                dt.Columns.Add("DeadlineText", typeof(string));
                foreach (DataRow r in dt.Rows)
                {
                    if (r["CvDeadline"] == DBNull.Value) r["DeadlineText"] = "";
                    else r["DeadlineText"] = Convert.ToDateTime(r["CvDeadline"]).ToString("HH'h'mm dd/MM/yyyy");
                }

                pnEmptyJobs.Visible = dt.Rows.Count == 0;
                rptJobs.DataSource = dt;
                rptJobs.DataBind();

                btnJobPrev.Enabled = JobPage > 1;
                btnJobPrev.CssClass = btnJobPrev.Enabled ? "nav-btn" : "nav-btn opacity-50";
            }
        }

        protected void btnJobPrev_Click(object sender, EventArgs e) { JobPage--; BindJobs(); }
        protected void btnJobNext_Click(object sender, EventArgs e) { JobPage++; BindJobs(); }

        // ====== HELPERS ======
        private string FormatMoney(decimal v)
        {
            // 1.000.000
            return string.Format(System.Globalization.CultureInfo.GetCultureInfo("vi-VN"), "{0:n0}", v);
        }

        private string FixImageUrl(string img)
        {
            if (string.IsNullOrWhiteSpace(img))
                img = "Client/Images/download.png";

            img = img.Trim().Replace("\\", "/");

            if (!img.StartsWith("~/") && !img.StartsWith("/"))
            {
                if (!img.Contains("/")) img = "Client/Images/" + img;
                img = "~/" + img;
            }

            return ResolveUrl(img);
        }

        private string MapCatToName(string key)
        {
            key = (key ?? "").Trim().ToLower();

            if (key == "dobep" || key == "đồ bếp") return "Đồ bếp";
            if (key == "donha" || key == "dọn nhà") return "Dọn nhà";
            if (key == "saykho" || key == "sấy khô") return "Sấy khô";
            if (key == "dongho" || key == "đồng hồ") return "Đồng hồ";
            if (key == "bongden" || key == "bóng đèn") return "Bóng đèn";
            if (key == "giatla" || key == "giặt là") return "Giặt là";

            // fallback: trả về nguyên key
            return key;
        }
    }
}