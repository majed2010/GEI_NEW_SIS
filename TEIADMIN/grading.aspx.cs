using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using System.Collections;

public partial class grading : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Control"))
            PageView.ActiveViewIndex = 1;
        hdnDeptId.Value = CurrentUser.GetDepartmentId().ToString();

        if (IsPostBack)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "betengan", " $(document).ready(function() { $('.accordion-header').toggleClass('active-header').toggleClass('inactive-header');});", true);

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
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "betengan", " $(document).ready(function() {$('.accordion-header').toggleClass('active-header').toggleClass('inactive-header');});", true);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Course course = new Course();
        if (courses.Items.Count > 0)
            course = CoursesDAL.GetById(Convert.ToInt32(courses.SelectedValue));

        AdvObjectDataSource.SelectParameters["courseId"].DefaultValue = courses.SelectedValue;
        AdvObjectDataSource.SelectParameters["semesterId"].DefaultValue = semesters.SelectedValue;
        AdvObjectDataSource.SelectParameters["departmentId"].DefaultValue = depts.SelectedValue;
        AdvObjectDataSource.SelectParameters["doctorCoursesId"].DefaultValue = ddlDoctor.SelectedValue;
        AdvObjectDataSource.SelectParameters["FinalFrom"].DefaultValue = finalFrom.Text == "" ? "0" : finalFrom.Text;
        AdvObjectDataSource.SelectParameters["FinalTo"].DefaultValue = finalTo.Text == "" ? course.FinalExamTotal.ToString() : finalTo.Text;
        AdvObjectDataSource.SelectParameters["TotalFrom"].DefaultValue = totalFrom.Text == "" ? "0" : totalFrom.Text;
        AdvObjectDataSource.SelectParameters["TotalTo"].DefaultValue = totalTo.Text == "" ? "100" : totalTo.Text;
        AdvObjectDataSource.SelectParameters["GradeId"].DefaultValue = gradesDDL.SelectedValue == "0" ? null : gradesDDL.SelectedValue;
        AdvObjectDataSource.SelectParameters["ExamAttend"].DefaultValue = statesDDL.SelectedValue == "0" ? null : statesDDL.SelectedValue;
        AdvObjectDataSource.SelectParameters["ExamTimes"].DefaultValue = examTimes.Text == "" ? "0" : examTimes.Text;

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "betengan", " $(document).ready(function() { $('.accordion-header').toggleClass('active-header').toggleClass('inactive-header');});", true);

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        for (int i = 0; i < grdCourses.Rows.Count; i++)
        {
            TextBox performanceTxt = (TextBox)(grdCourses.Rows[i].FindControl("performanceTxt"));
            TextBox practicalTxt = (TextBox)(grdCourses.Rows[i].FindControl("practicalTxt"));
            TextBox finalTxt = (TextBox)(grdCourses.Rows[i].FindControl("finalTxt"));
            Label advisingIdLbl = (Label)(grdCourses.Rows[i].FindControl("advisingIdLbl"));
            DropDownList attendDDL = (DropDownList)(grdCourses.Rows[i].FindControl("attendDDL"));
            StudentGrades grades = new StudentGrades();

            grades.AdvisingId = Convert.ToInt32(advisingIdLbl.Text);
            if (practicalTxt.Text != "" || performanceTxt.Text != "" || finalTxt.Text != "")
            {
                if (practicalTxt.Text == "")
                    practicalTxt.Text = "0";
                if (performanceTxt.Text == "")
                    performanceTxt.Text = "0";
                if (finalTxt.Text == "")
                    finalTxt.Text = "0";
                grades.LabResult = Convert.ToDecimal(practicalTxt.Text);
                grades.PerformanceResult = Convert.ToDecimal(performanceTxt.Text);
                grades.WrittenResult = Convert.ToDecimal(finalTxt.Text);
                grades.ExamAttendance = Convert.ToInt32(attendDDL.SelectedValue);
                StudentGradesDAL.Insert(grades);
            }
        }

        grdCourses.DataBind();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "betengan", "alert('تم الحفظ')", true);

    }
    protected void grdCourses_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            Course course = CoursesDAL.GetById(Convert.ToInt32(courses.SelectedValue));

            ((TextBox)e.Row.Cells[4].FindControl("performanceTxt")).Attributes.Add("onblur", "javascript:verify_text(this,' أعمال السنة '," + course.YearPerformancelTotal + ");");//alert('تم hhالحفظ');
            ((TextBox)e.Row.Cells[4].FindControl("practicalTxt")).Attributes.Add("onblur", "javascript:verify_text(this,' العملي '," + course.LabTotal + ");");//alert('تم hhالحفظ');
            ((TextBox)e.Row.Cells[4].FindControl("finalTxt")).Attributes.Add("onblur", "javascript:verify_text(this,' التحريري '," + course.FinalExamTotal + ");");//alert('تم hhالحفظ');
        }
    }
    protected void btnAddFactor_Click(object sender, EventArgs e)
    {
        if (courses.Items.Count > 0)
        {
            int recordsCount = 0;
            int successCount = 0;
            int failCount = 0;
            int absentCount = 0;
            int attendCount = 0;
            Course course = CoursesDAL.GetById(Convert.ToInt32(courses.SelectedValue));// ده مش صح على فكرة المفروض ان احنا بنرديوس(بنقلل) في الكود
            finalFrom.Text = finalFrom.Text == "" ? "0" : finalFrom.Text;
            finalTo.Text = finalTo.Text == "" ? course.FinalExamTotal.ToString() : finalTo.Text;
            totalFrom.Text = totalFrom.Text == "" ? "0" : totalFrom.Text;
            totalTo.Text = totalTo.Text == "" ? "100" : totalTo.Text;
            gradesDDL.SelectedValue = gradesDDL.SelectedValue == "0" ? "0" : gradesDDL.SelectedValue;
            statesDDL.SelectedValue = statesDDL.SelectedValue == "0" ? "0" : statesDDL.SelectedValue;
            examTimes.Text = examTimes.Text == "" ? "0" : examTimes.Text;
            decimal PerformanceResult = 0, LabResult = 0, WrittenResult = 0;
            DataTable gradesTable = StudentsAdvisingDAL.GetByCourseSemester(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(depts.SelectedValue),Convert.ToInt32(ddlDoctor.SelectedValue),
                Convert.ToDecimal(finalFrom.Text), Convert.ToDecimal(finalTo.Text), Convert.ToDecimal(totalFrom.Text), Convert.ToDecimal(totalTo.Text)
                , Convert.ToInt32(gradesDDL.SelectedValue), Convert.ToInt32(statesDDL.SelectedValue), Convert.ToInt32(examTimes.Text), out recordsCount
                , out absentCount, out successCount, out failCount, out attendCount);
            if (performanceFactor.Text == "")
                performanceFactor.Text = "0";
            if (practicalFactor.Text == "")
                practicalFactor.Text = "0";
            if (finalFactor.Text == "")
                finalFactor.Text = "0";
            foreach (DataRow row in gradesTable.Rows)
            {
                if (!Convert.IsDBNull(row["PerformanceResult"]))
                {
                    PerformanceResult = Convert.ToDecimal(row["PerformanceResult"]) + Convert.ToDecimal(performanceFactor.Text);
                    LabResult = Convert.ToDecimal(row["LabResult"]) + Convert.ToDecimal(practicalFactor.Text);
                    WrittenResult = Convert.ToDecimal(row["WrittenResult"]) + Convert.ToDecimal(finalFactor.Text);

                    if (PerformanceResult > course.YearPerformancelTotal)
                        PerformanceResult = course.YearPerformancelTotal;

                    if (LabResult > course.LabTotal)
                        LabResult = course.LabTotal;

                    if (WrittenResult > course.FinalExamTotal)
                        WrittenResult = course.FinalExamTotal;

                    StudentGrades grades = new StudentGrades();
                    if (StudentGradesDAL.GetByAdvisingId(Convert.ToInt32(row["AdvisingId"])).Rows.Count > 0)
                    {
                        grades.AdvisingId = Convert.ToInt32(row["AdvisingId"]);
                        grades.LabResult = LabResult;
                        grades.PerformanceResult = PerformanceResult;
                        grades.WrittenResult = WrittenResult;
                        grades.ExamAttendance = Convert.ToInt32(row["ExamAttendance"]);
                        StudentGradesDAL.Insert(grades);
                    }
                }
            }
            successLbl.Text = successCount.ToString();
            failedLbl.Text = failCount.ToString();
            absentLbl.Text = absentCount.ToString();
            attendLbl.Text = attendCount.ToString();
            grdCourses.DataBind();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        }
    }
    protected void AdvObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        int rows = 0;
        if (!int.TryParse(e.ReturnValue.ToString(), out rows))
        {
            successLbl.Text = e.OutputParameters["successCount"].ToString();
            successLblPrct.Text = (Math.Round(Convert.ToDecimal(e.OutputParameters["successCount"].ToString()) / Math.Round((Convert.ToDecimal(e.OutputParameters["attendCount"].ToString()) == 0 ? 1 : Convert.ToDecimal(e.OutputParameters["attendCount"].ToString())), 2) * 100, 2)).ToString() + "%";
            failedLbl.Text = e.OutputParameters["failCount"].ToString();
            failedLblPrct.Text = (Math.Round(Convert.ToDecimal(e.OutputParameters["failCount"].ToString()) / Math.Round((Convert.ToDecimal(e.OutputParameters["attendCount"].ToString()) == 0 ? 1 : Convert.ToDecimal(e.OutputParameters["attendCount"].ToString())), 2) * 100, 2)).ToString() + "%";
            absentLbl.Text = e.OutputParameters["absentCount"].ToString();
            absentLblPrct.Text = (Math.Round(Convert.ToDecimal(e.OutputParameters["absentCount"].ToString()) / Math.Round((Convert.ToDecimal(e.OutputParameters["recordsCount"].ToString()) == 0 ? 1 : Convert.ToDecimal(e.OutputParameters["recordsCount"].ToString())), 2) * 100,2)).ToString() + "%";
            attendLbl.Text = e.OutputParameters["attendCount"].ToString();
            attendLblPrct.Text = (Math.Round(Convert.ToDecimal(e.OutputParameters["attendCount"].ToString()) / Math.Round((Convert.ToDecimal(e.OutputParameters["recordsCount"].ToString()) == 0 ? 1 : Convert.ToDecimal(e.OutputParameters["recordsCount"].ToString())), 2) * 100,2)).ToString() + "%";
        }
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
