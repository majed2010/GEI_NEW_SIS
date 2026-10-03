using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using System.Collections;
public partial class execuses : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("ExecusesWith"))
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
        int Isterms = 0;
        if (tblStudents.Rows.Count == 1)
        {
            studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
            lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
            lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();

            if (Convert.ToInt32(tblStudents.Rows[0]["IsTerms"]) == 0)
            {
                lblLevel.Text = tblStudents.Rows[0]["ArLevelName"].ToString();
            }
            else
            {
                lblLevel.Text = tblStudents.Rows[0]["TermsLevel"].ToString();
            }

           // deptId.Value = tblStudents.Rows[0]["DepartmentId"].ToString();
            
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
        Execuses_Withdraw execuse = new Execuses_Withdraw();
        execuse.StudentId = Convert.ToInt32(studentId.Value);
        execuse.StateId = Convert.ToInt32(stateDDL.SelectedValue);
        execuse.StateStatement = txtStatment.Text;
        execuse.YearId = Convert.ToInt32(ddlYear.SelectedValue);
        execuse.SemesterId = Convert.ToInt32(semesters.SelectedValue);
        execuse.CourseId = Convert.ToInt32(courses.SelectedValue);
       
            Execuses_WithdrawDAL.Insert(execuse);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
            ExecusesGrid.DataBind();
       


    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        Execuses_Withdraw execuse = new Execuses_Withdraw();
        execuse.Id = Convert.ToInt32(stateId.Value);
        execuse.StudentId = Convert.ToInt32(studentId.Value);
        execuse.StateId = Convert.ToInt32(stateDDL.SelectedValue);
        execuse.StateStatement = txtStatment.Text;
        execuse.YearId = Convert.ToInt32(ddlYear.SelectedValue);
        execuse.SemesterId = Convert.ToInt32(semesters.SelectedValue);
        execuse.CourseId = Convert.ToInt32(courses.SelectedValue);
       
            
            Execuses_WithdrawDAL.Update(execuse);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم التعديل')", true);
            ExecusesGrid.DataBind();
        


    }
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }

    protected void CoursesDS_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        courses.Items.Clear();
        courses.Items.Insert(0,new ListItem(".. اختر ..","0"));
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
        switch (stateDDL.SelectedValue)
        {
            case "6":
                semesterHolder.Visible = true;
                statmentHolder.Visible = true;
                yearHolder.Visible = false;
                break;
            case "4":
                semesterHolder.Visible = true;
                statmentHolder.Visible = false;
                yearHolder.Visible = false;
                courseHolder.Visible = true;
                break;
            case "3":
                yearHolder.Visible = true;
                semesterHolder.Visible = false;
                statmentHolder.Visible = true;
                courseHolder.Visible = false;
                break;
            default:
                yearHolder.Visible = false;
                semesterHolder.Visible = false;
                statmentHolder.Visible = false;
                courseHolder.Visible = false;
                break;
        }

    }

    protected void ExecusesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
            SemesterDS.DataBind();
            YearsDS.DataBind();
            CoursesDS.DataBind();
            ddlYear.DataBind();
            semesters.DataBind();
            courses.DataBind();
            Execuses_Withdraw exec = Execuses_WithdrawDAL.GetById(Convert.ToInt32(e.CommandArgument));
            stateDDL.SelectedValue = exec.StateId.ToString();
            stateDDL_SelectedIndexChanged(sender, e);
            txtStatment.Text = exec.StateStatement;
            semesters.SelectedValue = exec.SemesterId.ToString();
            ddlYear.SelectedValue = exec.YearId.ToString();
            courses.SelectedValue = exec.CourseId.ToString();
            stateId.Value = e.CommandArgument.ToString();
            btnUpdate.Visible = true;
            btnAdd.Visible = false;
            

            
        }
        else if (e.CommandName == "rowDelete")
        {
            Execuses_WithdrawDAL.Delete(Convert.ToInt32(e.CommandArgument));
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحذف')", true);
            ExecusesGrid.DataBind();

        }
    }
}
