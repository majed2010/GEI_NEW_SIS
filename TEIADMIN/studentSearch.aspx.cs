using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Text.RegularExpressions;
using System.IO;
using System.Globalization;
using System.Collections;
using TeiLib;

public partial class studentSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Students Search"))
            PageView.ActiveViewIndex = 2;

        this.Form.Attributes.Add("enctype", "multipart/form-data");

    }

    
    
    protected void StudentsDS_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.ReturnValue != null)
            lblStudentId.Text = e.ReturnValue.ToString();
        else
            lblStudentId.Text = "0";
    }
    protected void grdStudents_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            e.ExceptionHandled = true;
            deleteErr.Visible = true;
        }
    }
    protected void grdStudents_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void grdStudents_DataBound(object sender, EventArgs e)
    {
        //btnAdd1.Visible = Convert.ToBoolean(grdStudents.Rows.Count);
    }
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }

    protected void StudentsDataSource_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        if (!e.ExecutingSelectCount)
        {
            e.InputParameters["StudentCode"] = txtٍStudentCode.Text;
            e.InputParameters["ArFirstName"] = txtFirstName.Text;
            e.InputParameters["ArMiddleName"] = txtSecondName.Text;
            e.InputParameters["ArLastName"] = txtLastName.Text;
            e.InputParameters["SemesterId"] = semesters31.SelectedValue.ToString();
            e.InputParameters["YearId"] = years31.SelectedValue.ToString();
            e.InputParameters["DepartmentId"] = departmentDDL.SelectedValue.ToString();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdStudents.DataBind();
    }
}
