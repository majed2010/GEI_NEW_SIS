using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using TeiLib;
using System.Web.Configuration;


public partial class StudentsSurveyGeneralResultByDepartment : System.Web.UI.Page
{
    int SemesterId = Convert.ToInt32(WebConfigurationManager.AppSettings["ResultActiveSemester"]);

    float ExcellentGrades = 0 , VerGoodGrades = 0 , GoodGrades = 0, AcceptableGrades = 0, WeakGrades = 0;
    float InstExcellentGrades = 0, InstVerGoodGrades = 0, InstGoodGrades = 0, InstAcceptableGrades = 0, InstWeakGrades = 0;
    float SubExcellentGrades = 0, SubVerGoodGrades = 0, SubGoodGrades = 0, SubAcceptableGrades = 0, SubWeakGrades = 0;
    float Total = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("QCResult"))
            MultiView_SurveyResult.ActiveViewIndex = 2;
        
     
    }
    private void GetSurveyData()
    {
        MultiView_SurveyResult.ActiveViewIndex = 1;
        ObjectDataSource1.DataBind();




        lblSubject.Text = ddlCourses.SelectedItem.ToString();
        int DepartmentId = Convert.ToInt32(ddlCourses.SelectedValue);
        //int MemberId = AssignMemberToCourseDAL.GetMemberIdForCourse(CourseId, SemesterId);
       // FacultyMembers Member = FacultyMembersDAL.GetMemberById(MemberId);
       // lblMember.Text = Member.MemberName;
        int YearId = Convert.ToInt32(WebConfigurationManager.AppSettings["ActiveYear"]);
        lblYear.Text = YearsDAL.GetById(YearId).YearName;
        lblClass.Text = SemestersDAL.GetById(SemesterId).ArSemesterName;
        //lblCountAdvising.Text = StudentsSurveyDAL.CountAdvisingStudent(SemesterId, CourseId).Rows[0]["Advisingumber"].ToString();
        lblCountSurvey.Text = StudentsSurveyDAL.CountSurveyStudent_byDepartment(SemesterId, DepartmentId).Rows[0]["SurveyNumber"].ToString();
        //lblBranch.Text = StudentsSurveyDAL.GetDepartmentName(CourseId).Rows[0]["ArDepartmentName"].ToString();
        //lblBranch.Text = DepartmentsDAL.GetByUserId(CurrentUser.GetDepartmentId()).Rows[0]["ArDepartmentName"].ToString();


    }

    protected void ddlCourses_SelectedIndexChanged(object sender, EventArgs e)
    {
        GetSurveyData();

    }

    protected void GridView_FacultyMembersItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ExcellentGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Excellent"));
            VerGoodGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "VeryGood"));
            GoodGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Good"));
            AcceptableGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Acceptable"));
            WeakGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Weak"));
        }

        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            Total = ((ExcellentGrades*5) + (VerGoodGrades*4) + (GoodGrades*3) + (AcceptableGrades*2) + WeakGrades)/(ExcellentGrades+ VerGoodGrades+ GoodGrades+ AcceptableGrades+ WeakGrades);
            e.Row.Cells[0].Text = "إجمالى التصويت";
            e.Row.Cells[1].Text = ExcellentGrades.ToString();
            e.Row.Cells[2].Text = VerGoodGrades.ToString();
            e.Row.Cells[3].Text = GoodGrades.ToString();
            e.Row.Cells[4].Text = AcceptableGrades.ToString();
            e.Row.Cells[5].Text = WeakGrades.ToString();
            Label1.Visible = true;
            Label2.Visible = true;
            lblMemberAVG.Visible = true;
            lblMemberGradeName.Visible = true;
            lblMemberAVG.Text = Total.ToString();
            lblMemberGradeName.Text = GetGradeName(Total);
        }
    }

   

    public string GetGradeName(float AVG)
    {
        if (AVG > 4.5 && AVG <= 5)
            return "ممتاز";
        else if (AVG > 3.5 && AVG <= 4.5)
            return "جيد جدا";
        else if (AVG > 2.5 && AVG <= 3.5)
            return "جيد";
        else if (AVG > 1.5 && AVG <= 2.5)
            return "مقبول";
        else
            return "ضعيف";
    }

    public void RowDataBound(GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ExcellentGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Excellent"));
            VerGoodGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "VeryGood"));
            GoodGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Good"));
            AcceptableGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Acceptable"));
            WeakGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Weak"));
        }

        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[0].Text = "إجمالى التصويت";
            e.Row.Cells[1].Text = ExcellentGrades.ToString();
            e.Row.Cells[2].Text = VerGoodGrades.ToString();
            e.Row.Cells[3].Text = GoodGrades.ToString();
            e.Row.Cells[4].Text = AcceptableGrades.ToString();
            e.Row.Cells[5].Text = WeakGrades.ToString();
        }
    }
    protected void btnDone_Click(object sender, EventArgs e)
    {
        MultiView_SurveyResult.ActiveViewIndex = 0;
    }
}