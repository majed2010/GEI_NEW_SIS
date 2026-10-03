using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Collections;
using System.Data;

public partial class transcriptMidReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("NatigaForLevel"))
            PageView.ActiveViewIndex = 1;
        if (!IsPostBack)
            FillLevels();
    }
    private void FillLevels()
    {
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


    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        //int credit, contact;
        DataTable table = StudentGradesDAL.GetTranscript(Convert.ToInt32(ddlYear1.SelectedValue), Convert.ToInt32(departments.SelectedValue),  Convert.ToInt32(ddl_levels.SelectedValue),Convert.ToInt32(hamadaType.SelectedValue));

        Session["table"] = table;
        Session["DeptTrans"] = departments.SelectedItem.Text;
        Session["Levels"] = ddl_levels.SelectedValue;
        Response.Redirect("StudentTranscript.aspx");
    }




}
