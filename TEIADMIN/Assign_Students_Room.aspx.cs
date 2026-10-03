using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib_AD;
using System.Data;

public partial class Assign_Students_Room : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bind_grd();
            bind_ddr();
            HiddenField1.Value = "0";
        }
    }
    private void bind_ddr()
    {
        DataTable dt = RoomsDAL.GetAll();
        if (dt.Rows.Count > 0)
        {
            ddr_rooms.DataSource = dt;
            ddr_rooms.DataTextField = "room_no";
            ddr_rooms.DataValueField = "room_id";
            ddr_rooms.DataBind();
            //  ddr_rooms.Items.Insert(0, new ListItem("اختر...", "0"));


        }
    }

    private void bind_insert_ddr()
    {
        DataTable dt = RoomsDAL.GetAll();
        if (dt.Rows.Count > 0)
        {
            ddr_rooms_no.DataSource = dt;
            ddr_rooms_no.DataTextField = "room_no";
            ddr_rooms_no.DataValueField = "room_id";
            ddr_rooms_no.DataBind();
            // ddr_rooms_no.Items.Insert(0, new ListItem("اختر...", "0"));
        }

        DataTable dt1 = TeiLib.SemestersDAL.GetAll();
        {
            ddr_sym.DataSource = dt1;
            ddr_sym.DataTextField = "ArSemesterName";
            ddr_sym.DataValueField = "semesterid";
            ddr_sym.DataBind();
            //    ddr_sym.Items.Insert(0, new ListItem( "اختر...", "0"));


        }
    }
    private void bind_grd()
    {
        DataTable dt = Students_RoomsDAL.Get_all_student_rooms(int.Parse(ddr_rooms.SelectedItem.Value), txtStudentCode.Text);
        if (dt.Rows.Count > 0)
        {
            grd_stu_rooms.DataSource = dt;
            grd_stu_rooms.DataBind();
        }
        else
        {
            grd_stu_rooms.DataSource = null;
            grd_stu_rooms.DataBind();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        bind_grd();
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        bind_insert_ddr();
        PageView.ActiveViewIndex = 1;
    }
    protected void TextBox1_TextChanged(object sender, EventArgs e)
    {
        DataTable dt = TeiLib.StudentsDAL.GetByCode(TextBox1.Text);
        if (dt.Rows.Count > 0)
        {
            ViewState["Student_Id"] = dt.Rows[0][0].ToString();
            lbl_student_name.Text = dt.Rows[0][5].ToString();
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (HiddenField1.Value == "0")
        {
            DataTable Dt = Students_RoomsDAL.check_duplicate_room(int.Parse(ViewState["Student_Id"].ToString()), int.Parse(ddr_sym.SelectedItem.Value));
            if (Dt.Rows.Count > 0)
            {
                PageView.ActiveViewIndex = 0;
                bind_grd();
            }
            else
            {
                DataTable dt = Students_RoomsDAL.Get_if_room_enough(int.Parse(ddr_rooms_no.SelectedItem.Value));
                if (dt.Rows.Count > 0)
                {
                    if (int.Parse(dt.Rows[0][3].ToString()) <= int.Parse(dt.Rows[0][2].ToString()))
                    {
                        Students_Rooms obj_Students_Rooms = new Students_Rooms();
                        obj_Students_Rooms.Room_ID = int.Parse(ddr_rooms_no.SelectedItem.Value);
                        obj_Students_Rooms.Student_ID = int.Parse(ViewState["Student_Id"].ToString());
                        obj_Students_Rooms.Sym_Id = int.Parse(ddr_sym.SelectedItem.Value);
                        Students_RoomsDAL.Insert(obj_Students_Rooms);

                        PageView.ActiveViewIndex = 0;
                        TextBox1.Text = "";
                        lbl_student_name.Text = "";
                        bind_grd();

                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, typeof(Page), "dddd", "alert('لا يمكن وضع هذا الطالب في هذه الغرفه نظرا لاكتمال العدد');", true);
                }
            }
        }
        else
        {
            DataTable dt = Students_RoomsDAL.Get_if_room_enough(int.Parse(ddr_rooms_no.SelectedItem.Value));
            if (dt.Rows.Count > 0)
            {
                if (int.Parse(dt.Rows[0][3].ToString()) <= int.Parse(dt.Rows[0][2].ToString()))
                {
                    Students_Rooms obj_Students_Rooms = new Students_Rooms();
                    obj_Students_Rooms.Student_Room_ID = int.Parse(ViewState["Student_Room_ID"].ToString());
                    obj_Students_Rooms.Room_ID = int.Parse(ddr_rooms_no.SelectedItem.Value);
                    obj_Students_Rooms.Student_ID = int.Parse(ViewState["Student_Id"].ToString());
                    obj_Students_Rooms.Sym_Id = int.Parse(ddr_sym.SelectedItem.Value);
                    Students_RoomsDAL.Update(obj_Students_Rooms);
                    HiddenField1.Value = "0";
                    PageView.ActiveViewIndex = 0;
                    bind_grd();
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, typeof(Page), "dddd", "alert('لا يمكن وضع هذا الطالب في هذه الغرفه نظرا لاكتمال العدد');", true);
            }
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        TextBox1.Text = "";
        ddr_rooms_no.ClearSelection();
        ddr_sym.ClearSelection();

        PageView.ActiveViewIndex = 0;
    }
    protected void grd_stu_rooms_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grd_stu_rooms.PageIndex = e.NewPageIndex;
        bind_grd();

    }
    protected void grd_stu_rooms_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            Students_RoomsDAL.Delete(int.Parse(e.CommandArgument.ToString()));
            bind_grd();
        }
        else if (e.CommandName == "Update")
        {
            bind_insert_ddr();
            HiddenField1.Value = "1";
            DataTable dt = Students_RoomsDAL.Get_By_ID(int.Parse(e.CommandArgument.ToString()));
            if (dt.Rows.Count > 0)
            {
                ddr_rooms_no.ClearSelection();
                ViewState["Student_Room_ID"] = dt.Rows[0][0].ToString();
                ddr_rooms_no.Items.FindByValue(dt.Rows[0][2].ToString()).Selected = true;
                TextBox1.Text = dt.Rows[0][5].ToString();
                lbl_student_name.Text = dt.Rows[0][6].ToString();
                ViewState["Student_Id"] = dt.Rows[0][1].ToString();
                ddr_sym.ClearSelection();
                ddr_sym.Items.FindByValue(dt.Rows[0][3].ToString()).Selected = true;
                PageView.ActiveViewIndex = 1;
            }
        }
    }
    protected void grd_stu_rooms_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {

    }
    protected void grd_stu_rooms_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }
}
