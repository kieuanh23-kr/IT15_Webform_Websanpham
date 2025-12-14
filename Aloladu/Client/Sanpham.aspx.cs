using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Aloladu.Client
{
    public partial class Sanpham : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBrandCarousel();
                LoadTopSelling();
                LoadBrandCarousel2();
                LoadBrandCarousel3();
                LoadTopDeals();
            }
        }

        private void LoadBrandCarousel()
        {
            // 1) Set brand cố định ở đây
            string brandName = "Sunhouse";
            litBrandName.Text = brandName;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 2) Queery 
                string sql = @"
                    SELECT TOP 12 Id, Name, Warranty, OldPrice, Price, ImageUrl, Description
                    FROM Products
                    WHERE BrandName = @b
                    ORDER BY Id DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@b", brandName);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // 3) ảnh mặc định nếu null
                foreach (DataRow r in dt.Rows)
                {
                    if (r["ImageUrl"] == DBNull.Value || string.IsNullOrWhiteSpace(r["ImageUrl"].ToString()))
                        r["ImageUrl"] = "Images/download.png";

                    if (r["Warranty"] == DBNull.Value)
                        r["Warranty"] = "";
                }

                rptBrandProducts.DataSource = dt;
                rptBrandProducts.DataBind();
            }
        }

        private void LoadBrandCarousel2()
        {
            // 1) Bạn set brand cố định ở đây
            string brandName = "Sunhouse";
            litBrandName2.Text = brandName;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 2) SỬA tên cột Brand cho đúng DB bạn (BrandName/Manufacturer/Brand...)
                string sql = @"
                    SELECT TOP 12 Id, Name, Warranty, OldPrice, Price, ImageUrl, Description
                    FROM Products
                    WHERE BrandName = @b
                    ORDER BY Id DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@b", brandName);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // 3) ảnh mặc định nếu null
                foreach (DataRow r in dt.Rows)
                {
                    if (r["ImageUrl"] == DBNull.Value || string.IsNullOrWhiteSpace(r["ImageUrl"].ToString()))
                        r["ImageUrl"] = "Images/download.png";

                    if (r["Warranty"] == DBNull.Value)
                        r["Warranty"] = "";
                }

                rptBrandProducts2.DataSource = dt;
                rptBrandProducts2.DataBind();
            }
        }

        private void LoadBrandCarousel3()
        {
            // 1) Bạn set brand cố định ở đây
            string brandName = "Sunhouse";
            litBrandName3.Text = brandName;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 2) SỬA tên cột Brand cho đúng DB bạn (BrandName/Manufacturer/Brand...)
                string sql = @"
            SELECT TOP 12 Id, Name, Warranty, OldPrice, Price, ImageUrl, Description
            FROM Products
            WHERE BrandName = @b
            ORDER BY Id DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@b", brandName);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // 3) ảnh mặc định nếu null
                foreach (DataRow r in dt.Rows)
                {
                    if (r["ImageUrl"] == DBNull.Value || string.IsNullOrWhiteSpace(r["ImageUrl"].ToString()))
                        r["ImageUrl"] = "Images/download.png";

                    if (r["Warranty"] == DBNull.Value)
                        r["Warranty"] = "";
                }

                rptBrandProducts3.DataSource = dt;
                rptBrandProducts3.DataBind();
            }
        }

        public string FormatMoney(object value)
        {
            if (value == null || value == DBNull.Value) return "";
            if (decimal.TryParse(value.ToString(), out var money))
                return money.ToString("#,0").Replace(",", ".");
            return value.ToString();
        }


        private void LoadTopSelling()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT TOP 5 Id, Name, Warranty, OldPrice, Price, ImageUrl, Description
                    FROM Products
                    ORDER BY Id DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                foreach (DataRow r in dt.Rows)
                {
                    if (r["ImageUrl"] == DBNull.Value || string.IsNullOrWhiteSpace(r["ImageUrl"].ToString()))
                        r["ImageUrl"] = "Images/download.png";

                    if (r["Warranty"] == DBNull.Value)
                        r["Warranty"] = "";
                }

                rptTopSelling.DataSource = dt;
                rptTopSelling.DataBind();
            }
        }

        private void LoadTopDeals()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT TOP 5 Id, Name, Warranty, OldPrice, Price, ImageUrl, Description
                    FROM Products
                    ORDER BY Id DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                foreach (DataRow r in dt.Rows)
                {
                    if (r["ImageUrl"] == DBNull.Value || string.IsNullOrWhiteSpace(r["ImageUrl"].ToString()))
                        r["ImageUrl"] = "Images/download.png";

                    if (r["Warranty"] == DBNull.Value)
                        r["Warranty"] = "";
                }

                rptTopDeals.DataSource = dt;
                rptTopDeals.DataBind();
            }
        }

    }
}
