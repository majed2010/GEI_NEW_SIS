using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class Exceeds_Six_Semesters : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Exceeds_Six_Semesters"))
            PageView.ActiveViewIndex = 1;
    }

  
    protected void btnGenerate_Click(object sender, EventArgs e)
    {

        DataTable table = StudentsAdvisingDAL.Exceeds_Six_Semesters_Report(Convert.ToInt32(depts.SelectedValue));
        Session["Department_SS"] = depts.SelectedItem.Text;
      
        

        Session["dt_table2"] = table;

        Response.Redirect("Exceeds_Six_Semesters_Report.aspx");
    }




}
