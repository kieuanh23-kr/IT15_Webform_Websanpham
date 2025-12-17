using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Admin
{
    public partial class Dangnhap : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Nếu đã đăng nhập rồi thì vào thẳng Dashboard
            if (Session["ADMIN_AUTH"] != null && (bool)Session["ADMIN_AUTH"] == true)
            {
                Response.Redirect("~/Admin/Dashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            string user = (txtUser.Text ?? "").Trim();
            string pass = (txtPass.Text ?? "").Trim();

            string adminUser = ConfigurationManager.AppSettings["AdminUser"];
            string adminPass = ConfigurationManager.AppSettings["AdminPass"];

            if (user == adminUser && pass == adminPass)
            {
                Session["ADMIN_AUTH"] = true;
                Session["ADMIN_USER"] = user;

                Response.Redirect("~/Admin/Dashboard.aspx");
            }
            else
            {
                lblMsg.Text = "Sai tên đăng nhập hoặc mật khẩu!";
                lblMsg.Visible = true;
            }
        }
    }
}