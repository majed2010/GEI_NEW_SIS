using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class failedReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("failedReport"))
            PageView.ActiveViewIndex = 1;
    }

    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        //int credit, contact;
        DataTable table = StudentGradesDAL.GetFailedStudents(Convert.ToInt32(levels.SelectedValue), Convert.ToInt32(times.Text));

        Session["table"] = table;

        Response.Redirect("FailedStudentReport.aspx");
    }




}
