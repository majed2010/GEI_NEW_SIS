using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class StudentInfo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            btn_Search_Click();
    }



    public void btn_Search_Click()
    {
        DataTable ds_Conditional = StudentsDAL.GetById(Convert.ToInt32(Request.QueryString["StudentId"]));
        if (ds_Conditional != null && ds_Conditional.Rows.Count > 0)
        {
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.EnableExternalImages = true;
            ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable1", ds_Conditional);
            ReportViewer1.LocalReport.DataSources.Add(dataSource);
            ReportViewer1.LocalReport.ReportPath = "Reports/StudentInfo.rdlc";
            ReportViewer1.Visible = true;
        }
        else
        {
            ReportViewer1.Visible = false;
        }

    }
}
