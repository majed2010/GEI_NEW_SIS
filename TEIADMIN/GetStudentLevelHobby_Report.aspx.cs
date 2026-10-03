using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using Microsoft.Reporting.WebForms;

public partial class GetStudentLevelActivity_Report : System.Web.UI.Page
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
        int level_id = int.Parse(this.drp_level.SelectedValue);
        string level = this.drp_level.SelectedItem.Text;
        string hoppy = this.drp_hoppy.SelectedItem.Text;
        int hoppy_id = int.Parse(this.drp_hoppy.SelectedValue);
        DataSet students = StudentReportsDAL.Get_Student_Level_Hoppies(level_id, hoppy_id);
        if (students.Tables[0].Rows.Count > 0)
        {
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportParameter[] params1 = new ReportParameter[2];
            params1[0] = new ReportParameter("Departments", hoppy, true);
            params1[1] = new ReportParameter("Semester", level, true);
            ReportDataSource dataSource = new ReportDataSource("DataSet2_DataTable13", students.Tables[0]);
            ReportViewer1.LocalReport.DataSources.Add(dataSource);
            ReportViewer1.LocalReport.ReportPath = "Reports/GetStudentLevelHobby_Report.rdlc";
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
        Fill_levels();
        Fill_hoppies();
    }
    protected void Fill_levels()
    {
        DataTable act_all = new DataTable();
        act_all = LevelsDAL.GetAll();
        if (act_all.Rows.Count > 0)
        {
            this.drp_level.DataSource = act_all;
            this.drp_level.DataValueField = "LevelId";
            this.drp_level.DataTextField = "ArLevelName";
            this.drp_level.DataBind();
            ListItem item = new ListItem("جميع المستويات", "0");
            this.drp_level.Items.Insert(0, item);
            this.drp_level.SelectedIndex = 0;
        }
    }
    protected void Fill_hoppies()
    {
        DataTable act_all = new DataTable();
        act_all = HoppiesDAL.GetAll();
        if (act_all.Rows.Count > 0)
        {
            this.drp_hoppy.DataSource = act_all;
            this.drp_hoppy.DataValueField = "HoppyId";
            this.drp_hoppy.DataTextField = "ArHoppyName";
            this.drp_hoppy.DataBind();
            ListItem item = new ListItem("جميع الهوايات", "0");
            this.drp_hoppy.Items.Insert(0, item);
            this.drp_hoppy.SelectedIndex = 0;
        }
    }
    #endregion
   
}
