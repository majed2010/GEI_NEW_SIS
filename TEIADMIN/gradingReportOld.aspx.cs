using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class gradingReportOld : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("gradingReport"))
            PageView.ActiveViewIndex = 1;
    }


    private void FillCourses()
    {
        courses.Items.Clear();
        courses.DataSource = CoursesDAL.GetByDeptId(Convert.ToInt32(depts.SelectedValue));
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

        int successCount = 0 ;
        int failCount = 0;
        int absentCount= 0;
        int attendCount = 0;
        int recordsCount = 0;
      //DataTable table = StudentsAdvisingDAL.GET_StudentsAdvising_ByOffering(Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(courses.SelectedValue) ,Convert.ToInt32(ddlDoctor.SelectedValue),Convert.ToInt32(depts.SelectedValue));
       // DataTable table = StudentsAdvisingDAL.GetByCourseSemester_Report_Offering(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(depts.SelectedValue), Convert.ToInt32(ddlDoctor.SelectedValue), out absentCount, out successCount, out failCount, out attendCount, out recordsCount);
        DataTable table = StudentsAdvisingDAL.GetByCourseSemester_Report(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(depts.SelectedValue), Convert.ToInt32(ddlDoctor.SelectedValue), out absentCount, out successCount, out failCount, out attendCount, out recordsCount);

        Session["StudentDeptRpt"] = depts.SelectedItem.Text;
        Session["SemesterRpt"] = semesters.SelectedItem.Text;
        Session["CourseName"] = courses.SelectedItem.Text;
        Session["MemberName"] = ddlDoctor.SelectedItem.Text;

        Session["successCount"] = successCount.ToString();
        Session["failCount"] = failCount.ToString();
        Session["absentCount"] = absentCount.ToString();
        Session["attendCount"] = attendCount.ToString();
        Session["recordsCount"] = recordsCount.ToString();

        Session["table"] = table;

        Response.Redirect("StudentGradeReport.aspx");
    }
    private void FillDoctors()
    {

        ddlDoctor.Items.Clear();
        ddlDoctor.DataSource = AssignMemberToCourseDAL.GetMembersByCourse(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue));
        ddlDoctor.DataValueField = "MemberId";
        ddlDoctor.DataTextField = "MemberName";
        ddlDoctor.DataBind();
        ddlDoctor.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }
    protected void courses_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillDoctors();

    }



}
