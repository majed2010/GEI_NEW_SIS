using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using System.Collections;
public partial class StudentProjectDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("ProjectDetails"))
            PageView.ActiveViewIndex = 1;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable tblStudents = StudentsDAL.GetByCode(txtٍStudentCode.Text);
        if (tblStudents.Rows.Count == 1)
        {
            studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
            lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
            lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();
            lblLevel.Text = tblStudents.Rows[0]["ArLevelName"].ToString();
            departmentId.Value = tblStudents.Rows[0]["DepartmentId"].ToString();
          
            addCoursesHolder.Visible = true;
           
        }
        else
        {
            lblFullName.Text = "";
            lblDept.Text = "";
            lblLevel.Text = "";
        }

    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        StudentProject project = new StudentProject();
        project.StudentId =Convert.ToInt32(studentId.Value);
        project.ProjectTitleId = Convert.ToInt32(DDLProject.SelectedValue);
        project.CourseId = Convert.ToInt32(courses.SelectedValue);
        project.SemesterId = Convert.ToInt32(DDLSemesters.SelectedValue);
      
     StudentProjectDAL.Insert(project);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        // BlockingGridView.DataBind();
    }

    protected void BlockingGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
           
            
           
        }
        else  if (e.CommandName == "rowDelete")
        {
    

        }
    }
    protected void CoursesDS_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        courses.Items.Clear();
        courses.Items.Insert(0, new ListItem(".. اختر ..", "0"));
    }
    protected void DSProject_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        courses.Items.Clear();
        courses.Items.Insert(0, new ListItem(".. اختر ..", "0"));
    }
}

