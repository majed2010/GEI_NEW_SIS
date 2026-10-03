using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Documents : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 1;
    }
    protected void DocumentGrid_DataBound(object sender, EventArgs e)
    {

    }
    protected void DocumentGrid_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception!=null || e.AffectedRows<=0)
        {
            e.ExceptionHandled = true;
            DeleteError.Visible = true;
        }
    }
    protected void DocumentGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        DocumentForm.ChangeMode(FormViewMode.Edit);
    }
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }
   
    protected void DocumentForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception!=null)
        {
            if (e.Exception.InnerException!=null )
            {
                if (e.Exception.InnerException.Message!="Duplicate Document")
                    ErrorSave.Visible = true;
                 
            }
            else
            {
                ErrorSave.Visible = true;
            }
            e.KeepInInsertMode = true;
            e.ExceptionHandled = true;
        }
        else
        {
            DocumentGrid.DataBind();
            PageView.ActiveViewIndex = 1;
        }

    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 1;
        DocumentForm.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void DocumentForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        if (e.Exception!=null )
        {
            if (e.Exception.InnerException !=null )
            {
                if (e.Exception.InnerException.Message != "Duplicate Document")
                    ErrorUpdate.Visible = true;
            }
            else
            {
                ErrorUpdate.Visible = true;
            }
            e.KeepInEditMode = true;
            e.ExceptionHandled = true;
        }
        else
        {
            DocumentGrid.DataBind();
            
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void DocumentForm_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit )
        
            PageView.ActiveViewIndex = 1;
       
    }
    
    protected void FormDataSource_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {

    }


    protected void lbtnAdd_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        DocumentForm.ChangeMode(FormViewMode.Insert);
    }
}