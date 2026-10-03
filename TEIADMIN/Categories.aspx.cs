using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class Categories : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        { 
        }
    }
    protected void lnkBack_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 1;
        CategoryForm.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        CategoryForm.ChangeMode(FormViewMode.Insert);
    }
    protected void CategoriesGrid_SelectedIndexChanged(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        CategoryForm.ChangeMode(FormViewMode.Edit);
    }
    protected void CategoriesGrid_DataBound(object sender, EventArgs e)
    {
        btnAdd1.Visible = Convert.ToBoolean(CategoriesGrid.Rows.Count);
    }
    protected void CategoriesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int currId = int.Parse(e.CommandArgument.ToString());
        if (e.CommandName == "prereq")
        {
        }
        else if (e.CommandName == "category")
        {
        }
    }

    protected void CategoryForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate Category")
                    UserErr.Visible = true;
                else
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
            CategoriesGrid.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void CategoryForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
      
    }
    protected void CategoryForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate Category")
                    UserErr.Visible = true;
                else
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
            CategoriesGrid.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void CategoryForm_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
      
    }
    protected void CategoryForm_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            PageView.ActiveViewIndex = 1;
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        CategoriesDS.SelectParameters["categoryName"].DefaultValue = txtCategoryName.Text;
    }
}
