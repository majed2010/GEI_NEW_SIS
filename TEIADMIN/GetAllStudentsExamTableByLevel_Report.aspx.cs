using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.Collections;

public partial class GetAllStudentsExamTableByLevel_Report : System.Web.UI.Page
{
    #region Built_In_Methods
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("StudentsSituationCollection"))
        {
            MultiView1.ActiveViewIndex = 1;
        }
      
        if (!IsPostBack)
        {
            Fill_Page();

        }
    }
    #endregion
    #region Bind_Methods
    protected void Fill_Page()
    {
        Fill_levels();

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

    #endregion
    protected void Button1_Click(object sender, EventArgs e)
    {
        int level_id = int.Parse(this.drp_level.SelectedValue);
        string semester = this.drp_level.SelectedItem.Text;
        
        DataTable studentsTable = StudentsDAL.GetStudentExamDate_ByLevelId(level_id);
        Session["studentsTable"] = studentsTable;
        Response.Redirect("GetAllStudentsExamTableByLevel_ReportDisplay.aspx");

    }
}
