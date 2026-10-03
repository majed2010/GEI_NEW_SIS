using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class CoursesStatistics_Grades_All_Report : System.Web.UI.Page
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
        params1[0] = new ReportParameter("Departments", Session["Department_SS"].ToString(), true);
     


        ReportDataSource dataSource = new ReportDataSource("DataSet6522_DataTable1220", (DataTable)Session["dt_table2"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/CoursesStatistics_ByGrades_All.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);
        ReportViewer1.Visible = true;
    }
}
