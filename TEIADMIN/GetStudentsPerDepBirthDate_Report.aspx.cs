using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using Microsoft.Reporting.WebForms;

public partial class GetStudentsPerDepBirthDate_Report : System.Web.UI.Page
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
        int level_id = int.Parse(this.ddl_levels.SelectedValue);
        string level = this.ddl_levels.SelectedItem.Text;
        DateTime birthfrom = DateTime.Now;
        DateTime birthto = DateTime.Now;
        int gendre = -1;
        string gendre_text = this.ddl_gendre.SelectedItem.Text;
        if (this.txt_birth_from.Text.ToString() != "" && this.txt_birth_to.Text.ToString() != "")
        {
            if (DateTime.Parse(this.txt_birth_from.Text.ToString()) > DateTime.Parse(this.txt_birth_to.Text.ToString()))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "newWindow", "<script>alert('Date from must be less than date to');</script>");
                return;
            }
        }

        if (this.ddl_gendre.SelectedValue == "3")
        {
            gendre = -1;
        }
        else gendre = int.Parse(this.ddl_gendre.SelectedValue.ToString());
        if (this.txt_birth_from.Text != "")
        {
            birthfrom = DateTime.Parse(this.txt_birth_from.Text);
        }
        else
        {
            birthfrom = DateTime.Parse("1-1-1900");
        }
        if (this.txt_birth_to.Text.Trim() != "")
        {
            birthto = DateTime.Parse(this.txt_birth_to.Text);
        }
        else
        {
            birthto = DateTime.Parse("1-1-2015");
        }
        DataSet students = StudentReportsDAL.GetStudentsPer_Level_Dep_Birth_Gendre(dep_id, level_id,
            gendre, birthfrom, birthto);
        if (students.Tables[0].Rows.Count > 0)
        {
            string  birth_from, birth_to;
            
            if (birthfrom == DateTime.Parse("1-1-1900"))
            {
                birth_from = "غير محدد";
            }
            else
            {
                birth_from = birthfrom.ToShortDateString();
            }
            if (birthto == DateTime.Parse("1-1-2015"))
            {
                birth_to= "غير محدد";
            }
            else
            {
                birth_to = birthto.ToShortDateString();
            }
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportParameter[] params1 = new ReportParameter[5];
            params1[0] = new ReportParameter("Departments", departments, true);
            params1[1] = new ReportParameter("Gendre", gendre_text, true);
            params1[2] = new ReportParameter("BirthFrom", birth_from, true);
            params1[3] = new ReportParameter("BirthTo", birth_to, true);
            params1[4] = new ReportParameter("Level", level, true);
            ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable13", students.Tables[0]);
            ReportViewer1.LocalReport.DataSources.Add(dataSource);
            ReportViewer1.LocalReport.ReportPath = "Reports/GetStudentsPerDepBirthDate_Report.rdlc";

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
