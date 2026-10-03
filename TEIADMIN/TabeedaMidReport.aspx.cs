using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class TabeedaMidReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Tabeeda_Report"))
            PageView.ActiveViewIndex = 1;
    }
 

    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        //int credit, contact;
        DataTable table = StudentGradesDAL.Graduate_FinalData_Tabeeda(Convert.ToInt32(departments.SelectedValue),Convert.ToInt32(ddlYear1.SelectedValue));

        Session["table"] = table;
        Session["DeptTrans"] = departments.SelectedItem.Text;

        Response.Redirect("GraduateTabeedaTranscript.aspx");
    }




}
