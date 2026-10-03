using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class GetStudentsHours : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("StudentsHours"))
            PageView.ActiveViewIndex = 1;
    }

  
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
       
        DataTable table = StudentsAdvisingDAL.GetStudentsHours_Report(Convert.ToInt32(semesters.SelectedValue),Convert.ToInt32(depts.SelectedValue));
        
        Session["Semester_SS"] = semesters.SelectedItem.Text;
        Session["Department_SS"] = depts.SelectedItem.Text;
        

        Session["dt_table"] = table;

        Response.Redirect("GetStudentsHours_Report.aspx");
    }




}
