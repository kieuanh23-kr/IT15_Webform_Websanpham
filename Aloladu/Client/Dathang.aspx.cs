using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Security.Policy;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Client
{
    public partial class Dathang : System.Web.UI.Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private int CurrentProductId
        {
            get => (ViewState["CurrentProductId"] == null) ? 0 : (int)ViewState["CurrentProductId"];
            set => ViewState["CurrentProductId"] = value;
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("Dangnhap.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int productId;
                if (!int.TryParse(Request.QueryString["productId"], out productId))
                {
                    // Không có id => quay về trang sản phẩm
                    Response.Redirect("Sanpham.aspx");
                    return;
                }

                CurrentProductId = productId;

                LoadProduct(productId);
            }
        }

        private void LoadProduct(int id)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
              
                string sql = @"
                    SELECT TOP 1
                        Id, Name, CategoryKey, BrandName,
                        OldPrice, Price, ImageUrl,Description
                    FROM Products
                    WHERE Id = @id"; 

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", id);

                string sqlCustomer = @"SELECT TOP 1 FullName, Phone, CCCD, Email, Address, BirthDate, Gender
                        FROM Customers
                        WHERE Id = @id;";
                SqlCommand sqlCommand = new SqlCommand(sqlCustomer, conn);
                sqlCommand.Parameters.AddWithValue("@id", Convert.ToInt32(Session["CustomerId"]));

                conn.Open();
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        Response.Redirect("Sanpham.aspx");
                        return;
                    }

                    string name = rd["Name"]?.ToString() ?? "";
                    string cat = rd["CategoryKey"]?.ToString() ?? "";
                    string brand = rd["BrandName"]?.ToString() ?? "";
                    string desc = rd["Description"]?.ToString() ?? "";
                    string img = rd["ImageUrl"]?.ToString();


                    decimal oldP = rd["OldPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(rd["OldPrice"]);
                    decimal price = rd["Price"] == DBNull.Value ? 0 : Convert.ToDecimal(rd["Price"]);
                    int sold = 12;//rd["SoldCount"] == DBNull.Value ? 0 : Convert.ToInt32(rd["SoldCount"]);

                    litName.Text = name;
                    litCategory.Text = MapCatToName(cat);   // DB bạn đang lưu tiếng Việt luôn (Đồ bếp...)
                    litBrand.Text = brand;
                    litDesc.Text = desc;

                    litOldPrice.Text = oldP > 0 ? FormatMoney(oldP) : "";
                    litPrice.Text = FormatMoney(price);

                    imgProduct.ImageUrl = ToWebImageUrl(img);

                    hdPrice.Value = ((decimal)price).ToString(); // hoặc price.ToString("0") nếu decimal
                    txtTotal.Text = FormatMoney(price);      // mặc định qty=1


                }
                using (SqlDataReader rd = sqlCommand.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        txtName.Text = rd["FullName"]?.ToString() ?? "";
                        txtPhone.Text = rd["Phone"]?.ToString() ?? "";
                        txtAddress.Text = rd["Address"] == DBNull.Value ? "" : rd["Address"].ToString();
                    }
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtName.Text = "";
            txtPhone.Text = "";
            txtAddress.Text = "";
            txtNote.Text = "";
            txtQuantity.Text = "1";

            // cập nhật tổng theo qty=1
            if (int.TryParse(hdPrice.Value, out int p))
                txtTotal.Text = FormatMoney(p);

            lblMsg.Text = "";
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            lblMsg.CssClass = "d-block mt-2 text-danger";
            lblMsg.Text = "";

            string receiver = (txtName.Text ?? "").Trim();
            string phone = (txtPhone.Text ?? "").Trim();
            string address = (txtAddress.Text ?? "").Trim();
            string note = (txtNote.Text ?? "").Trim();

            if (!int.TryParse(txtQuantity.Text, out int qty) || qty < 1)
                qty = 1;

            if (CurrentProductId <= 0)
            {
                lblMsg.Text = "Không tìm thấy sản phẩm để đặt hàng.";
                return;
            }

            if (receiver.Length == 0 || phone.Length == 0 || address.Length == 0)
            {
                lblMsg.Text = "Vui lòng nhập đầy đủ: Người nhận, SĐT, Địa chỉ.";
                return;
            }

            // lấy giá thật từ HiddenField
            if (!decimal.TryParse(hdPrice.Value, out decimal unitPrice) || unitPrice < 0)
            {
                lblMsg.Text = "Giá sản phẩm không hợp lệ.";
                return;
            }

            decimal total = unitPrice * qty;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string sql = @"
                INSERT INTO Orders
                (ProductId, ReceiverName, Phone, Address, Quantity, UnitPrice, TotalAmount, PaymentMethod, Note, Status, CreatedAt,Customers_ID)
                VALUES
                (@ProductId, @ReceiverName, @Phone, @Address, @Quantity, @UnitPrice, @TotalAmount, @PaymentMethod, @Note, @Status, @CreatedAt,@Custemers_ID)";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ProductId", CurrentProductId);
                        cmd.Parameters.AddWithValue("@ReceiverName", receiver);
                        cmd.Parameters.AddWithValue("@Phone", phone);
                        cmd.Parameters.AddWithValue("@Address", address);
                        cmd.Parameters.AddWithValue("@Quantity", qty);
                        cmd.Parameters.AddWithValue("@UnitPrice", unitPrice);
                        cmd.Parameters.AddWithValue("@TotalAmount", total);
                        cmd.Parameters.AddWithValue("@PaymentMethod", "Ship COD");
                        cmd.Parameters.AddWithValue("@Note", note);
                        cmd.Parameters.AddWithValue("@Status", "Chờ xử lý");
                        cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                        cmd.Parameters.AddWithValue("@Custemers_ID", Convert.ToInt32(Session["CustomerId"]));

                        cmd.ExecuteNonQuery();
                    }
                }

                lblMsg.CssClass = "d-block mt-2 text-success";
                lblMsg.Text = "Đặt hàng thành công!";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Lỗi khi đặt hàng: " + ex.Message;
            }
        }



        private string ToWebImageUrl(string img)
        {
            if (string.IsNullOrWhiteSpace(img))
            { 
                img = "download.png"; 
            }

            else
            {
                img = System.IO.Path.GetFileName(img);
            }
            return ResolveUrl("~/Images/" + img);
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

        private string FormatMoney(decimal money)
        {
            return money.ToString("#,0").Replace(",", ".");
        }
    }
}