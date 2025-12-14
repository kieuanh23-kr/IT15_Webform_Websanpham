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
    }
}