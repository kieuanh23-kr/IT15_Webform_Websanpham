using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Aloladu.Admin
{
    public partial class TintucTuyendungChitiet : System.Web.UI.Page
    {
        private readonly string connStr =
          ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private int RecID
        {
            get
            {
                int.TryParse(Request.QueryString["id"], out int id);
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (!IsPostBack)
            {
                LoadRec();
            }
        }

        private void LoadRec()
        {
            if (RecID <= 0)
            {
                btnUpdate.Text = "Thêm mới";
                btnDelete.Visible = false;
                RecTitle.InnerText = "TIN TỨC > TUYỂN DỤNG >THÊM MỚI";
                return;
            }
            const string sql = @"
                SELECT 
                  Rec_ID, Rec_Pos, Rec_DL, Rec_Type, Rec_Time, Rec_Desc,Rec_Sal,Rec_Address,Rec_Create
                FROM vw_News_Rec
                WHERE Rec_ID = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", RecID);
                conn.Open();

                using (var rd = cmd.ExecuteReader())
                {
                    if (!rd.Read())
                    {
                        ShowMsg("Không tìm thấy tin tức nào.", "red");
                        DisableActions();
                        return;
                    }

                    txtRecID.Text = rd["Rec_ID"].ToString();
                    txtRecPos.Text = rd["Rec_Pos"]?.ToString();
                    txtRecSal.Text = rd["Rec_Sal"]?.ToString();
                    txtRecTime.Text = rd["Rec_Time"]?.ToString();
                    txtRecAddress.Text = rd["Rec_Address"]?.ToString();
                    txtRecDesc.Text = rd["Rec_Desc"]?.ToString();
                    txtRecType.Text = rd["Rec_Type"]?.ToString();

                    if (rd["Rec_DL"] != DBNull.Value)
                    {
                        var deadline = Convert.ToDateTime(rd["Rec_DL"]);
                        txtRecDL.Text = deadline.ToString("yyyy-MM-ddTHH:mm");
                    }
                }
            }
        }

       

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("TintucTuyendung.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            DateTime recDL;
            if (!DateTime.TryParse(txtRecDL.Text, out recDL))
            {
                lblMsg.Text = "Ngày hạn nộp không hợp lệ. Vui lòng nhập đúng định dạng ngày.";
                lblMsg.Visible = true;
                return;
            }

            if (RecID <= 0) {

                const string sqlInsert = @"INSERT INTO Recruitments (Position, CvDeadline, Salary, WorkType, WorkingTime, JobDescription, Location)
                                        VALUES (@Rec_Pos,@Rec_DL,@Rec_Sal,@Rec_Type,@Rec_Time,@Rec_Desc,@Rec_Address)";

                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand(sqlInsert, conn))
                {
                    cmd.Parameters.AddWithValue("@Rec_Pos", (txtRecPos.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Rec_Time", (txtRecTime.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Rec_Sal", (txtRecSal.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Rec_Type", (txtRecType.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Rec_Desc", (txtRecDesc.Text ?? "").Trim());
                    cmd.Parameters.AddWithValue("@Rec_Address", (txtRecAddress.Text ?? "").Trim());

                    
                    cmd.Parameters.AddWithValue("@Rec_DL", recDL);

                    conn.Open();
                    int n = cmd.ExecuteNonQuery();
                    if (n <= 0)
                    {
                        ShowMsg("Thêm tin tuyển dụng thất bại", "red");
                        return;
                    }
                    else
                    {
                        ShowMsg("Thêm tin tuyển dụng thành công!", "green");
                    }
                }
                return;
            }

            const string sql = @"UPDATE Recruitments 
                                        SET Position = @Rec_Pos, CvDeadline=@Rec_DL, Salary=@Rec_Sal, WorkType=@Rec_Type, WorkingTime=@Rec_Time, 
                                        JobDescription=@Rec_Desc, Location=@Rec_Address WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Rec_Pos", (txtRecPos.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Rec_DL", (txtRecDL.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Rec_Sal", (txtRecSal.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Rec_Type", (txtRecType.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Rec_Time", (txtRecTime.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Rec_Desc", (txtRecDesc.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@Rec_Address", (txtRecAddress.Text ?? "").Trim());
                cmd.Parameters.AddWithValue("@id", RecID);

                conn.Open();
                int n = cmd.ExecuteNonQuery();
                if (n <= 0)
                {
                    ShowMsg("Cập nhật thất bại (không tìm thấy tin tức).", "red");
                    return;
                }
            }

            LoadRec();
            ShowMsg("Cập nhật thành công!", "green");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            lblMsg.Visible = false;

            if (RecID <= 0) { ShowMsg("Mã tin không hợp lệ.", "red"); return; }

            const string sql = @"DELETE FROM Recruitments WHERE Id = @id";

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@id", RecID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("TintucTuyendung.aspx");
        }

        private void ShowMsg(string msg, string color)
        {
            lblMsg.Text = msg;
            lblMsg.Visible = true;
            lblMsg.ForeColor = Color.FromName(color);
        }

        private void DisableActions()
        {
            btnUpdate.Enabled = false;
            btnDelete.Enabled = false;
        }
    }
}