using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class CoursesStatistics_Grades_All : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("CoursesStatisticsGradesAll"))
            PageView.ActiveViewIndex = 1;
    }

  
    protected void btnGenerate_Click(object sender, EventArgs e)
    {

        DataTable table = StudentsAdvisingDAL.CoursesGrades_Statistics_Grades_All(Convert.ToInt32(depts.SelectedValue), Convert.ToInt32(courses.SelectedValue));
        Session["Department_SS"] = depts.SelectedItem.Text;

        Session["CourseId_SS"] = courses.SelectedItem.Text;

        Session["dt_table2"] = table;

        Response.Redirect("CoursesStatistics_Grades_All_Report.aspx");
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


}
