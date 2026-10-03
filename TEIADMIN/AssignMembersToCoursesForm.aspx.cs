using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;

public partial class AssignMembersToCoursesForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("QC"))
            MultiView_AssignMemberToCource.ActiveViewIndex = 3;
    }
    protected void btnAddMember_Click(object sender, EventArgs e)
    {
        AssignMemberToCourse Member = new AssignMemberToCourse();
        Member.MemberId = Convert.ToInt32(DDLMemberNames.SelectedValue);
        Member.CourseId = Convert.ToInt32(DDLCourses.SelectedValue);
        Member.SemesterId = Convert.ToInt32(DDLSemesters.SelectedValue);
        Member.DepartmentId = Convert.ToInt32(DDLDepartments.SelectedValue);
        Member.GroupMaximum = Convert.ToInt32(txtgroupnumber.Text);
        AssignMemberToCourseDAL.insert(Member);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        GridView_AssignMemberToCourse.DataBind();
        MultiView_AssignMemberToCource.ActiveViewIndex = 2;
        clearFields();
    }
    protected void clearFields()
    {
        DDLMemberNames.SelectedValue = "0";
        DDLCourses.SelectedValue = "0";
        DDLSemesters.SelectedValue = "0";
        DDLDepartments.SelectedValue = "0";
        txtgroupnumber.Text = "";

    }

    protected void btnCancelAdd_Click(object sender, EventArgs e)
    {
        MultiView_AssignMemberToCource.ActiveViewIndex = 2;
        clearFields();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        AssignMemberToCourse Member = new AssignMemberToCourse();
        Member.AssignId = Convert.ToInt32(HFAssignId.Value);
        Member.MemberId = Convert.ToInt32(DDLMemberNamesUpdate.SelectedValue);
        Member.CourseId = Convert.ToInt32(DDLCoursesUpdate.SelectedValue);
        Member.SemesterId = Convert.ToInt32(DDLSemestersUpdate.SelectedValue);
        Member.DepartmentId = Convert.ToInt32(DDLDepartmentsUpdate.SelectedValue);
        Member.GroupMaximum = Convert.ToInt32(txtgroupnumberupdate.Text);
        AssignMemberToCourseDAL.Update(Member);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم التعديل')", true);
        GridView_AssignMemberToCourse.DataBind();
        MultiView_AssignMemberToCource.ActiveViewIndex = 2;
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        MultiView_AssignMemberToCource.ActiveViewIndex = 2;
    }
    protected void btnAddMemberToList_Click(object sender, EventArgs e)
    {
        MultiView_AssignMemberToCource.ActiveViewIndex = 0;
    }
    protected void GridView_AssignMemberToCourse_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
            int AssignId = Convert.ToInt32(e.CommandArgument);
            AssignMemberToCourse Member = AssignMemberToCourseDAL.GetAssignById(AssignId);
            DDLMemberNamesUpdate.SelectedValue = Convert.ToString(Member.MemberId);
            HFAssignId.Value = Convert.ToString(Member.AssignId);
            DDLCoursesUpdate.SelectedValue = Convert.ToString(Member.CourseId);
            DDLSemestersUpdate.SelectedValue = Convert.ToString(Member.SemesterId);
            DDLDepartmentsUpdate.SelectedValue = Convert.ToString(Member.DepartmentId);
            txtgroupnumberupdate.Text = Member.GroupMaximum.ToString();
            MultiView_AssignMemberToCource.ActiveViewIndex = 1;
        }

    }
}