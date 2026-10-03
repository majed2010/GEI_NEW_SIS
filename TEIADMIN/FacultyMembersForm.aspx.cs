using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;

public partial class FacultyMembersForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("QC"))
            MultiView_FacultyMembers.ActiveViewIndex = 3;
    }

    protected void btnAddMember_Click(object sender, EventArgs e)
    {
        FacultyMembers facultyMembers = new FacultyMembers();
        facultyMembers.MemberName = txtMemberName.Text;
        facultyMembers.DepartmentId = int.Parse(DDLDepartments.SelectedValue);
        facultyMembers.MemberTypeId = Convert.ToInt32(DDLMemberType.SelectedValue);
        FacultyMembersDAL.insert(facultyMembers);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        GridView_FacultyMembers.DataBind();
        MultiView_FacultyMembers.ActiveViewIndex = 2;
        clearFields();
    }

    protected void clearFields()
    {
        txtMemberName.Text = "";
        DDLDepartments.SelectedValue = "0";
        DDLMemberType.SelectedValue = "0";
    
    }
    protected void btnCancelAdd_Click(object sender, EventArgs e)
    {
        MultiView_FacultyMembers.ActiveViewIndex = 2;
        clearFields();
    }

    protected void btnCancelUpdate_Click(object sender, EventArgs e)
    {
        MultiView_FacultyMembers.ActiveViewIndex = 2;
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        FacultyMembers facultyMembers = new FacultyMembers();
        facultyMembers.MemberId = Convert.ToInt32(HFMemberId.Value);
        facultyMembers.MemberName = txtMemberUpdate.Text;
        facultyMembers.DepartmentId = int.Parse(DDLDepartmentsUpdate.SelectedValue);
        facultyMembers.MemberTypeId = Convert.ToInt32(DDLMemberTypesUpdate.SelectedValue);
        FacultyMembersDAL.Update(facultyMembers);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم التعديل')", true);
        GridView_FacultyMembers.DataBind();
        MultiView_FacultyMembers.ActiveViewIndex = 2;
    }

    protected void GridView_FacultyMembers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
            int ID = Convert.ToInt32(e.CommandArgument);
            FacultyMembers facultyMember = FacultyMembersDAL.GetMemberById(ID);
            txtMemberUpdate.Text = facultyMember.MemberName;
            HFMemberId.Value = facultyMember.MemberId.ToString();
            DDLDepartmentsUpdate.SelectedValue = facultyMember.DepartmentId.ToString();
            DDLMemberTypesUpdate.SelectedValue = facultyMember.MemberTypeId.ToString();
            MultiView_FacultyMembers.ActiveViewIndex = 1;
        }
        else if (e.CommandName == "rowDelete")
        {
            int ID = Convert.ToInt32(e.CommandArgument);
            FacultyMembersDAL.Delete(ID);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحذف')", true);
            GridView_FacultyMembers.DataBind();
            MultiView_FacultyMembers.ActiveViewIndex = 2;
        }
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        MultiView_FacultyMembers.ActiveViewIndex = 0;
    }
}