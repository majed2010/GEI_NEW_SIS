using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class GraduateCertificateByStudentCodeMidReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Certificate_By_Student_Report"))
            PageView.ActiveViewIndex = 1;
    }
 

    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        //int credit, contact;
        DataTable table = StudentGraduatesDAL.GET_Certificates_Students_ByStudentCode(txtStudentCode.Text);

        Session["table"] = table;
        Session["StuCode"] = txtStudentCode.Text;

        Response.Redirect("GraduateCertificateByStudentCode.aspx");
    }




    protected void Button1_Click(object sender, EventArgs e)
    {
        DataTable table = StudentGraduatesDAL.GET_Certificates_Students_ByStudentCode(txtStudentCode.Text);

        Session["table"] = table;
        Session["StuCode"] = txtStudentCode.Text;

        Response.Redirect("Graduate_CertificateByStudentCode_Equation.aspx");
    }
}
