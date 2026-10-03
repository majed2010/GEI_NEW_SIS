using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using Microsoft.Reporting.WebForms;

public partial class GetStudentsPerDepCertificate_Report : System.Web.UI.Page
{
    #region Built_In_Methods
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Fill_Page();
            this.ReportViewer1.Visible = false;
            this.lbl_result.Visible = false;
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        string departments = this.drp_departments.SelectedItem.Text;
        int dep_id = int.Parse(this.drp_departments.SelectedValue);
        double per_from;
        double per_to;
        int cert_year;
        if (this.txt_per_from.Text.Trim() != "")
        {
            per_from = int.Parse(this.txt_per_from.Text);
        }
        else
        {
            per_from = 0;
        }
        if (this.txt_per_to.Text.Trim() != "")
        {
            per_to = int.Parse(this.txt_per_to.Text);
        }
        else
        {
            per_to = 0;
        }
        if (this.txt_cert_year.Text.Trim() != "")
        {
            cert_year = int.Parse(this.txt_cert_year.Text);
        }
        else cert_year = 0;
        DataSet students = StudentReportsDAL.GetStudentsPer_Dep_Certificate(dep_id, per_from, per_to, cert_year);
        if (students.Tables[0].Rows.Count > 0)
        {
            string allyears, perfrom, perto;
            if (cert_year == 0)
            {
                allyears = "جميع الاعوام";
            }
            else
            {
                allyears = cert_year.ToString();
            }
            if (per_from == 0)
            {
                perfrom = "غير محدد";
            }
            else
            {
                perfrom = cert_year.ToString();
            }
            if (per_to == 0)
            {
                perto = "غير محدد";
            }
            else
            {
                perto = cert_year.ToString();
            }
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportParameter[] params1 = new ReportParameter[4];
            params1[0] = new ReportParameter("Departments", departments, true);
            params1[1] = new ReportParameter("PerFrom", perfrom, true);
            params1[2] = new ReportParameter("PerTo", perto, true);
            params1[3] = new ReportParameter("CertYear", allyears, true);
            ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable13", students.Tables[0]);
            ReportViewer1.LocalReport.DataSources.Add(dataSource);
            ReportViewer1.LocalReport.ReportPath = "Reports/GetStudentsPerDepCertificate_Report.rdlc";
            
            ReportViewer1.LocalReport.SetParameters(params1);
            ReportViewer1.Visible = true;
            this.ReportViewer1.Visible = true;
        }
        else
        {
            this.lbl_result.Visible = true;
            this.lbl_result.Text = "لا يوجد بيانات متوفرة لمدخلات البحث الحالية";
        }

        }
    #endregion
    #region Bind_Methods
    protected void Fill_Page()
    {
        DataTable dep_all = new DataTable();
        dep_all = DepartmentsDAL.GetAll();
        if (dep_all.Rows.Count > 0)
        {
            this.drp_departments.DataSource = dep_all;
            this.drp_departments.DataValueField = "DepartmentId";
            this.drp_departments.DataTextField = "ArDepartmentName";
            this.drp_departments.DataBind();
            ListItem item = new ListItem("جميع الاقسام", "0");
            this.drp_departments.Items.Insert(0, item);
            this.drp_departments.SelectedIndex = 0;
        }
    }

    #endregion

}
