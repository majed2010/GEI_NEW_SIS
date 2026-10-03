using System;
using System.Web.UI.WebControls;
using System.Data;

using System.Web.UI;
using TeiLib_AD;

public partial class Assign_Visitors_To_students : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            HiddenField1.Value = "0";
            bind_grd();
        }
    }

    private void bind_insert_ddr()
    {

        DataTable dt1 = VisitorsDAL.GetAll();
        {
             ddr_visitors.DataSource = dt1;
             ddr_visitors.DataTextField = "Visitor_Name";
             ddr_visitors.DataValueField = "Visitor_Id";
             ddr_visitors.DataBind();
             ddr_visitors.Items.Insert(0, new ListItem("اختر...", "0"));
             

        }
    }
    private void bind_grd()
    {
        DataTable dt = Students_VisitorsDAL.get_by_student_code(txtٍStudentCode.Text);
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
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        txt_relation.Text = "";
        lbl_student_name.Text = "";
        TextBox1.Text = "";
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
        else
        {
            ViewState["Student_Id"] = "";
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (HiddenField1.Value == "0")
        {
            if (ViewState["Student_Id"] == "")
            {
                PageView.ActiveViewIndex = 0;
                bind_grd();
            }
            else
            {
                Students_Visitors obj_Students_Visitors = new Students_Visitors();
                obj_Students_Visitors.Visitor_ID = int.Parse(ddr_visitors.SelectedItem.Value);
                obj_Students_Visitors.Student_ID = int.Parse(ViewState["Student_Id"].ToString());
                obj_Students_Visitors.Visitor_Relation = txt_relation.Text;
                Students_VisitorsDAL.Insert(obj_Students_Visitors);
                ViewState["Student_Id"] = "";
                PageView.ActiveViewIndex = 0;
                bind_grd();
            }
        }
        else
        {

            Students_Visitors obj_Students_Visitors = new Students_Visitors();
            obj_Students_Visitors.Visitor_Student_Id = int.Parse(ViewState["Visitor_Student_Id"].ToString());
            obj_Students_Visitors.Visitor_ID = int.Parse(ddr_visitors.SelectedItem.Value);
            obj_Students_Visitors.Student_ID = int.Parse(ViewState["Student_Id"].ToString());
            obj_Students_Visitors.Visitor_Relation = txt_relation.Text;
            Students_VisitorsDAL.Update(obj_Students_Visitors);
            ViewState["Student_Id"] = "";
                     HiddenField1.Value = "0";
                     PageView.ActiveViewIndex = 0;
                     bind_grd();

        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        TextBox1.Text = "";
        txt_relation.Text = "";
        ddr_visitors.ClearSelection();

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
            Students_VisitorsDAL.Delete(int.Parse(e.CommandArgument.ToString()));
            bind_grd();
        }
        else if (e.CommandName == "Update")
        {
            bind_insert_ddr();
            HiddenField1.Value = "1";
            DataTable dt  = Students_VisitorsDAL.GetByID(int.Parse(e.CommandArgument.ToString()));
            if (dt.Rows.Count > 0)
            {
                ViewState["Visitor_Student_Id"] = dt.Rows[0][0].ToString();
                TextBox1.Text = dt.Rows[0][5].ToString();
                txt_relation.Text = dt.Rows[0][3].ToString();
                lbl_student_name.Text = dt.Rows[0][5].ToString();
                ViewState["Student_Id"] = dt.Rows[0][2].ToString();
                ddr_visitors.ClearSelection();
                ddr_visitors.Items.FindByValue(dt.Rows[0][1].ToString()).Selected = true;
                PageView.ActiveViewIndex = 1;
            }
        }
    }
    protected void grd_stu_rooms_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        bind_grd();
    }
    protected void grd_stu_rooms_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }
}
