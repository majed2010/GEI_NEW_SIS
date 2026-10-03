using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class StudentNotRegistered : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            btn_Search_Click();
    }



    public void btn_Search_Click()
    {
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportDataSource dataSource = new ReportDataSource("DataSet5033_DataTable12", (DataTable)Session["studentsTable"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/StudentsNotRegitered.rdlc";

        ReportViewer1.Visible = true;
    }
}
