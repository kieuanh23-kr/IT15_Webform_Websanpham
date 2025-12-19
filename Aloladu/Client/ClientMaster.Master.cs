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
            if(!IsPostBack){
                SetActiveMenu();
            }
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
        private void SetActiveMenu()
        {
            string page = System.IO.Path.GetFileName(Request.Url.AbsolutePath);

            // reset
            navProc.Attributes["class"] = "nav-link text-black";
            navNews.Attributes["class"] = "nav-link text-black";
            navOrders.Attributes["class"] = "nav-link text-black";
            navUs.Attributes["class"] = "nav-link text-black";

            switch (page)
            {
                case "Sanpham.aspx":
                    navProc.Attributes["class"] += " active";
                    break;
                case "Category.aspx":   
                    navProc.Attributes["class"] += " active";
                    break;
                case "Dathang.aspx":
                    navProc.Attributes["class"] += " active";
                    break;
                case "Donhang.aspx":
                    navOrders.Attributes["class"] += " active";
                    break;
                case "Tintuc.aspx":
                    navNews.Attributes["class"] += " active";
                    break;
                case "TintucChitiet.aspx":
                    navNews.Attributes["class"] += " active";
                    break;
                case "TintucTuyendung.aspx":
                    navNews.Attributes["class"] += " active";
                    break;
                case "Vechungtoi.aspx":
                    navUs.Attributes["class"] += " active";
                    break;
            }
        }


    }
}