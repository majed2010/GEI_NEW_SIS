using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;

public partial class locations : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Regions"))
            PageView.ActiveViewIndex = 2;
    }
    protected void grdLocations_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            e.ExceptionHandled = true;
            deleteErr.Visible = true;
        }
    }
    protected void grdLocations_SelectedIndexChanged(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        LocationschkList.Visible = false;
      
        LocationForm.ChangeMode(FormViewMode.Edit);
    }
    protected void grdLocations_DataBound(object sender, EventArgs e)
    {
        btnAdd1.Visible = btnUpdate.Visible = Convert.ToBoolean(grdLocations.Rows.Count);
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
        foreach (GridViewRow row in grdLocations.Rows)
        {
            CKHide = row.FindControl("CKHide") as CheckBox;
            CKOld = row.FindControl("CKOld") as CheckBox;
            if (CKHide.Checked != CKOld.Checked)
            {
                dr = dt.NewRow();
                dr["ID"] = grdLocations.DataKeys[row.RowIndex].Value;
                dt.Rows.Add(dr);
            }
        }
        if (dt.Rows.Count > 0)
        {
            string ss = dt.Rows[0]["ID"].ToString();
            Common.HideRows(dt, "Locations", "LocationId");
            grdLocations.DataBind();
        }
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        LocationForm.ChangeMode(FormViewMode.Insert);
        LocationschkList.SelectedIndex = 0;
        LocationschkList.Visible = true;
    }
    protected void lnkBack_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 1;
        LocationForm.ChangeMode(FormViewMode.ReadOnly);
    }
    protected void LocationForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate Year")
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
            grdLocations.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }

    protected void LocationForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message == "Duplicate Year")
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
            grdLocations.DataBind();
            PageView.ActiveViewIndex = 1;
        }
    }
    protected void LocationForm_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            PageView.ActiveViewIndex = 1;
    }
    protected void LocationschkList_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (LocationschkList.SelectedItem.Value == "1")
        {
            ((PlaceHolder)LocationForm.Controls[0].FindControl("CountryHolder")).Visible = true;
            ((PlaceHolder)LocationForm.Controls[0].FindControl("CityHolder")).Visible = false;
            LocationsDS.SelectParameters[0].DefaultValue = "1";
            LocationsDS.DataBind();
            ((DropDownList)LocationForm.Controls[0].FindControl("ddlCountry")).Items.Clear();
            ((DropDownList)LocationForm.Controls[0].FindControl("ddlCountry")).Items.Insert(0,new ListItem("-- Select --","0"));
            ((DropDownList)LocationForm.Controls[0].FindControl("ddlCountry")).DataSource = LocationsDS;
            ((DropDownList)LocationForm.Controls[0].FindControl("ddlCountry")).DataBind();// = false;
          
        }
        else if (LocationschkList.SelectedItem.Value == "2")
        {
            ((PlaceHolder)LocationForm.Controls[0].FindControl("CountryHolder")).Visible = false;
            ((PlaceHolder)LocationForm.Controls[0].FindControl("CityHolder")).Visible = true;
            LocationsDS.SelectParameters[0].DefaultValue = "2";
            LocationsDS.DataBind();
            ((DropDownList)LocationForm.Controls[0].FindControl("ddlCity")).Items.Clear();
            ((DropDownList)LocationForm.Controls[0].FindControl("ddlCity")).Items.Insert(0, new ListItem("-- Select --", "0"));
            ((DropDownList)LocationForm.Controls[0].FindControl("ddlCity")).DataSource = LocationsDS;
            ((DropDownList)LocationForm.Controls[0].FindControl("ddlCity")).DataBind();
        }
        else
        {
            ((PlaceHolder)LocationForm.Controls[0].FindControl("CountryHolder")).Visible = false;
            ((PlaceHolder)LocationForm.Controls[0].FindControl("CityHolder")).Visible = false;
          
        }
    }
    protected void LocationForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        if (LocationschkList.SelectedItem.Value == "1")
        {
            e.Values["Type"] = "2";
            e.Values["ParentId"] = ((DropDownList)LocationForm.Controls[0].FindControl("ddlCountry")).SelectedItem.Value;

        }
        else if (LocationschkList.SelectedItem.Value == "2")
        {
            e.Values["Type"] = "3";
            e.Values["ParentId"] = ((DropDownList)LocationForm.Controls[0].FindControl("ddlCity")).SelectedItem.Value;
        }
        else
        {
            e.Values["Type"] = "1";
            e.Values["ParentId"] = "0";
        }
    }
}
