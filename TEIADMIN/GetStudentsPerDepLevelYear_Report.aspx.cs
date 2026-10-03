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

public partial class GetStudentsPerDepLevelYear_Report : System.Web.UI.Page
{
    #region Built_In_Methods
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Fill_Page();
            this.ReportViewer1.Visible = false;
            this.lbl_result.Visible = false;
            ddlSemesters.SelectedValue = WebConfigurationManager.AppSettings["ResultActiveSemester"].ToString();
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        string departments = this.drp_departments.SelectedItem.Text;
        int dep_id = int.Parse(this.drp_departments.SelectedValue);
        int level_id = int.Parse(this.ddl_levels.SelectedValue);
        string level_text = this.ddl_levels.SelectedItem.Text;
        int year;
        if (this.txt_year.Text.Trim() != "")
        {
            year = int.Parse(this.txt_year.Text);
        }
        else
        {
            year= 0;
        }
        int YearId = Convert.ToInt32(ddlYears.SelectedValue);
        DataSet students = StudentReportsDAL.GetStudentsPer_Level_Dep_Year(dep_id, level_id,YearId, year,Convert.ToInt32(ddlSemesters.SelectedValue));
        if (students.Tables[0].Rows.Count > 0)
        {
            string allyears;
            if (year == 0)
            {
                allyears = "جميع الاعوام";
            }
            else
            {
                allyears = year.ToString();
            }
            
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportParameter[] params1 = new ReportParameter[3];
            params1[0] = new ReportParameter("Departments", departments, true);
            params1[1] = new ReportParameter("Year", allyears, true);
            params1[2] = new ReportParameter("Level", level_text, true);
            ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable13", students.Tables[0]);
            ReportViewer1.LocalReport.DataSources.Add(dataSource);
            ReportViewer1.LocalReport.ReportPath = "Reports/GetStudentsPerDepLevelYear_Report.rdlc";
            
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
        DataTable level_all = new DataTable();
        level_all = LevelsDAL.GetAll();
        if (level_all.Rows.Count > 0)
        {
            this.ddl_levels.DataSource = level_all;
            this.ddl_levels.DataValueField = "LevelId";
            this.ddl_levels.DataTextField = "ArLevelName";
            this.ddl_levels.DataBind();
            ListItem item = new ListItem("جميع المستويات", "0");
            this.ddl_levels.Items.Insert(0, item);
            this.ddl_levels.SelectedIndex = 0;
        }
    }

    #endregion

}
