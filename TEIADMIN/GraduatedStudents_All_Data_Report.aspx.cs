using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class GraduatedStudents_All_Data_Report : System.Web.UI.Page
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

        params1[0] = new ReportParameter("Department", Session["Departments_SS"].ToString(), true);



        ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable3", (DataTable)Session["dt_table"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/GraduatedStudents_All_Report.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);
        ReportViewer1.Visible = true;
    }
}
