using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;

public partial class SurveyItemsForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("QC"))
            MultiView_SurveyItems.ActiveViewIndex = 3;
    }

    protected void btnCancelAdd_Click(object sender, EventArgs e)
    {
        MultiView_SurveyItems.ActiveViewIndex = 2;
        clearFields();
    }

    protected void GridView_SurveyItems_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
            int surveyItemId = Convert.ToInt32(e.CommandArgument);
            SurveyItems Item = SurveyItemsDAL.GetItemById(surveyItemId);
            txtItemUpdate.Text = Item.SurveyItemText;
            HFItemId.Value = Item.SurveyItemId.ToString();
            DDLItemTypesUpdate.SelectedValue = Item.SurveyItemType.ToString();
            MultiView_SurveyItems.ActiveViewIndex = 1;
        }
        else if (e.CommandName == "rowDelete")
        {
            int ID = Convert.ToInt32(e.CommandArgument);
            SurveyItemsDAL.Delete(ID);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحذف')", true);
            GridView_SurveyItems.DataBind();
            MultiView_SurveyItems.ActiveViewIndex = 2;
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        SurveyItems Item = new SurveyItems();
        Item.SurveyItemId = Convert.ToInt32(HFItemId.Value);
        Item.SurveyItemText = txtItemUpdate.Text;
        Item.SurveyItemType = Convert.ToInt32(DDLItemTypesUpdate.SelectedValue);

        SurveyItemsDAL.Update(Item);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم التعديل')", true);
        GridView_SurveyItems.DataBind();
        MultiView_SurveyItems.ActiveViewIndex = 2;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        MultiView_SurveyItems.ActiveViewIndex = 2;
        clearFields();
    }

    protected void btnAddItemToList_Click(object sender, EventArgs e)
    {
        MultiView_SurveyItems.ActiveViewIndex = 0;
    }

    protected void clearFields()
    {
        txtItem.Text = "";
        DDLItemTypes.SelectedValue = "0";
    }
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        SurveyItems Item = new SurveyItems();
        Item.SurveyItemText = txtItem.Text;
        Item.SurveyItemType = Convert.ToInt32(DDLItemTypes.SelectedValue);

        SurveyItemsDAL.insert(Item);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        GridView_SurveyItems.DataBind();
        MultiView_SurveyItems.ActiveViewIndex = 2;
        clearFields();
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        MultiView_SurveyItems.ActiveViewIndex = 0;
    }
}