using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using System.Collections;
public partial class ExamAttendance_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
            ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("StudentsExamReport"))
        {
            MultiView1.ActiveViewIndex = 1;
        
        }
        if (!IsPostBack) ;
    }

    private void FillCourses()
    {
        ddlcourses.Items.Clear();
        ddlcourses.DataSource = CoursesDAL.GetByLevelId_ExamAttendance(Convert.ToInt32(drp_level.SelectedValue));
        ddlcourses.DataValueField = "CourseName";
        ddlcourses.DataTextField = "CourseName";
        ddlcourses.DataBind();
        ddlcourses.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }
    protected void drp_level_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillCourses();
    }

    private void FillMemebers()
    {
        DDlMemebers.Items.Clear();
        DDlMemebers.DataSource = StudentsDAL.GetMemebersExam_ByCourseId(ddlcourses.SelectedItem.Text);
        DDlMemebers.DataValueField = "MemberName";
        DDlMemebers.DataTextField = "MemberName";
        DDlMemebers.DataBind();
        DDlMemebers.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        int level_id = int.Parse(this.drp_level.SelectedValue);
        string semester = this.drp_level.SelectedItem.Text;
       // int courseId = int.Parse(this.ddlcourses.SelectedValue);
        string courseName = ddlcourses.SelectedItem.Text;
        
        string memberName = this.DDlMemebers.SelectedItem.Text;

        DataTable studentsTable = StudentsDAL.GetStudentExam_Attandance_ByCourseId(memberName,courseName);
        Session["studentsTable"] = studentsTable;
        Session["LevelName"] = semester;
        Session["CourseName"] = courseName + '-' + memberName;
        
        Response.Redirect("GetAllStudentsExamAttendanaceByLevel_ReportDisplay.aspx");
    }

    protected void ddlcourses_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillMemebers();
    }
}