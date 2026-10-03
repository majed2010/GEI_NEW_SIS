using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class gradingReporforperformances : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("PerformanceReport"))
            PageView.ActiveViewIndex = 1;
    }


    private void FillCourses()
    {
        courses.Items.Clear();
        courses.DataSource = CoursesDAL.GetOfferedCourseByDepartment(Convert.ToInt32(depts.SelectedValue), Convert.ToInt32(semesters.SelectedValue));
        courses.DataValueField = "CourseId";
        courses.DataTextField = "ArCourseName";
        courses.DataBind();
        courses.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }
    protected void depts_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillCourses();


    }
    protected void btnGenerate_Click(object sender, EventArgs e)
    {

        int successCount = 0;
        int failCount = 0;
        int absentCount = 0;
        int attendCount = 0;
        int recordsCount = 0;
        //DataTable table = StudentsAdvisingDAL.GET_StudentsAdvising_ByOffering(Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(ddlDoctor.SelectedValue),Convert.ToInt32(depts.SelectedValue));
        DataTable table = StudentsAdvisingDAL.GetByCourseSemester_Report_Offering(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(depts.SelectedValue), Convert.ToInt32(ddlDoctor.SelectedValue), out absentCount, out successCount, out failCount, out attendCount, out recordsCount);


        Session["StudentDeptRpt"] = depts.SelectedItem.Text;
        Session["SemesterRpt"] = semesters.SelectedItem.Text;
        Session["CourseName"] = courses.SelectedItem.Text;
        Session["MemberName"] = ddlDoctor.SelectedItem.Text;

        Session["table"] = table;

        Response.Redirect("StudentGradeReportforPerformances.aspx");
    }

    private void FillDoctors()
    {

        ddlDoctor.Items.Clear();
        ddlDoctor.DataSource = StudentsAdvisingDAL.GET_StudentsAdvising_Members_ByOffering(Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(courses.SelectedValue));

        ddlDoctor.DataValueField = "SectionId";
        ddlDoctor.DataTextField = "EmployeeName";
        ddlDoctor.DataBind();
        ddlDoctor.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }
    protected void courses_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillDoctors();

    }


}
