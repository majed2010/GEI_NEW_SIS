using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;

public partial class ItemsTypeForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("QC"))
            MultiView_ItemsType.ActiveViewIndex = 3;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        ItemsType Item = new ItemsType();
        Item.ItemName= txtItemType.Text;
        Item.SurveyType = Convert.ToInt32(ddlSurveyTypes.SelectedValue);
        ItemsTypeDAL.insert(Item);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        GridView_ItemsType.DataBind();
        MultiView_ItemsType.ActiveViewIndex = 2;
        clearfield();
    }
    protected void clearfield()
    {
        txtItemType.Text = "";
        ddlSurveyTypes.SelectedValue="0";
    }

    protected void btnCancelSave_Click(object sender, EventArgs e)
    {
        MultiView_ItemsType.ActiveViewIndex = 2;
        clearfield();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        ItemsType Item = new ItemsType();
        Item.ItemId = Convert.ToInt32(HFItemId.Value);
        Item.ItemName = txtItemTypeUpdate.Text;
        Item.SurveyType = Convert.ToInt32(ddlSurveyTypes.SelectedValue);
        ItemsTypeDAL.Update(Item);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم التعديل')", true);
        GridView_ItemsType.DataBind();
        MultiView_ItemsType.ActiveViewIndex = 2;
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        MultiView_ItemsType.ActiveViewIndex = 2;
        clearfield();
    }
    protected void btnNew_Click(object sender, EventArgs e)
    {
        MultiView_ItemsType.ActiveViewIndex = 0;
    }
    protected void GridView_ItemsType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
            int ItemId = Convert.ToInt32(e.CommandArgument);
            ItemsType Item = ItemsTypeDAL.GetItemTypeById(ItemId);
            txtItemTypeUpdate.Text = Item.ItemName;
            ddlSurveyTypesUpdate.SelectedValue = Convert.ToString(Item.SurveyType);
            HFItemId.Value = Convert.ToString(Item.ItemId);
            MultiView_ItemsType.ActiveViewIndex = 1;
        }
    }
}