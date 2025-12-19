using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Aloladu.Client
{
    public partial class Category : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private const int PageSize = 15; // 5 cột x 3 hàng
        private int CurrentPage
        {
            get => (ViewState["CurrentPage"] == null) ? 1 : (int)ViewState["CurrentPage"];
            set => ViewState["CurrentPage"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CurrentPage = 1;

                string cat = GetCat();
                litCatName.Text = MapCatToName(cat);

                LoadBrandDropdown(cat);
                BindProducts();
            }
        }

        private string GetCat()
        {
            return (Request.QueryString["cat"] ?? "").Trim().ToLower();
        }

        private string MapCatToName(string cat)
        {
            // mapping theo category card 
            switch (cat)
            {
                case "dobep": return "Đồ bếp";
                case "donha": return "Dọn nhà";
                case "saykho": return "Sấy khô";
                case "dongho": return "Đồng hồ";
                case "bongden": return "Bóng đèn";
                case "giatla": return "Giặt là";
                default: return "Tất cả";
            }
        }

        private void LoadBrandDropdown(string cat)
        {
            ddlBrand.Items.Clear();
            ddlBrand.Items.Add(new System.Web.UI.WebControls.ListItem("Tất cả", "all"));

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT DISTINCT BrandName
                    FROM Products
                    WHERE (@cat = '' OR CategoryKey = @cat)
                    ORDER BY BrandName";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cat", cat);

                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                while (rd.Read())
                {
                    string b = rd["BrandName"]?.ToString();
                    if (!string.IsNullOrWhiteSpace(b))
                        ddlBrand.Items.Add(new System.Web.UI.WebControls.ListItem(b, b));
                }
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            BindProducts();
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1) CurrentPage--;
            BindProducts();
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            BindProducts();
        }

        private void BindProducts()
        {
            string cat = GetCat();
            string brand = ddlBrand.SelectedValue;
            string priceSort = ddlPrice.SelectedValue;

            // sort theo giá
            string orderBy = "ORDER BY NEWID()"; // ngẫu nhiên
            if (priceSort == "asc") orderBy = "ORDER BY Price ASC";
            if (priceSort == "desc") orderBy = "ORDER BY Price DESC";

            int offset = (CurrentPage - 1) * PageSize;
            int totalProducts = 0;
            int totalPages = 1;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open(); // Mở connection 1 lần duy nhất

                // Đếm tổng số sản phẩm
                string countSql = @"
                        SELECT COUNT(*)
                        FROM Products
                        WHERE (@cat = '' OR CategoryKey = @cat)
                          AND (@brand = 'all' OR BrandName = @brand)";

                SqlCommand countCmd = new SqlCommand(countSql, conn);
                countCmd.Parameters.AddWithValue("@cat", cat);
                countCmd.Parameters.AddWithValue("@brand", brand);

                totalProducts = (int)countCmd.ExecuteScalar();
                totalPages = (int)Math.Ceiling((double)totalProducts / PageSize);


                string sql = $@"
                        SELECT Id, Name, Description, OldPrice, Price, ImageUrl
                        FROM Products
                        WHERE (@cat = '' OR CategoryKey = @cat)
                          AND (@brand = 'all' OR BrandName = @brand)
                        {orderBy}
                        OFFSET @offset ROWS FETCH NEXT @size ROWS ONLY;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cat", cat);
                cmd.Parameters.AddWithValue("@brand", brand);
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@size", PageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                foreach (DataRow r in dt.Rows)
                {
                    string img = r["ImageUrl"] == DBNull.Value ? "" : r["ImageUrl"].ToString();
                    if (string.IsNullOrWhiteSpace(img))
                    {
                        img = "download.png";
                    }
                    else
                    {
                        img = System.IO.Path.GetFileName(img);
                    }
                    r["ImageUrl"] = ResolveUrl("~/Images/" + img);
                }

                rptCatProducts.DataSource = dt;
                rptCatProducts.DataBind();

                // nếu trang hiện tại không có dữ liệu => quay lại 1 trang
                if (dt.Rows.Count == 0 && CurrentPage > 1)
                {
                    CurrentPage--;
                    BindProducts();
                    return;
                }

                // Cập nhật trạng thái button Prev
                btnPrev.Enabled = CurrentPage > 1;
                btnPrev.CssClass = CurrentPage > 1 ? "nav-btn" : "nav-btn disabled";

                // Cập nhật trạng thái button Next
                btnNext.Enabled = CurrentPage < totalPages;
                btnNext.CssClass = CurrentPage < totalPages ? "nav-btn" : "nav-btn disabled";
            }


        }

        public string FormatMoney(object value)
        {
            if (value == null || value == DBNull.Value) return "";
            if (decimal.TryParse(value.ToString(), out var money))
                return money.ToString("#,0").Replace(",", ".");
            return value.ToString();
        }


    }
}
