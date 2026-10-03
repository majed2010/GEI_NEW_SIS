using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;
using TeiLib;
using System.Collections.Specialized;

public partial class hoppies : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Hoppies"))
            PageView.ActiveViewIndex = 2;
    }
    protected void grdHoppies_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            e.ExceptionHandled = true;
            deleteErr.Visible = true;
        }
    }
    protected void grdHoppies_SelectedIndexChanged(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        HoppiesForm.ChangeMode(FormViewMode.Edit);
    }
    protected void grdHoppies_DataBound(object sender, EventArgs e)
    {
        btnAdd1.Visible = btnUpdate.Visible = Convert.ToBoolean(grdHoppies.Rows.Count);
    }
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        CheckBox CKHide, CKOld;
        DataRow dr;
        DataTable dt = new DataTable();
        dt.Columns.Add("ID", Type.GetType("System.Int32"));
        foreach (GridViewRow row in grdHoppies.Rows)
        {
            CKHide = row.FindControl("CKHide") as CheckBox;
            CKOld = row.FindControl("CKOld") as CheckBox;
            if (CKHide.Checked != CKOld.Checked)
            {
                dr = dt.NewRow();
                dr["ID"] = grdHoppies.DataKeys[row.RowIndex].Value;
                dt.Rows.Add(dr);
            }
        }
        if (dt.Rows.Count > 0)
        {
            string ss = dt.Rows[0]["ID"].ToString();
            Common.HideRows(dt, "Hoppies", "HoppyId");
            grdHoppies.DataBind();
        }
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        HoppiesForm.ChangeMode(FormViewMode.Insert);
    }
    protected void lnkBack_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 1;
        HoppiesForm.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void HoppiesForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate Hoppy")
                    TitleErr.Visible = true;
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
            grdHoppies.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void HoppiesForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate Hoppy")
                    TitleErr.Visible = true;
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
            grdHoppies.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void HoppiesForm_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            PageView.ActiveViewIndex = 1;
    }
}
