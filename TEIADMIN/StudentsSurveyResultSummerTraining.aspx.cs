using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using TeiLib;
using System.Web.Configuration;


public partial class StudentsSurveyResultSummerTraining : System.Web.UI.Page
{
    int SemesterId = Convert.ToInt32(WebConfigurationManager.AppSettings["ActiveSemesterT"]);

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

    protected void ddlCourses_SelectedIndexChanged(object sender, EventArgs e)
    {
        MultiView_SurveyResult.ActiveViewIndex = 1;
        ObjectDataSource1.DataBind();
        ObjectDataSource3.DataBind();
        //ObjectDataSource4.DataBind();
       
 

        lblSubject.Text = ddlCourses.SelectedItem.ToString();
        int CourseId = Convert.ToInt32(ddlCourses.SelectedValue);
        int MemberId = AssignMemberToCourseDAL.GetMemberIdForCourse(CourseId, SemesterId);
        FacultyMembers Member = FacultyMembersDAL.GetMemberById(MemberId);
        lblMember.Text = Member.MemberName;
        lblYear.Text = Convert.ToString(WebConfigurationManager.AppSettings["ActiveYearT"]);
        lblClass.Text = SemestersDAL.GetById(SemesterId).ArSemesterName;
        lblCountAdvising.Text = StudentsSurveyDAL.CountAdvisingStudent(SemesterId, CourseId).Rows[0]["Advisingumber"].ToString();
        lblCountSurvey.Text = StudentsSurveyDAL.CountSurveyStudent(SemesterId, CourseId).Rows[0]["SurveyNumber"].ToString();
        lblBranch.Text = StudentsSurveyDAL.GetDepartmentName(CourseId).Rows[0]["ArDepartmentName"].ToString();
        //lblBranch.Text = DepartmentsDAL.GetByUserId(CurrentUser.GetDepartmentId()).Rows[0]["ArDepartmentName"].ToString();

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

    protected void GridView_FacultyInstructorsItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            InstExcellentGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Excellent"));
            InstVerGoodGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "VeryGood"));
            InstGoodGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Good"));
            InstAcceptableGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Acceptable"));
            InstWeakGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Weak"));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            Total = ((InstExcellentGrades * 5) + (InstVerGoodGrades * 4) + (InstGoodGrades * 3) + (InstAcceptableGrades * 2) + InstWeakGrades) / (InstExcellentGrades + InstVerGoodGrades + InstGoodGrades + InstAcceptableGrades + InstWeakGrades);
            e.Row.Cells[0].Text = "إجمالى التصويت";
            e.Row.Cells[1].Text = InstExcellentGrades.ToString();
            e.Row.Cells[2].Text = InstVerGoodGrades.ToString();
            e.Row.Cells[3].Text = InstGoodGrades.ToString();
            e.Row.Cells[4].Text = InstAcceptableGrades.ToString();
            e.Row.Cells[5].Text = InstWeakGrades.ToString();
            Label3.Visible = true;
            Label4.Visible = true;
            lblInstructorAVG.Visible = true;
            lblInstructorGrade.Visible = true;
            lblInstructorAVG.Text = Total.ToString();
            lblInstructorGrade.Text = GetGradeName(Total);
        }
    }



    //protected void GridView_SubjectItems_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        SubExcellentGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Excellent"));
    //        SubVerGoodGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "VeryGood"));
    //        SubGoodGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Good"));
    //        SubAcceptableGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Acceptable"));
    //        SubWeakGrades += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Weak"));
    //    }
    //    else if (e.Row.RowType == DataControlRowType.Footer)
    //    {
    //        Total = ((SubExcellentGrades * 5) + (SubVerGoodGrades * 4) + (SubGoodGrades * 3) + (SubAcceptableGrades * 2) + SubWeakGrades) / (SubExcellentGrades + SubVerGoodGrades + SubGoodGrades + SubAcceptableGrades + SubWeakGrades);
    //        e.Row.Cells[0].Text = "إجمالى التصويت";
    //        e.Row.Cells[1].Text = SubExcellentGrades.ToString();
    //        e.Row.Cells[2].Text = SubVerGoodGrades.ToString();
    //        e.Row.Cells[3].Text = SubGoodGrades.ToString();
    //        e.Row.Cells[4].Text = SubAcceptableGrades.ToString();
    //        e.Row.Cells[5].Text = SubWeakGrades.ToString();
    //        Label5.Visible = true;
    //        Label6.Visible = true;
    //        lblCourseAVG.Visible = true;
    //        lblCourseGrade.Visible = true;
    //        lblCourseAVG.Text = Total.ToString();
    //        lblCourseGrade.Text = GetGradeName(Total);
    //    }
    //}

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