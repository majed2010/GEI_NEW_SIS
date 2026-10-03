using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using System.Collections;
public partial class changeDept : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("ChangeStudentDepartment"))
            PageView.ActiveViewIndex = 1;
    }
    DataTable tblStudents = null;
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetStudentData();

    }

    private void GetStudentData()
    {
        tblStudents = StudentsDAL.GetByCode(txtٍStudentCode.Text);
        if (tblStudents.Rows.Count == 1)
        {
            studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
            lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
            lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();
            lblLevel.Text = tblStudents.Rows[0]["ArLevelName"].ToString();
            deptId.Value = tblStudents.Rows[0]["DepartmentId"].ToString();
        }
        else
        {
            lblFullName.Text = "";
            lblDept.Text = "";
            lblLevel.Text = "";
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (StudentsDAL.Update(Convert.ToInt32(studentId.Value), Convert.ToInt32(departmentDDL.SelectedValue)) > 0)
        {
            GetStudentData(); 
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('خطأ في التعديل')", true);
        }



    }

    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }

    protected void CoursesDS_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {

    }

    protected void btnGenerateReport_Click(object sender, EventArgs e)
    {

        //Session["totalCredit"] = totalCredit.Text;// = e.OutputParameters["TotalCredit"].ToString();
        //Session["contactHours"] = contactHours.Text;// = e.OutputParameters["TotalContact"].ToString();
        //Session["studentCode"] = txtٍStudentCode.Text;
        //Session["FullName"] = lblFullName.Text;// = tblStudents.Rows[0]["ArFullName"].ToString();
        //Session["StudentDept"] = lblDept.Text;// = tblStudents.Rows[0]["ArDepartmentName"].ToString();
        //Session["Semester"] = semesters.SelectedItem.Text;
        //int credit, contact;
        //DataTable table = StudentsAdvisingDAL.GetByPage(Convert.ToInt32(studentId.Value), Convert.ToInt32(semesters.SelectedValue), 0, 30, out credit, out contact);
        //Session["totalCredit"] = credit;// = e.OutputParameters["TotalCredit"].ToString();
        //Session["contactHours"] = contact;// = e.OutputParameters["TotalContact"].ToString();
        //Session["studentCode"] = txtٍStudentCode.Text;
        //Session["FullName"] = lblFullName.Text;// = tblStudents.Rows[0]["ArFullName"].ToString();
        //Session["StudentDept"] = lblDept.Text;// = tblStudents.Rows[0]["ArDepartmentName"].ToString();lblLevel
        //Session["Semester"] = semesters.SelectedItem.Text;
        //Session["Level"] = lblLevel.Text;
        //Session["GPA"] = lblGPA.Text;
        //Session["CompletedHours"] = completedHours.Text;
        //Session["RegisteredHours"] = registeredHours.Text;
        //Session["RestHours"] = restHours.Text;

        //Session["table"] = table;

        //Response.Redirect("StudentAdv.aspx");
    }
    protected void stateDDL_SelectedIndexChanged(object sender, EventArgs e)
    {
        //switch (stateDDL.SelectedValue)
        //{
        //    case "2":
        //        semesterHolder.Visible = true;
        //        statmentHolder.Visible = true;
        //        yearHolder.Visible = false;
        //        break;
        //    case "4":
        //        semesterHolder.Visible = true;
        //        statmentHolder.Visible = false;
        //        yearHolder.Visible = false;
        //        courseHolder.Visible = true;
        //        break;
        //    case "3":
        //        yearHolder.Visible = true;
        //        semesterHolder.Visible = false;
        //        statmentHolder.Visible = true;
        //        courseHolder.Visible = false;
        //        break;
        //    default:
        //        yearHolder.Visible = false;
        //        semesterHolder.Visible = false;
        //        statmentHolder.Visible = false;
        //        courseHolder.Visible = false;
        //        break;
        //}

    }
}
