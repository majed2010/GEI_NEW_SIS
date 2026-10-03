using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class GetStudentsMilitarySession : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("StudentsMilitary"))
            PageView.ActiveViewIndex = 1;
    }

  
    protected void btnGenerate_Click(object sender, EventArgs e)
    {

        DataTable table = StudentsMilitaryEducationDAL.GetStudentsMilitaryCourse_Report(Convert.ToInt32(years.SelectedValue), Convert.ToInt32(Sessionddl.SelectedValue),Convert.ToInt32(ddlLevels.SelectedValue));

        Session["years_SS"] = years.SelectedItem.Text;
        Session["Session_SS"] = Sessionddl.SelectedItem.Text;
        

        Session["dt_table"] = table;

        Response.Redirect("GetStudentsMilitarySession_Report.aspx");
    }




}
