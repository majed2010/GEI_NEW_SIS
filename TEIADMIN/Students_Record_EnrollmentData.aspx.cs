using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class Students_Record_EnrollmentData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("StudentsEnrollmentReport"))
            PageView.ActiveViewIndex = 1;
    }

  
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
       
        DataTable table = StudentsDAL.Students_Record_Enrollment_Report(Convert.ToInt32(ddlYears.SelectedValue));
        
        Session["Semester_SS"] = ddlYears.SelectedItem.Text;
   
        

        Session["dt_table"] = table;

        Response.Redirect("Students_Record_EnrollmentData_Report.aspx");
    }




}
