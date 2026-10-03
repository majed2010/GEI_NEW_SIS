using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class StudentGradeReporforPerformances : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            btn_Search_Click();
    }



    public void btn_Search_Click()
    {
        ReportViewer1.LocalReport.DataSources.Clear();

        ReportParameter[] params1 = new ReportParameter[4];
        params1[0] = new ReportParameter("Departments", Session["StudentDeptRpt"].ToString(), true);
        params1[1] = new ReportParameter("Semester", Session["SemesterRpt"].ToString(), true);
        params1[2] = new ReportParameter("CourseName", Session["CourseName"].ToString(), true);
        params1[3] = new ReportParameter("MemberName", Session["MemberName"].ToString(), true);
        ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable122", (DataTable)Session["table"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/StudentGradesforperformanes.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);
        ReportViewer1.Visible = true;
    }
}
