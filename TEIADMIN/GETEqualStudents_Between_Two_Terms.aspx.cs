using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class GETEqualStudents_Between_Two_Terms : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("EqualStudentsBetweenTwoTerms"))
            PageView.ActiveViewIndex = 1;
    }

  
    protected void btnGenerate_Click(object sender, EventArgs e)
    {

        DataTable table = StudentsAdvisingDAL.StudentsAdvising_EqualStudents_Between_Two_Terms(Convert.ToInt32(NewsemestersDb.SelectedValue), Convert.ToInt32(OldsemestersDb.SelectedValue));
        
        Session["NewSemester_SS"] = NewsemestersDb.SelectedItem.Text;
        Session["OldSemester_SS"] = OldsemestersDb.SelectedItem.Text;
        

      Session["dt_table"] = table;

      Response.Redirect("GETEqualStudents_Between_Two_Terms_Report.aspx");
    }
    

}
