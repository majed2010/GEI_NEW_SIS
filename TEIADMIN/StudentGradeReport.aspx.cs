using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class StudentGradeReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            btn_Search_Click();
    }



    public void btn_Search_Click()
    {
        ReportViewer1.LocalReport.DataSources.Clear();


        ReportParameter[] params1 = new ReportParameter[13];
        params1[0] = new ReportParameter("Departments", Session["StudentDeptRpt"].ToString(), true);
        params1[1] = new ReportParameter("Semester", Session["SemesterRpt"].ToString(), true);
        params1[2] = new ReportParameter("CourseName", Session["CourseName"].ToString(), true);


        params1[3] = new ReportParameter("SuccessCount", Session["successCount"].ToString(), true);
        params1[4] = new ReportParameter("FailCount", Session["failCount"].ToString(), true);
        params1[5] = new ReportParameter("AbsentCount", Session["absentCount"].ToString(), true);
        params1[6] = new ReportParameter("AttendCount", Session["attendCount"].ToString(), true);
        params1[7] = new ReportParameter("RecordsCount", Session["recordsCount"].ToString(), true);
        params1[8] = new ReportParameter("SuccessPercentage",(Math.Round(Convert.ToDecimal(Session["successCount"].ToString()) / Math.Round((Convert.ToDecimal(Session["attendCount"].ToString()) == 0 ? 1 : Convert.ToDecimal(Session["attendCount"].ToString())), 2) * 100, 2)).ToString() + "%"  , true);
        params1[9] = new ReportParameter("FailPercentage", (Math.Round(Convert.ToDecimal(Session["failCount"].ToString()) / Math.Round((Convert.ToDecimal(Session["attendCount"].ToString()) == 0 ? 1 : Convert.ToDecimal(Session["attendCount"].ToString())), 2) * 100, 2)).ToString() + "%", true);
        params1[10] = new ReportParameter("AttendPercentage", (Math.Round(Convert.ToDecimal(Session["attendCount"].ToString()) / Math.Round((Convert.ToDecimal(Session["recordsCount"].ToString()) == 0 ? 1 : Convert.ToDecimal(Session["recordsCount"].ToString())), 2) * 100, 2)).ToString() + "%", true);
        params1[11] = new ReportParameter("AbsencePercentage", (Math.Round(Convert.ToDecimal(Session["absentCount"].ToString()) / Math.Round((Convert.ToDecimal(Session["recordsCount"].ToString()) == 0 ? 1 : Convert.ToDecimal(Session["recordsCount"].ToString())), 2) * 100, 2)).ToString() + "%", true);
        params1[12] = new ReportParameter("MemberName", Session["MemberName"].ToString(), true);
        ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable122", (DataTable)Session["table"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/StudentGrades.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);
        ReportViewer1.Visible = true;
    }

  
}
