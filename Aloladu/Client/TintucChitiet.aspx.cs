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
    public partial class TintucChitiet : System.Web.UI.Page
    {
        private readonly string connStr =
             ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private const int SugPageSize = 2;

        private int SugPage
        {
            get
            {
                int p;
                return int.TryParse(hdSugPage.Value, out p) && p > 0 ? p : 1;
            }
            set
            {
                hdSugPage.Value = (value < 1 ? 1 : value).ToString();
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int id = 0;
                int.TryParse(Request.QueryString["id"], out id);

                if (id <= 0)
                {
                    // không có id -> quay về tin tức
                    Response.Redirect("Tintuc.aspx");
                    return;
                }

                LoadNews(id);
            }
        }

        private void LoadNews(int id)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                DataTable dt = new DataTable();
                using (SqlCommand cmd = new SqlCommand(@"
                                SELECT TOP 1 Id, Title, Content, CreatedAt, Category, ImageUrl
                                FROM News
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

                string title = r["Title"]?.ToString() ?? "";
                string content = r["Content"]?.ToString() ?? "";
                DateTime created = r["CreatedAt"] == DBNull.Value ? DateTime.Now : Convert.ToDateTime(r["CreatedAt"]);
                string cat = r["Category"]?.ToString() ?? "";
                string img = r["ImageUrl"]?.ToString();

                litTitle.Text = Server.HtmlEncode(title);
                litTime.Text = created.ToString("HH'h'mm 'ngày' dd.MM.yyyy");

                // breadcrumb
                litBread.Text = (cat == "suc-khoe") ? "Sức khỏe và đời sống" : "Tin tức cửa hàng";

                // ảnh
                imgCover.ImageUrl = ResolveImg(img);

                // nội dung: hiển thị dạng text (giữ xuống dòng)
                litContent.Text = Server.HtmlEncode(content);

                ViewState["CurrentNewsId"] = id;
                ViewState["CurrentCategory"] = cat;

                SugPage = 1;
                BindSuggest();
            }
        }

        private void BindSuggest()
        {
            int currentId = ViewState["CurrentNewsId"] == null ? 0 : (int)ViewState["CurrentNewsId"];
            string cat = ViewState["CurrentCategory"]?.ToString() ?? "cua-hang";

            int offset = (SugPage - 1) * SugPageSize;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                DataTable dt = new DataTable();
                using (SqlCommand cmd = new SqlCommand(@"
                            SELECT Id, Title, ImageUrl, CreatedAt
                            FROM News
                            WHERE Category = @cat AND Id <> @currentId
                            ORDER BY CreatedAt DESC
                            OFFSET @offset ROWS FETCH NEXT @size ROWS ONLY;", conn))
                {
                    cmd.Parameters.AddWithValue("@cat", cat);
                    cmd.Parameters.AddWithValue("@currentId", currentId);
                    cmd.Parameters.AddWithValue("@offset", offset);
                    cmd.Parameters.AddWithValue("@size", SugPageSize);

                    new SqlDataAdapter(cmd).Fill(dt);
                }

                // nếu sang trang mà rỗng -> lùi lại 1 trang
                if (dt.Rows.Count == 0 && SugPage > 1)
                {
                    SugPage--;
                    BindSuggest();
                    return;
                }

                foreach (DataRow r in dt.Rows)
                {
                    r["ImageUrl"] = ResolveImg(r["ImageUrl"]?.ToString());
                }

                rptSuggest.DataSource = dt;
                rptSuggest.DataBind();

                // disable nút prev nếu đang trang 1
                btnSugPrev.Enabled = (SugPage > 1);
                btnSugPrev.CssClass = (SugPage > 1) ? "nav-btn" : "nav-btn opacity-50";
            }
        }

        protected void btnSugPrev_Click(object sender, EventArgs e)
        {
            if (SugPage > 1) SugPage--;
            BindSuggest();
        }

        protected void btnSugNext_Click(object sender, EventArgs e)
        {
            SugPage++;
            BindSuggest();
        }


        private string ResolveImg(string img)
        {
            if (string.IsNullOrWhiteSpace(img))
                img = "Images/download.png"; // đổi nếu ảnh bạn nằm Client/Images

            img = img.Trim().Replace("\\", "/");

            if (!img.StartsWith("~/") && !img.StartsWith("/"))
            {
                if (!img.Contains("/")) img = "Images/" + img;
                img = "~/" + img;
            }

            return ResolveUrl(img);
        }
    }
}