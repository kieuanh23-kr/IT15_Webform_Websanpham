using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Client
{
    public partial class ClientMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] != null && Session["CustomerName"] != null)
            {
                lblGreeting.Text = "Xin chào </br>" + Session["CustomerName"].ToString() + "!";
                lblGreeting.Visible = true;
            }
            else
            {
                lblGreeting.Visible = false;
            }

        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if(Session["CustomerId"] != null)
            {
                Response.Redirect("Taikhoan.aspx");
            }
            else
            {
                Response.Redirect("Dangnhap.aspx");
            }
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string q = (txtSearch.Text ?? "").Trim();
            Response.Redirect(ResolveUrl("~/Client/Timkiem.aspx?q=" + Server.UrlEncode(q)));
        }

    }
}