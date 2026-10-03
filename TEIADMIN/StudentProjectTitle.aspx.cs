using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;

public partial class StudentProjectTitle : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void BuildingGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            ProjectTitleDAL.Delete(Convert.ToInt32(e.CommandArgument));
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحذف')", true);
        }
        else if (e.CommandName == "Edit")
        {
            ProjectTitles project = ProjectTitleDAL.GetById(Convert.ToInt32(e.CommandArgument));
            hdnBuildId.Value = project.ProjectTitleId.ToString();
            txtProjectTitle.Text = project.ProjectTitleName;
            DDlDepartments.SelectedValue = project.DepartmentId.ToString();
            
            PageView.ActiveViewIndex = 1;
            btnSave.Visible = false;
            btnUpdate.Visible = true;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        ProjectTitles project = new ProjectTitles();

        project.ProjectTitleName = txtbuildingName.Text;
        project.DepartmentId = Convert.ToInt32(departments.SelectedValue);
        ProjectTitleDAL.Insert(project);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        Clear();
        PageView.ActiveViewIndex = 2;
        BuildingGrid.DataBind();
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        ProjectTitles project = new ProjectTitles();

        project.ProjectTitleId = Convert.ToInt32(hdnBuildId.Value);
        project.ProjectTitleName = txtProjectTitle.Text;
        project.DepartmentId = Convert.ToInt32(DDlDepartments.SelectedValue);
        ProjectTitleDAL.Update(project);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        btnUpdate.Visible = false;
        Clear();
        PageView.ActiveViewIndex = 2;
        BuildingGrid.DataBind();
    }
    protected void btnAddNew_Click(object sender, EventArgs e)
    {
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        PageView.ActiveViewIndex = 0;

    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
        PageView.ActiveViewIndex = 2;

    }
    private void Clear()
    {
        txtbuildingName.Text = "";
        departments.SelectedValue = "0";
        hdnBuildId.Value = null;
    }
}