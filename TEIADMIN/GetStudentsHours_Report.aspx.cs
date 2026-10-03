using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class GetStudentsHours_Report : System.Web.UI.Page
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
        
        params1[0] = new ReportParameter("Semester", Session["Semester_SS"].ToString(), true);
        params1[1] = new ReportParameter("Departments", Session["Department_SS"].ToString(), true);


        ReportDataSource dataSource = new ReportDataSource("DataSet90_DataTable190", (DataTable)Session["dt_table"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/GetStudentsHours_Report.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);
        ReportViewer1.Visible = true;
    }
}
