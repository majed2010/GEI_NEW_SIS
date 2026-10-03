using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class GetAllStudentsExamAttendanaceByLevel_ReportDisplay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            btn_Search_Click();
    }



    public void btn_Search_Click()
    {
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportParameter[] params1 = new ReportParameter[2];
        params1[0] = new ReportParameter("Levels", Session["LevelName"].ToString(), true);
        params1[1] = new ReportParameter("Course", Session["CourseName"].ToString(), true);
        ReportDataSource dataSource = new ReportDataSource("DataSet50_DataTable12", (DataTable)Session["studentsTable"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/StudentsExamAttendance.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);
        ReportViewer1.Visible = true;

    }
}
