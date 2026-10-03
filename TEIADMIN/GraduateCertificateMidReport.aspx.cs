using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class GraduateCertificateMidReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Certificate_Report"))
            PageView.ActiveViewIndex = 1;
    }
 

    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        //int credit, contact;
        DataTable table = StudentGraduatesDAL.GET_Certificates_Students_ByDepartmentId(Convert.ToInt32(departments.SelectedValue));

        Session["table"] = table;
        Session["DeptTrans"] = departments.SelectedItem.Text;

        Response.Redirect("GraduateCertificate.aspx");
    }




    protected void Button1_Click(object sender, EventArgs e)
    {
        DataTable table = StudentGraduatesDAL.GET_Certificates_Students_ByDepartmentId(Convert.ToInt32(departments.SelectedValue));

        Session["table"] = table;
        Session["DeptTrans"] = departments.SelectedItem.Text;

        Response.Redirect("GraduateCertificate_Equation.aspx");
    }
}
