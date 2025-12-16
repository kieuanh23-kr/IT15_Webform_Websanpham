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
    public partial class Donhang : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private const int PageSize = 10;

        private int CurrentPage
        {
            get => (ViewState["CurrentPage"] == null) ? 1 : (int)ViewState["CurrentPage"];
            set => ViewState["CurrentPage"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if(Session["CustomerId"] == null)
                {
                    pnDangnhap.Visible=true;
                    return;
                }
                CurrentPage = 1;
                LoadFilterDropdowns();
                BindOrders();
            }
        }

        private void LoadFilterDropdowns()
        {
            // Brand
            ddlBrand.Items.Clear();
            ddlBrand.Items.Add(new ListItem("Tất cả", "all"));

            // Category
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("Tất cả", "all"));

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // lấy danh sách hãng (từ Products)
                using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT BrandName FROM Products WHERE BrandName IS NOT NULL ORDER BY BrandName", conn))
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        var b = rd[0]?.ToString();
                        if (!string.IsNullOrWhiteSpace(b)) {
                            
                            ddlBrand.Items.Add(new ListItem(b, b)); }
                    }
                }

                // lấy danh sách phân loại (CategoryKey của bạn đang lưu tiếng Việt)
                using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT CategoryKey FROM Products WHERE CategoryKey IS NOT NULL ORDER BY CategoryKey", conn))
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        var c = rd[0]?.ToString();
                        if (!string.IsNullOrWhiteSpace(c))
                        {
                            string catName = MapCatToName(c);
                            ddlCategory.Items.Add(new ListItem(catName, c));
                        }
                    }
                }
            }
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

        protected void FilterChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            BindOrders();
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1) CurrentPage--;
            BindOrders();
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            BindOrders();
        }

        private void BindOrders()
        {
            string status = ddlStatus.SelectedValue;
            string brand = ddlBrand.SelectedValue;
            string cat = ddlCategory.SelectedValue;
            int customerId = Convert.ToInt32(Session["CustomerId"]);

            int offset = (CurrentPage - 1) * PageSize;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // ⚠️ Nếu tên cột khác: sửa lại theo DB bạn
                // Orders: ProductId, Quantity, TotalAmount, Status, CreatedAt
                // Products: Name, BrandName, CategoryKey, Warranty, OldPrice, Price, ImageUrl
                string sql = @"
                                SELECT
                                    o.Id,
                                    o.Status,
                                    o.CreatedAt,
                                    o.Quantity,
                                    o.TotalAmount,

                                    p.Name        AS ProductName,
                                    p.BrandName,
                                    p.CategoryKey,
                                    p.Warranty,
                                    p.OldPrice,
                                    p.Price,
                                    p.ImageUrl,
                                    p.Description
                                FROM Orders o
                                JOIN Products p ON o.ProductId = p.Id
                                WHERE o.Customers_ID = @customerId
                                  AND(@status = 'all' OR o.Status = @status)
                                  AND (@brand  = 'all' OR p.BrandName = @brand)
                                  AND (@cat    = 'all' OR LTRIM(RTRIM(p.CategoryKey)) = @cat)
                                ORDER BY o.CreatedAt DESC
                                OFFSET @offset ROWS FETCH NEXT @size ROWS ONLY;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@status", status);
                cmd.Parameters.AddWithValue("@brand", brand);
                cmd.Parameters.AddWithValue("@cat", cat);
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@size", PageSize);
                cmd.Parameters.AddWithValue("@customerId", customerId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // nếu trang hiện tại không có dữ liệu -> lùi 1 trang
                if (dt.Rows.Count == 0 && CurrentPage > 1)
                {
                    CurrentPage--;
                    BindOrders();
                    return;
                }

                // bổ sung các cột hiển thị
                dt.Columns.Add("CreatedText", typeof(string));
                dt.Columns.Add("OldPriceText", typeof(string));
                dt.Columns.Add("PriceText", typeof(string));
                dt.Columns.Add("TotalText", typeof(string));
                dt.Columns.Add("StatusClass", typeof(string));
                dt.Columns.Add("ImageUrlFixed", typeof(string));

                foreach (DataRow r in dt.Rows)
                {
                    // format ngày
                    var created = r["CreatedAt"] == DBNull.Value ? DateTime.Now : Convert.ToDateTime(r["CreatedAt"]);
                    r["CreatedText"] = created.ToString("HH'h'mm dd/MM/yyyy");

                    //format Category
                    string catKey = r["CategoryKey"]?.ToString() ?? "";
                    r["CategoryKey"] = MapCatToName(catKey);

                    // format tiền
                    decimal oldP = r["OldPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(r["OldPrice"]);
                    decimal price = r["Price"] == DBNull.Value ? 0 : Convert.ToDecimal(r["Price"]);
                    decimal total = r["TotalAmount"] == DBNull.Value ? 0 : Convert.ToDecimal(r["TotalAmount"]);

                    r["OldPriceText"] = oldP > 0 ? FormatMoney(oldP) : "";
                    r["PriceText"] = FormatMoney(price);
                    r["TotalText"] = FormatMoney(total);

                    // class theo status
                    string st = r["Status"]?.ToString() ?? "";
                    r["StatusClass"] = StatusToClass(st);

                    // ảnh
                    string img = r["ImageUrl"]?.ToString();
                    if (string.IsNullOrWhiteSpace(img))
                        img = "Client/Images/download.png"; // ✅ đúng folder hiện tại của bạn

                    img = img.Trim().Replace("\\", "/");

                    if (!img.StartsWith("~/") && !img.StartsWith("/"))
                    {
                        if (!img.Contains("/")) img = "Client/Images/" + img; // nếu db chỉ lưu tên file
                        img = "~/" + img;
                    }
                    r["ImageUrl"] = ResolveUrl(img);
                }

                pnEmpty.Visible = dt.Rows.Count == 0;
                rptOrders.DataSource = dt;
                rptOrders.DataBind();

                btnPrev.CssClass = CurrentPage > 1 ? "nav-btn" : "nav-btn opacity-50";
            }
        }

        private string StatusToClass(string st)
        {
            switch (st)
            {
                case "Chờ xử lý": return "st-wait";
                case "Chuẩn bị giao": return "st-prep";
                case "Đang giao": return "st-ship";
                case "Hoàn thành": return "st-done";
                default: return "st-wait";
            }
        }

        private string FormatMoney(decimal money)
        {
            return money.ToString("#,0").Replace(",", ".");
        }
    }
}