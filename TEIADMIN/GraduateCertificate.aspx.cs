using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class GraduateCertificate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            GenerateReport();
    }



    public void GenerateReport()
    {
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportParameter[] params1 = new ReportParameter[1];
        params1[0] = new ReportParameter("Department", Session["DeptTrans"].ToString(), true);
        ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable3", (DataTable)Session["table"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/Graduate_Certificate.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);

        ReportViewer1.Visible = true;
    }
}
