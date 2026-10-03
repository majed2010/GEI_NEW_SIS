using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class advisingReportWithGPA : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("AdvisingReport"))
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
        
        DataTable table = StudentsAdvisingDAL.GetByCourseSemester_Report_GPA(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(depts.SelectedValue));
        Session["StudentDeptRpt"] = depts.SelectedItem.Text;
        Session["SemesterRpt"] = semesters.SelectedItem.Text;
        Session["CourseName"] = courses.SelectedItem.Text;
        
        Session["table"] = table;
        Response.Redirect("StudentAdvReport_GPA.aspx");
    }




}
