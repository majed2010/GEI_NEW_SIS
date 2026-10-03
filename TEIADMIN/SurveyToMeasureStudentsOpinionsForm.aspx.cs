using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using TeiLib;

public partial class SurveyToMeasureStudentsOpinionsForm : System.Web.UI.Page
{
    int SemesterId = Convert.ToInt32(WebConfigurationManager.AppSettings["ActiveSemester"]);

    protected void Page_Load(object sender, EventArgs e)
    {
        lblYear.Text = Convert.ToString(WebConfigurationManager.AppSettings["ActiveYear"]);
        lblClass.Text = SemestersDAL.GetById(SemesterId).ArSemesterName;
        lblLevel.Text = "";
        lblBranch.Text = DepartmentsDAL.GetByUserId(CurrentUser.GetDepartmentId()).Rows[0]["ArDepartmentName"].ToString();
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        StudentsSurvey StudentSurvey = new StudentsSurvey();
        StudentSurvey.SemesterId = SemesterId;
        StudentSurvey.StudentId = CurrentUser.GetStudentId();

        foreach (GridViewRow row in GridView_AdministrationCredibility.Rows)
        {
            StudentSurvey.ItemId = int.Parse((row.Cells[1].FindControl("lblItemId") as Label).Text);
            StudentSurvey.ItemValue = Convert.ToInt32((row.Cells[3].FindControl("ddlItems") as DropDownList).SelectedValue);
            StudentsSurveyDAL.insert(StudentSurvey);
        }

        foreach (GridViewRow row in GridView_AdmissionPolicies.Rows)
        {
            StudentSurvey.ItemId = int.Parse((row.Cells[1].FindControl("lblItemId") as Label).Text);
            StudentSurvey.ItemValue = Convert.ToInt32((row.Cells[3].FindControl("ddlItems") as DropDownList).SelectedValue);
            StudentsSurveyDAL.insert(StudentSurvey);
        }

        foreach (GridViewRow row in GridView_EducationAndEvaluationMethods.Rows)
        {
            StudentSurvey.ItemId = int.Parse((row.Cells[1].FindControl("lblItemId") as Label).Text);
            StudentSurvey.ItemValue = Convert.ToInt32((row.Cells[3].FindControl("ddlItems") as DropDownList).SelectedValue);
            StudentsSurveyDAL.insert(StudentSurvey);
        }

        foreach (GridViewRow row in GridView_PossibilitiesLaboratory.Rows)
        {
            StudentSurvey.ItemId = int.Parse((row.Cells[1].FindControl("lblItemId") as Label).Text);
            StudentSurvey.ItemValue = Convert.ToInt32((row.Cells[3].FindControl("ddlItems") as DropDownList).SelectedValue);
            StudentsSurveyDAL.insert(StudentSurvey);
        }

        foreach (GridViewRow row in GridView_TeachingAidsSupporting.Rows)
        {
            StudentSurvey.ItemId = int.Parse((row.Cells[1].FindControl("lblItemId") as Label).Text);
            StudentSurvey.ItemValue = Convert.ToInt32((row.Cells[3].FindControl("ddlItems") as DropDownList).SelectedValue);
            StudentsSurveyDAL.insert(StudentSurvey);
        }

        foreach (GridViewRow row in GridView_Library.Rows)
        {
            StudentSurvey.ItemId = int.Parse((row.Cells[1].FindControl("lblItemId") as Label).Text);
            StudentSurvey.ItemValue = Convert.ToInt32((row.Cells[3].FindControl("ddlItems") as DropDownList).SelectedValue);
            StudentsSurveyDAL.insert(StudentSurvey);
        }
    }
}