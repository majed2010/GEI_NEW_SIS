using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;

public partial class MilitaryEducationPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("StudentsMilitary"))
            PageView.ActiveViewIndex = 2;
    }
    protected void BuildingGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            MilitaryEducationDAL.Delete(Convert.ToInt32(e.CommandArgument));
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحذف')", true);
        }
        else if (e.CommandName == "Edit")
        {
           TeiLib.MilitaryEducation militray = MilitaryEducationDAL.GetById(Convert.ToInt32(e.CommandArgument));

            txtbuildingName.Text = militray.MilitaryEducationName;
            hdnBuildId.Value = militray.MilitaryEducationId.ToString();
            PageView.ActiveViewIndex = 0;
            btnSave.Visible = false;
            btnUpdate.Visible = true;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        MilitaryEducation Military = new MilitaryEducation();
        Military.MilitaryEducationName = txtbuildingName.Text;
        MilitaryEducationDAL.Insert(Military);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        Clear();
        PageView.ActiveViewIndex = 1;
        BuildingGrid.DataBind();
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MilitaryEducation Military = new MilitaryEducation();
        Military.MilitaryEducationId = Convert.ToInt32(hdnBuildId.Value);
        Military.MilitaryEducationName = txtbuildingName.Text;
        MilitaryEducationDAL.Update(Military);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        btnUpdate.Visible = false;
        Clear();
        PageView.ActiveViewIndex = 1;
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
        PageView.ActiveViewIndex = 1;

    }
    private void Clear()
    {
        txtbuildingName.Text = "";
        hdnBuildId.Value = null;
    }
}