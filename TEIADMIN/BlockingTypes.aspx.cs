using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;
using TeiLib;
using System.Collections.Specialized;
public partial class departments : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("BlockingTypes"))
            PageView.ActiveViewIndex = 2;
    }
    protected void grdBlockingTypes_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            e.ExceptionHandled = true;
            deleteErr.Visible = true;
        }
    }
    protected void grdBlockingTypes_SelectedIndexChanged(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        Blocktypeform.ChangeMode(FormViewMode.Edit);
    }
    protected void grdBlockingTypes_DataBound(object sender, EventArgs e)
    {
        //  btnAdd1.Visible = btnUpdate.Visible = Convert.ToBoolean(grdDepts.Rows.Count);
    }
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }
    
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        Blocktypeform.ChangeMode(FormViewMode.Insert);
    }
    protected void lnkBack_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 1;
        Blocktypeform.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void Blocktypeform_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message != "Duplicate blocking Type")
                    submitErr.Visible = true;
            }
            else
            {
                submitErr.Visible = true;
            }
            e.KeepInInsertMode = true;
            e.ExceptionHandled = true;
        }
        else
        {
            grdBlockingTypes.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }

    protected void Blocktypeform_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message != "Duplicate blocking Type")
                    
                    updateErr.Visible = true;
            }
            else
            {
                updateErr.Visible = true;
            }
            e.KeepInEditMode = true;
            e.ExceptionHandled = true;
        }
        else
        {
            grdBlockingTypes.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void Blocktypeform_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            PageView.ActiveViewIndex = 1;
    }
 
}
