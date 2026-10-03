using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;

public partial class MembersTypeForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("QC"))
            MultiView_MembersType.ActiveViewIndex = 3;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MembersType Type = new MembersType();
        Type.MemberTypeName = txtMemberType.Text;
        MembersTypeDAL.insert(Type);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحفظ')", true);
        GridView_MembersType.DataBind();
        MultiView_MembersType.ActiveViewIndex = 2;
    }
    protected void btnCancelSave_Click(object sender, EventArgs e)
    {
        MultiView_MembersType.ActiveViewIndex = 2;
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MembersType Type = new MembersType();
        Type.MemberTypeId = Convert.ToInt32(HFMemberTypeId.Value);
        Type.MemberTypeName = txtMemberTypeUpdate.Text;
        MembersTypeDAL.Update(Type);
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم التعديل')", true);
        GridView_MembersType.DataBind();
        MultiView_MembersType.ActiveViewIndex = 2;
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        MultiView_MembersType.ActiveViewIndex = 2;
    }
    protected void btnNew_Click(object sender, EventArgs e)
    {
        MultiView_MembersType.ActiveViewIndex = 0;
    }
    protected void GridView_MembersType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
            int ID = Convert.ToInt32(e.CommandArgument);
            MembersType Type = MembersTypeDAL.GetMemberTypeById(ID);
            txtMemberTypeUpdate.Text = Type.MemberTypeName;
            HFMemberTypeId.Value = Convert.ToString(Type.MemberTypeId);
            MultiView_MembersType.ActiveViewIndex = 1;
        }
    }
}