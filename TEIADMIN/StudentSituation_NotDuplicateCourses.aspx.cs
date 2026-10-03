using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Microsoft.Reporting.WebForms;
using TeiLib;

public partial class StudentSituation_NotDuplicateCourses : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            btn_Search_Click();
    }



    public void btn_Search_Click()
    {
        //DataTable ds_Conditional = StudentsDAL.GetById(Convert.ToInt32(Request.QueryString["StudentId"]));
        //if (ds_Conditional != null && ds_Conditional.Rows.Count > 0)
        //{

        //  Session["table"] = table;

        ReportViewer1.LocalReport.DataSources.Clear();
        ReportParameter[] params1 = new ReportParameter[8];
        params1[0] = new ReportParameter("StudentCode", Session["studentCode"].ToString(), true);
        params1[1] = new ReportParameter("FullName", Session["FullName"].ToString(), true);
        params1[2] = new ReportParameter("Departments", Session["StudentDept"].ToString(), true);
        //params1[3] = new ReportParameter("Semester", Session["Semester"].ToString(), true);
        params1[3] = new ReportParameter("Level", Session["Level"].ToString(), true);
        params1[4] = new ReportParameter("GPA", Session["GPA"].ToString(), true);
        params1[5] = new ReportParameter("CompletedHours", int.Parse(Session["CompletedHours"].ToString()).ToString(), true);
        params1[6] = new ReportParameter("RegisteredHours", int.Parse(Session["RegisteredHours"].ToString()).ToString(), true);
        params1[7] = new ReportParameter("RestHours", int.Parse(Session["RestHours"].ToString()).ToString(), true);

        ReportDataSource dataSource = new ReportDataSource("DataSet150_DataTable120", (DataTable)Session["NotDuplicateTable"]);
        ReportViewer1.LocalReport.DataSources.Add(dataSource);
        ReportViewer1.LocalReport.ReportPath = "Reports/StudentSituation_NotDuplicateCourses_Report.rdlc";
        ReportViewer1.LocalReport.SetParameters(params1);



        ReportViewer1.Visible = true;
        //}
        //else
        //{
        //    ReportViewer1.Visible = false;
        //}

    }
}
