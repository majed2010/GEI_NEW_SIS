using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Data;
using TeiLib_AD;


public partial class viewEmployee : System.Web.UI.Page
{
    Employees obj_tbl_emp_data = new Employees();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fillCombos();
            Session["ShowDeleted"] = "false";
            //Bind_grid();
        }
    }
    protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    ((LinkButton)(e.Row.Cells[0].FindControl("btn_Delete"))).Attributes.Add("onclick", "return confirm('Are you sure ?. Do you want to Delete this Row Now ?.');");
        //}
        if (e.Row.RowType == DataControlRowType.Header)
            e.Row.CssClass = "header";
        //Add CSS class on normal row.
        if (e.Row.RowType == DataControlRowType.DataRow &&
            e.Row.RowState == DataControlRowState.Normal)
            e.Row.CssClass = "normal";
        //Add CSS class on alternate row.
        if (e.Row.RowType == DataControlRowType.DataRow &&
            e.Row.RowState == DataControlRowState.Alternate)
            e.Row.CssClass = "alternate";
    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //tbl_attend_masterexecuse obj_tbl_attend_masterexecuse = new tbl_attend_masterexecuse();
        if (e.CommandName == "rowDelete")
        {
            obj_tbl_emp_data.Emp_ID = int.Parse(e.CommandArgument.ToString());
            DataTable dt = EmployeesDAL.GetById(obj_tbl_emp_data.Emp_ID);
            if (dt.Rows.Count > 0)
            {
                obj_tbl_emp_data.User_Action = "del";
                obj_tbl_emp_data.Emp_Identity_Issue_date = DateTime.Parse(dt.Rows[0]["Emp_Identity_Issue_date"].ToString());
                if (dt.Rows[0]["Emp_Insurance_Job_Date"].ToString() == "")
                {
                    obj_tbl_emp_data.Emp_Insurance_Job_Date = Convert.ToDateTime("1800-01-01");
                }
                else
                {
                    obj_tbl_emp_data.Emp_Insurance_Job_Date = DateTime.Parse(dt.Rows[0]["Emp_Insurance_Job_Date"].ToString());
                }
                obj_tbl_emp_data.Emp_Job_start_date = DateTime.Parse(dt.Rows[0]["Emp_Job_start_date"].ToString());
                obj_tbl_emp_data.Emp_BDate = DateTime.Parse(dt.Rows[0]["Emp_BDate"].ToString());
                obj_tbl_emp_data.User_Action_Name = Page.User.Identity.Name;
                obj_tbl_emp_data.User_Action_Date = DateTime.Now;
                EmployeesDAL.Update(obj_tbl_emp_data);
            }
            ////obj_tbl_emp_data.Update();
            ////ObjectDataSource1.SelectParameters[0].DefaultValue = "([tbl_emp_data].user_action != 'del' or [tbl_emp_data].user_action is null)";
            //RadWindow window1 = new RadWindow();
            //window1.Title = ".:: Delete Employee ::.";
            //window1.ID = "RadWindow2";
            //window1.NavigateUrl = "Delete_Emp.aspx";
            //window1.VisibleOnPageLoad = true;
            //window1.OnClientClose = "ReloadForm";
            //window1.Width = 600;
            //window1.Skin = "Vista";
            //window1.ReloadOnShow = true;
            //window1.Height = 300;
            //RadWindowManager2.Windows.Add(window1);
            Bind_grid();
        }
        if (e.CommandName == "rowEdit")
        {

            Session["emp_ID"] = e.CommandArgument.ToString();
            Response.Redirect("EmployeeDetails.aspx");
        }
    }
    protected void btn_Add_Click(object sender, EventArgs e)
    {
        Session["emp_ID"] = 0;
        Response.Redirect("EmployeeDetails.aspx");
    }
    private void fillCombos()
    {

        DataTable dt = HR_DepartmentsDAL.GetAll();
        if (dt.Rows.Count > 0)
        {
            // obj.user_action = "Add New or user_action is null or user_action = ''";
            Dept_RCB.DataSource = dt;
            Dept_RCB.DataTextField = "Dept_Name_ara";
            Dept_RCB.DataValueField = "Dept_ID";
            Dept_RCB.DataBind();
            Dept_RCB.Items.Insert(0, new RadComboBoxItem("Select...", "0"));
        }
        //////////////////////////////////////////////////////////////
        DataTable dt1 = Emp_Job_TitleDAL.GetAll();
        if (dt1.Rows.Count > 0)
        {
            Job_RBC.DataSource = dt1;
            Job_RBC.DataTextField = "Emp_Job_Title_Name_ara";
            Job_RBC.DataValueField = "Emp_Job_Title_ID";
            Job_RBC.DataBind();
            Job_RBC.Items.Insert(0, new RadComboBoxItem("Select..", "0"));
        }
    }
    private void Bind_grid()
    {
        if (show_deleted_chk.Checked)
        {
            DataTable dt = EmployeesDAL.GetByCriteria(txt_emp_name.Text, int.Parse(Dept_RCB.SelectedItem.Value), int.Parse(Job_RBC.SelectedItem.Value), 1);
            if (dt.Rows.Count > 0)
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
        else
        {
            DataTable dt = EmployeesDAL.GetByCriteria(txt_emp_name.Text, int.Parse(Dept_RCB.SelectedItem.Value), int.Parse(Job_RBC.SelectedItem.Value), 0);
            if (dt.Rows.Count > 0)
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
    }
    protected void show_deleted_chk_CheckedChanged(object sender, EventArgs e)
    {
        if (show_deleted_chk.Checked == true)
        {
            Session["ShowDeleted"] = "true";
            fillCombos();

            //DataSet de = obj_tbl_emp_data.SearchByWhere("tbl_emp_data.user_action = 'del'");
            // ObjectDataSource1.SelectParameters[0].DefaultValue = "tbl_emp_data.user_action = 'del'";

            GridView1.DataBind();
        }
        else
            Session["ShowDeleted"] = "false";
    }
    protected void btn_Show_Click(object sender, EventArgs e)
    {
        fillCombos();
        GridView1.DataBind();
        //ObjectDataSource1.SelectParameters[0].DefaultValue = "([tbl_emp_data].emp_id = 0)";
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Bind_grid();

    }
}
