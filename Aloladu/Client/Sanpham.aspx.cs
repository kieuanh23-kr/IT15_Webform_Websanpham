using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace Aloladu.Client
{
    public partial class Sanpham : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private const int BrandPageSize = 5; 

        private int BrandPage1 { get => GetPage("b1"); set => SetPage("b1", value); }
        private int BrandPage2 { get => GetPage("b2"); set => SetPage("b2", value); }
        private int BrandPage3 { get => GetPage("b3"); set => SetPage("b3", value); }

        private int GetPage(string key) => ViewState["BrandPage_" + key] == null ? 1 : (int)ViewState["BrandPage_" + key];
        private void SetPage(string key, int value) => ViewState["BrandPage_" + key] = value < 1 ? 1 : value;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BrandPage1 = 1;
                BrandPage2 = 1;
                BrandPage3 = 1;

                // Đổi tên brand muốn hiển thị
                BindBrand("Sunhouse", BrandPage1, rptBrandProducts, btnPrevBrand1, btnNextBrand1, litBrandName);
                BindBrand("Lock&Lock", BrandPage2, rptBrandProducts2, btnPrevBrand2, btnNextBrand2, litBrandName2);
                BindBrand("Panasonic", BrandPage3, rptBrandProducts3, btnPrevBrand3, btnNextBrand3, litBrandName3);

                LoadTopSelling();
                LoadTopDeals();
            }
        }

        private void BindBrand(string brandName, int page, Repeater rpt, LinkButton btnPrev, LinkButton btnNext, Literal lit)
        {
            lit.Text = brandName;

            int offset = (page - 1) * BrandPageSize;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Tổng số sp của brand
                int total = 0;
                using (SqlCommand ccmd = new SqlCommand("SELECT COUNT(1) FROM Products WHERE BrandName = @b", conn))
                {
                    ccmd.Parameters.AddWithValue("@b", brandName);
                    total = Convert.ToInt32(ccmd.ExecuteScalar());
                }

                int maxPage = Math.Max(1, (int)Math.Ceiling(total * 1.0 / BrandPageSize));
                if (page > maxPage)
                {
                    page = maxPage;
                    offset = (page - 1) * BrandPageSize;

                    // update lại viewstate tương ứng
                    if (rpt.ID == "rptBrandProducts") BrandPage1 = page;
                    else if (rpt.ID == "rptBrandProducts2") BrandPage2 = page;
                    else if (rpt.ID == "rptBrandProducts3") BrandPage3 = page;
                }

                string sql = @"
                    SELECT Proc_ID, Proc_Name, Proc_Cat, Proc_Brand, Proc_Price, Proc_Quan, 
                        Proc_OldPrice,Proc_Image,Proc_Des
                        FROM vw_Products
                        WHERE Proc_Brand = @b
                        ORDER BY Proc_ID DESC
                        OFFSET @offset ROWS FETCH NEXT @size ROWS ONLY;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@b", brandName);
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@size", BrandPageSize);

                DataTable dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                // Fix ảnh fallback
                foreach (DataRow r in dt.Rows)
                {
                    string img = r["Proc_Image"] == DBNull.Value ? "" : r["Proc_Image"].ToString();
                    if (string.IsNullOrWhiteSpace(img))
                    {
                        img = "download.png";
                    }
                    else
                    {
                        img = System.IO.Path.GetFileName(img);
                    }
                    r["Proc_Image"] = ResolveUrl("~/Images/" + img);
                }

                rpt.DataSource = dt;
                rpt.DataBind();

                // Enable/disable nút theo biên
                btnPrev.Enabled = page > 1;
                btnNext.Enabled = page < maxPage;

                btnPrev.CssClass = btnPrev.Enabled ? "brand-btn" : "brand-btn disabled";
                btnNext.CssClass = btnNext.Enabled ? "brand-btn" : "brand-btn disabled";
            }
        }

        // ===== Events brand 1 =====
        protected void btnPrevBrand1_Click(object sender, EventArgs e)
        {
            BrandPage1--;
            BindBrand("Sunhouse", BrandPage1, rptBrandProducts, btnPrevBrand1, btnNextBrand1, litBrandName);
        }
        protected void btnNextBrand1_Click(object sender, EventArgs e)
        {
            BrandPage1++;
            BindBrand("Sunhouse", BrandPage1, rptBrandProducts, btnPrevBrand1, btnNextBrand1, litBrandName);
        }

        // ===== Events brand 2 =====
        protected void btnPrevBrand2_Click(object sender, EventArgs e)
        {
            BrandPage2--;
            BindBrand("Lock&Lock", BrandPage2, rptBrandProducts2, btnPrevBrand2, btnNextBrand2, litBrandName2);
        }
        protected void btnNextBrand2_Click(object sender, EventArgs e)
        {
            BrandPage2++;
            BindBrand("Lock&Lock", BrandPage2, rptBrandProducts2, btnPrevBrand2, btnNextBrand2, litBrandName2);
        }

        // ===== Events brand 3 =====
        protected void btnPrevBrand3_Click(object sender, EventArgs e)
        {
            BrandPage3--;
            BindBrand("Panasonic", BrandPage3, rptBrandProducts3, btnPrevBrand3, btnNextBrand3, litBrandName3);
        }
        protected void btnNextBrand3_Click(object sender, EventArgs e)
        {
            BrandPage3++;
            BindBrand("Panasonic", BrandPage3, rptBrandProducts3, btnPrevBrand3, btnNextBrand3, litBrandName3);
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
                    SELECT TOP 5 Proc_ID, Proc_Name, Proc_Cat, Proc_Brand, Proc_Price, Proc_Quan, 
                        Proc_OldPrice,Proc_Image,Proc_Des
                        FROM vw_Products
                        ORDER BY Proc_Quan DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                foreach (DataRow r in dt.Rows)
                {
                    string img = r["Proc_Image"] == DBNull.Value ? "" : r["Proc_Image"].ToString();
                    if (string.IsNullOrWhiteSpace(img))
                    {
                        img = "download.png";
                    }
                    else
                    {
                        img = System.IO.Path.GetFileName(img);
                    }
                    r["Proc_Image"] = ResolveUrl("~/Images/" + img);
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
            SELECT TOP 5 5 Proc_ID, Proc_Name, Proc_Cat, Proc_Brand, Proc_Price, Proc_Quan, 
                        Proc_OldPrice,Proc_Image,Proc_Des,Proc_Sale
                        FROM vw_Products
            ORDER BY Proc_Sale DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                foreach (DataRow r in dt.Rows)
                {
                    string img = r["Proc_Image"] == DBNull.Value ? "" : r["Proc_Image"].ToString();
                    if (string.IsNullOrWhiteSpace(img))
                    {
                        img = "download.png";
                    }
                    else
                    {
                        img = System.IO.Path.GetFileName(img);
                    }
                    r["Proc_Image"] = ResolveUrl("~/Images/" + img);
                }

                rptTopDeals.DataSource = dt;
                rptTopDeals.DataBind();
            }
        }
    }
}
