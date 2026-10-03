using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Collections;
using TeiLib;
using System.Collections.Specialized;

public partial class admin_users : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ArrayList sections = CurrentUser.GetUserRoleAndSections();
            if (!sections[0].Equals("1"))
                PageView.ActiveViewIndex = 2;
        }

    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        Userform.ChangeMode(FormViewMode.Insert);
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        CheckBox CKHide, CKOld;
        DataRow dr;
        DataTable dt = new DataTable();
        dt.Columns.Add("ID", Type.GetType("System.Int32"));
        foreach (GridViewRow row in grdUsers.Rows)
        {
            CKHide = row.FindControl("CKHide") as CheckBox;
            CKOld = row.FindControl("CKOld") as CheckBox;
            if (CKHide.Checked != CKOld.Checked)
            {
                dr = dt.NewRow();
                dr["ID"] = grdUsers.DataKeys[row.RowIndex].Value;
                dt.Rows.Add(dr);
            }
        }
        if (dt.Rows.Count > 0)
        {
            string ss = dt.Rows[0]["ID"].ToString();
            Common.HideRows(dt, "Users", "UserId");
            grdUsers.DataBind();
        }
    }
    protected void grdUsers_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            e.ExceptionHandled = true;
            deleteErr.Visible = true;
        }
    }
    protected void grdUsers_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridViewRow row = grdUsers.SelectedRow;
        Label UserName = row.Cells[4].FindControl("UserName") as Label;
        Label role = row.Cells[4].FindControl("Role") as Label;

        //if (role.Text == "Administrator" && UserName.Text != User.Identity.Name)
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "alert('You are not permitted to modify this account');", true);

        //    grdUsers.SelectedIndex = -1;
        //}
        //else
        //{
            PageView.ActiveViewIndex = 0;
            Userform.ChangeMode(FormViewMode.Edit);
        //}
    }
    protected void grdUsers_DataBound(object sender, EventArgs e)
    {
        btnAdd1.Visible = btnUpdate.Visible = Convert.ToBoolean(grdUsers.Rows.Count);
    }
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }

    protected void lnkBack_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 1;
        Userform.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void Userform_DataBound(object sender, EventArgs e)
    {
        if (Userform.CurrentMode == FormViewMode.Edit)
        {
            User usr = Userform.DataItem as User;
            if (usr.RoleId != 1)
            {
                ListBox lb = Userform.Controls[0].FindControl("Sections") as ListBox;
                for (int i = 0; i < usr.Sections.Count; i++)
                    lb.Items.FindByValue(usr.Sections.Get(i)).Selected = true;
            }
        }
    }
    protected void Userform_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate User")
                    UserErr.Visible = true;
                else if (e.Exception.InnerException.Message == "Duplicate Email")
                    EmailErr.Visible = true;
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
            grdUsers.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void Userform_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        if (Convert.ToByte(e.Values["RoleId"]) != 1)
        {
            ListBox lb = Userform.Controls[0].FindControl("Sections") as ListBox;
            NameValueCollection sections = new NameValueCollection();

            foreach (ListItem item in lb.Items)
            {
                if (item.Selected)
                    sections.Add(null, item.Value);
            }

            e.Values["Sections"] = sections;
        }

        e.Values["Password"] = e.Values["Password"];
    }
    protected void Userform_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate User")
                    UserErr.Visible = true;
                else if (e.Exception.InnerException.Message == "Duplicate Email")
                    EmailErr.Visible = true;
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
            grdUsers.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void Userform_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        if (Convert.ToByte(e.NewValues["RoleId"]) != 1)
        {
            ListBox lb = Userform.Controls[0].FindControl("Sections") as ListBox;
            NameValueCollection sections = new NameValueCollection();

            foreach (ListItem item in lb.Items)
            {
                if (item.Selected)
                    sections.Add(null, item.Value);
            }

            e.NewValues["Sections"] = sections;
        }

        TextBox Pass = Userform.FindControl("txtPassword") as TextBox;
        if (Pass.Text == "")
            e.NewValues["Password"] = e.OldValues["Password"];
        else
            e.NewValues["Password"] = Pass.Text;
    }
    protected void Userform_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            PageView.ActiveViewIndex = 1;
    }
}
