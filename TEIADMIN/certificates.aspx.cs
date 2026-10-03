using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;
using TeiLib;
using System.Collections.Specialized;

public partial class certificates : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Army Cases"))
            PageView.ActiveViewIndex = 2;
    }
    protected void grdCertificates_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            e.ExceptionHandled = true;
            deleteErr.Visible = true;
        }
    }
    protected void grdCertificates_SelectedIndexChanged(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        CertificateForm.ChangeMode(FormViewMode.Edit);
    }
    protected void grdCertificates_DataBound(object sender, EventArgs e)
    {
        btnAdd1.Visible = btnUpdate.Visible = Convert.ToBoolean(grdCertificates.Rows.Count);
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
        foreach (GridViewRow row in grdCertificates.Rows)
        {
            CKHide = row.FindControl("CKHide") as CheckBox;
            CKOld = row.FindControl("CKOld") as CheckBox;
            if (CKHide.Checked != CKOld.Checked)
            {
                dr = dt.NewRow();
                dr["ID"] = grdCertificates.DataKeys[row.RowIndex].Value;
                dt.Rows.Add(dr);
            }
        }
        if (dt.Rows.Count > 0)
        {
            string ss = dt.Rows[0]["ID"].ToString();
            Common.HideRows(dt, "Activities", "ActivityId");
            grdCertificates.DataBind();
        }
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        CertificateForm.ChangeMode(FormViewMode.Insert);
    }
    protected void lnkBack_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 1;
        CertificateForm.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void CertificateForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate Product")
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
            grdCertificates.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }

    protected void CertificateForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate Activity")
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
            grdCertificates.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void CertificateForm_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            PageView.ActiveViewIndex = 1;
    }
}
