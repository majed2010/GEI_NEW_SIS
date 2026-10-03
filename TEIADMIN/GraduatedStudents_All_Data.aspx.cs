using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class GraduatedStudents_All_Data : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

  
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
       
        DataTable table = StudentsDAL.GraduatedStudents_All_Report(Convert.ToInt32(ddlYears.SelectedValue));
        
        Session["Departments_SS"] = ddlYears.SelectedItem.Text;
   
        

        Session["dt_table"] = table;

        Response.Redirect("GraduatedStudents_All_Data_Report.aspx");
    }




}
