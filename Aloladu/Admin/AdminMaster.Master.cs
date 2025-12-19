using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Admin
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           if(!IsPostBack){
               SetActiveMenu();
           }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Dangnhap.aspx");
        }

        private void SetActiveMenu()
        {
            string page = System.IO.Path.GetFileName(Request.Url.AbsolutePath);

            // reset
            navProc.Attributes["class"] = "nav-item";
            navOrders.Attributes["class"] = "nav-item";
            navNews.Attributes["class"] = "nav-item";
            end.Attributes["class"] = "nav-item";
            navNStore.Attributes["class"] = "sub-item-1";
            navNHealth.Attributes["class"] = "sub-item-2";
            navNRec.Attributes["class"] = "sub-item";

            switch (page)
            {
                case "Donhang.aspx":
                case "DonhangChitiet.aspx":
                    navOrders.Attributes["class"] += " active";
                    break;
                case "Khachhang.aspx":
                case "KhachhangChitiet.aspx":
                    end.Attributes["class"] += " active";
                    break;
                case "Sanpham.aspx":
                case "SanphamChitiet.aspx":
                    navProc.Attributes["class"] += " active";
                    break;
                case "TintucCuahang.aspx":
                case "TintucCuahangChitiet.aspx":
                    navNews.Attributes["class"] += " active";
                    navNStore.Attributes["class"] += " active";
                    break;
                case "TintucSuckhoe.aspx":
                case "TintucSuckhoeChitiet.aspx":
                    navNHealth.Attributes["class"] += " active";
                    navNews.Attributes["class"] += " active";
                    break;
                case "TintucTuyendung.aspx":
                    navNews.Attributes["class"] += " active";
                    navNRec.Attributes["class"] += " active";
                    break;
                
            }
        }
    }
}