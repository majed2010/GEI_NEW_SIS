using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class Students_Record_EnrollmentData_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            btn_Search_Click();
    }



    public void btn_Search_Click()
    {
        ReportViewer1.LocalReport.DataSources.Clear();

        ReportParameter[] params1 = new ReportParameter[1];

        params1[0] = new ReportParameter("Years", Session["Semester_SS"].ToString(), true);
        


        ReportDataSource dataSource = new ReportDataSource("DataSet84_DataTable180", (DataTable)Session["dt_table"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/Students_Record_Enrollment_Report.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);
        ReportViewer1.Visible = true;
    }
}
