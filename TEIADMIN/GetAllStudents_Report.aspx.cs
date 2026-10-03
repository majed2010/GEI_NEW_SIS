using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.Web.Configuration;

public partial class GetAllStudents_Report : System.Web.UI.Page
{
    #region Built_In_Methods
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            this.ReportViewer1.Visible = false;
            this.lbl_result.Visible = false;
            ddlSemesters.SelectedValue = WebConfigurationManager.AppSettings["ActiveSemester"].ToString();
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        
        
        DataTable students = StudentReportsDAL.GetAllStudents(Convert.ToInt32(ddlSemesters.SelectedValue));
      
           
            
            ReportViewer1.LocalReport.DataSources.Clear();
            
            ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable13", students);
            ReportViewer1.LocalReport.DataSources.Add(dataSource);
            ReportViewer1.LocalReport.ReportPath = "Reports/GetAllStudents_Report.rdlc";
            
          
            ReportViewer1.Visible = true;
            this.ReportViewer1.Visible = true;
       
       
        }
    #endregion
    

}
