using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;

public partial class SurveyTypesForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("QC"))
            MultiView_SurveyTypes.ActiveViewIndex = 3;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        SurveyTypes survey = new SurveyTypes();
        survey.SurveyName = txtSurveyName.Text;
        SurveyTypesDAL.insert(survey);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        GridView_SurveyTypes.DataBind();
        MultiView_SurveyTypes.ActiveViewIndex = 2;
        txtSurveyName.Text = "";
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        MultiView_SurveyTypes.ActiveViewIndex = 0;
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        SurveyTypes survey = new SurveyTypes();
        survey.SurveyId = Convert.ToInt32(HFSurveyId.Value);
        survey.SurveyName = txtSurveyNameUpdate.Text;
        SurveyTypesDAL.Update(survey);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم التعديل')", true);
        GridView_SurveyTypes.DataBind();
        MultiView_SurveyTypes.ActiveViewIndex = 2;
    }

    protected void btnCancelSave_Click(object sender, EventArgs e)
    {
        MultiView_SurveyTypes.ActiveViewIndex = 2;
        txtSurveyName.Text = "";
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        MultiView_SurveyTypes.ActiveViewIndex = 2;
        txtSurveyName.Text = "";
    }

    protected void GridView_SurveyTypes_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
            int SurveyId = Convert.ToInt32(e.CommandArgument);
            SurveyTypes surveyType = SurveyTypesDAL.GetSurveyTypeById(SurveyId);
            txtSurveyNameUpdate.Text = surveyType.SurveyName;
            HFSurveyId.Value = Convert.ToString(surveyType.SurveyId);
            MultiView_SurveyTypes.ActiveViewIndex = 1;
        }
    }
}