using System;
using System.Web.UI.WebControls;
using System.Data;

using System.Web.UI;
using TeiLib_AD;
using Telerik.Web.UI;
using System.Data.SqlClient;

public partial class EmployeeDetails : System.Web.UI.Page
{

Employees obj_tbl_emp_data = new Employees();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fillcmb();

            ViewState["Emp_ID"] = Session["emp_ID"];
            
            if (Session["ShowDeleted"].ToString() == "true")
            {
                obj_tbl_emp_data.User_Action = "del";
                //Button1.Visible = true;
                //Button4.Visible = true;
                btn_Save.Visible = false;
                btn_Save2.Visible = false;
                btn_Save3.Visible = false;
                Button2.Visible = false;
                // Button5.Visible = false;
            }
            else
            {
                // Button1.Visible = false;
                //Button4.Visible = false;
                btn_Save.Visible = true;
                btn_Save2.Visible = true;
                btn_Save3.Visible = true;
                Button2.Visible = true;
                //Button5.Visible = true;
            }
            DataTable dt = TeiLib_AD.EmployeesDAL.GetById(int.Parse(ViewState["Emp_ID"].ToString()));
            if (dt.Rows.Count > 0)
            {
                Div_add_work_prev.Visible = false;
                add_cert.Visible = false;
                bind_prev_work();
                bind_sc_Cert();
                txt_Emp_First_Name.Text = dt.Rows[0]["Emp_Ara_Fname"].ToString();
                txt_Emp_Second_Name.Text = dt.Rows[0]["Emp_Ara_Mname"].ToString();
                txt_Family_Name.Text = dt.Rows[0]["Emp_Ara_Lname"].ToString();
                txt_Full_Name.Text = txt_Emp_First_Name.Text + " " + txt_Emp_Second_Name.Text + " " + txt_Family_Name.Text;
                //////////////////////////////////////////////////////////////////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////////////////////////
                txt_Address.Text = dt.Rows[0]["Emp_Address"].ToString();
                txt_Home_Tel.Text = dt.Rows[0]["Emp_Home_Tel"].ToString();
                txt_Mobile.Text = dt.Rows[0]["Emp_Mobile"].ToString();
                txt_E_Mail.Text = dt.Rows[0]["Emp_Email"].ToString();
                //////////////////////////////////////////////////////////////////////////////////////////////////
                Military_txt.ClearSelection();
                Military_txt.Items.FindItemByValue(dt.Rows[0]["Emp_Military_Status_ID"].ToString()).Selected = true;
                Dept_RCB.ClearSelection();
                Dept_RCB.Items.FindItemByValue(dt.Rows[0]["dept_id"].ToString()).Selected = true;
                if (dt.Rows[0]["Emp_Gender"].ToString() == "False")
                {
                    ddr_gender.Items.FindItemByText("ذكر").Selected = true;
                }
                else
                {
                    ddr_gender.Items.FindItemByText("انثى").Selected = true;
                }

                cmb_job_title.ClearSelection();
                cmb_job_title.Items.FindItemByValue(dt.Rows[0]["Emp_Job_Title_ID"].ToString()).Selected = true;
                cmb_job_type.Items.FindItemByValue(dt.Rows[0]["Emp_Job_Type"].ToString()).Selected = true;

                txt_jobt_type_place.Text = dt.Rows[0]["Emp_Job_Title_Place"].ToString();
                txt_Nationality.Items.FindItemByValue(dt.Rows[0]["Emp_Nationality_ID"].ToString()).Selected = true;
                ID_type_txt.Items.FindItemByValue(dt.Rows[0]["Emp_Identity_Type"].ToString()).Selected = true;
                txt_issue_place.Items.FindItemByValue(dt.Rows[0]["Emp_Identity_Issue_Place"].ToString()).Selected = true;


                rdp_job_date.Text = dt.Rows[0]["Emp_Job_start_date"].ToString();


                //if (dt.Rows[0]["Emp_Identity_Issue_date"].Equals(""))
                //{
                RDP_issue_date.Text = dt.Rows[0]["Emp_Identity_Issue_date"].ToString();
              //  }

                txt_ID_No.Text = dt.Rows[0]["Emp_Identity_ID"].ToString();
                /////////////////////////////////////////////////////////////////////////////////////////////////////
                Marital_txt.Items.FindItemByValue(dt.Rows[0]["Emp_Marital_Status_ID"].ToString()).Selected = true;
                txt_place_of_birth.Items.FindItemByValue(dt.Rows[0]["Emp_BirthPlace"].ToString()).Selected = true;
               // if (obj_tbl_emp_data.Emp_BDate.Year != 0001 && !obj_tbl_emp_data.Emp_BDate.Equals(""))
                //{
                    RadDatePicker1.Text = dt.Rows[0]["Emp_BDate"].ToString();
              //  }
                ///////////////////////////////////////////////////////////////////////////////////////////////////
                txt_insure_no.Text = dt.Rows[0]["Emp_Insurance_ID"].ToString();
                txt_ins_page.Text = dt.Rows[0]["Emp_Insurance_Page"].ToString();

                txt_basic_salary.Text = dt.Rows[0]["Insurance_Basic_salary"].ToString();
                txt_var_salary.Text = dt.Rows[0]["Insurance_Variable_salary"].ToString();
                TextBox6.Text = dt.Rows[0]["Emp_Job_Net_Salary"].ToString();
                ///////////////////////////////////////////////////////////////////////////////////////////////////////
               // if (dt.Rows[0]["Emp_Insurance_Job_Date"].Equals(""))
                //{
                    rdp_insurance_date.Text = dt.Rows[0]["Emp_Insurance_Job_Date"].ToString();
               // }
                    bind_prev_work();
                    bind_sc_Cert();

            }
            else
            {
                RadPageView4.Enabled = false;
                RadPageView5.Enabled = false;
            }
        }
    }

    private void fillcmb()
    {
        DataTable dt = TeiLib.NationalitiesDAL.GetAll();
        if (dt.Rows.Count > 0)
        {
            txt_place_of_birth.DataSource = dt;
            txt_place_of_birth.DataTextField = "ArNationalityName";
            txt_place_of_birth.DataValueField = "NationalityId";
            txt_place_of_birth.DataBind();
            txt_place_of_birth.Items.Insert(0, new RadComboBoxItem("Select...", "0"));

            txt_Nationality.DataSource = dt;
            txt_Nationality.DataTextField = "ArNationalityName";
            txt_Nationality.DataValueField = "NationalityId";
            txt_Nationality.DataBind();
            txt_Nationality.Items.Insert(0, new RadComboBoxItem("Select...", "0"));


            txt_issue_place.DataSource = dt;
            txt_issue_place.DataTextField = "ArNationalityName";
            txt_issue_place.DataValueField = "NationalityId";
            txt_issue_place.DataBind();
            txt_issue_place.Items.Insert(0, new RadComboBoxItem("Select...", "0"));

        }



        DataTable dt_dept = TeiLib_AD.HR_DepartmentsDAL.GetAll();
        if (dt_dept.Rows.Count > 0)
        {
            Dept_RCB.DataSource = dt_dept;
            Dept_RCB.DataTextField = "Dept_Name_ara";
            Dept_RCB.DataValueField = "Dept_ID";
            Dept_RCB.DataBind();
            Dept_RCB.Items.Insert(0, new RadComboBoxItem("Select...", "0"));
        }

        //////////////////////////////////////////////////////////////

        DataTable dt_job_title = TeiLib_AD.Emp_Job_TitleDAL.GetAll();
        if (dt_job_title.Rows.Count > 0)
        {
            cmb_job_title.DataSource = dt_job_title;
            cmb_job_title.DataTextField = "Emp_Job_Title_Name_ara";
            cmb_job_title.DataValueField = "Emp_Job_Title_ID";
            cmb_job_title.DataBind();
            cmb_job_title.Items.Insert(0, new RadComboBoxItem("Select...", "0"));
        }

        ///////////////////////////////////////////////////////////////////////////
        using (SqlConnection connection = new SqlConnection(TeiLib.Utils.ConnectionString))
        {
            using (SqlCommand command = new SqlCommand("Locations_GetByAllByType_countries", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                DataTable dtLocations = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(dtLocations);
                txt_issue_place.DataSource = dtLocations;
                txt_issue_place.DataTextField = "ArLocationName";
                txt_issue_place.DataValueField = "LocationId";
                txt_issue_place.DataBind();


                txt_place_of_birth.DataSource = dtLocations;
                txt_place_of_birth.DataTextField = "ArLocationName";
                txt_place_of_birth.DataValueField = "LocationId";
                txt_place_of_birth.DataBind();
            }
        }
        /////////////////////////////////////////////////////////////////
   
        /////////////////////////////////////////////////////////////
        //tbl_idcardtype obj_tbl_idcardtype = new tbl_idcardtype();
        //ID_RCB.DataSource = obj_tbl_idcardtype.SearchSQL();
        //ID_RCB.DataTextField = "idtype_dsc";
        //ID_RCB.DataValueField = "idtype_id";
        //ID_RCB.DataBind();
        //////////////////////////////////////////////////////////
        //tbl_miliStatus obj_tbl_miliStatus =new tbl_miliStatus();
        //Military_RCB.DataSource = obj_tbl_miliStatus.SearchSQL();
        //Military_RCB.DataTextField = "mils_dsc";
        //Military_RCB.DataValueField = "mils_id";
        //Military_RCB.DataBind();
        ///////////////////////////////////////////////////////////////////
        //tbl_mrtstatus obj_tbl_mrtstatus = new tbl_mrtstatus();
        //Marital_Status_RCB.DataSource = obj_tbl_mrtstatus.SearchSQL();
        //Marital_Status_RCB.DataTextField = "mrts_dsc";
        //Marital_Status_RCB.DataValueField ="mrts_id";
        //Marital_Status_RCB.DataBind();
        //////////////////////////////////////////////////////////////////
        //tbl_grade obj_tbl_grade = new tbl_grade();
        //Grade_RCB.DataSource = obj_tbl_grade.SearchSQL();
        //Grade_RCB.DataTextField = "grade_dsc";
        //Grade_RCB.DataValueField = "grade_id";
        //Grade_RCB.DataBind();
        ///////////////////////////////////////////////////////////////////
        //tbl_statusofinsure obj_tbl_statusofinsure = new tbl_statusofinsure();
        //StatusOfInsure_RCB.DataSource = obj_tbl_statusofinsure.SearchSQL();
        //StatusOfInsure_RCB.DataTextField = "insurancestatus_dsc";
        //StatusOfInsure_RCB.DataValueField = "insurance_id";
        //StatusOfInsure_RCB.DataBind();
        //////////////////////////////////////////////////////////////////////
        //tbl_univ obj_tbl_univ = new tbl_univ();
        //Univ_RCB.DataSource = obj_tbl_univ.SearchSQL();
        //Univ_RCB.DataTextField = "univ_name";
        //Univ_RCB.DataValueField = "univ_id";
        //Univ_RCB.DataBind();

    }

    protected void btn_Save_Click(object sender, EventArgs e)
    {
        DataTable dt = TeiLib_AD.EmployeesDAL.GetByIDNo(txt_ID_No.Text);
        if (dt.Rows.Count > 0)
        {
         
            ScriptManager.RegisterStartupScript(this, typeof(Page), "dddd", "alert('يوجد موظف بهذا الرقم');", true);
            txt_ID_No.Focus();

        }
        else
        {


            obj_tbl_emp_data.Emp_Ara_Fname = txt_Emp_First_Name.Text;
            obj_tbl_emp_data.Emp_Ara_Mname = txt_Emp_Second_Name.Text;
            obj_tbl_emp_data.Emp_Ara_Lname = txt_Family_Name.Text;
            //////////////////////////////////////////////////////////////////////////////////////////////////
            obj_tbl_emp_data.Emp_Address = txt_Address.Text;
            obj_tbl_emp_data.Emp_Home_Tel = txt_Home_Tel.Text;
            obj_tbl_emp_data.Emp_Mobile = txt_Mobile.Text;
            obj_tbl_emp_data.Emp_Email = txt_E_Mail.Text;
            //////////////////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////////////////////////////////
            obj_tbl_emp_data.Emp_Military_Status_ID = int.Parse(Military_txt.SelectedItem.Value);
            obj_tbl_emp_data.Emp_Nationality_ID = int.Parse(txt_Nationality.SelectedItem.Value);
            obj_tbl_emp_data.Emp_Identity_Type = int.Parse(ID_type_txt.SelectedItem.Value);
            obj_tbl_emp_data.Emp_Identity_ID = txt_ID_No.Text;
            obj_tbl_emp_data.Emp_Identity_Issue_Place = int.Parse(txt_issue_place.SelectedItem.Value);
            /////////////////////////////////////////////////////////////////////////////////////////////////////
            obj_tbl_emp_data.Emp_Marital_Status_ID = int.Parse(Marital_txt.SelectedItem.Value);
            obj_tbl_emp_data.Emp_BirthPlace = int.Parse(txt_place_of_birth.SelectedItem.Value);
            try
            {
                obj_tbl_emp_data.Emp_BDate = DateTime.Parse(RadDatePicker1.Text);
            }
            catch (Exception ex)
            {

            }
            try
            {
                obj_tbl_emp_data.Emp_Identity_Issue_date = DateTime.Parse(RDP_issue_date.Text);
            }
            catch (Exception ex)
            {

            }

            ///////////////////////////////////////////////////////////////////////////////////////////////////

            obj_tbl_emp_data.Emp_Insurance_ID = int.Parse(txt_insure_no.Text);
            try
            {
                obj_tbl_emp_data.Emp_Insurance_Job_Date = DateTime.Parse(rdp_insurance_date.Text);
            }
            catch (Exception ex)
            {

            }
            obj_tbl_emp_data.Emp_Insurance_Page = int.Parse(txt_ins_page.Text);
            obj_tbl_emp_data.Insurance_Basic_salary = decimal.Parse(txt_basic_salary.Text);
            obj_tbl_emp_data.Insurance_Variable_salary = decimal.Parse(txt_var_salary.Text);
            ///////////////////////////////////////////////////////////////////////////////////////////////////////

            obj_tbl_emp_data.Emp_Job_Type = int.Parse(cmb_job_type.SelectedItem.Value);
            obj_tbl_emp_data.Emp_Gender = int.Parse(ddr_gender.SelectedItem.Value.ToString());
            obj_tbl_emp_data.Emp_Job_Title_ID = int.Parse(cmb_job_title.SelectedItem.Value);
            obj_tbl_emp_data.Emp_Job_Title_Place = txt_jobt_type_place.Text;
            try
            {
                obj_tbl_emp_data.Emp_Job_start_date = DateTime.Parse(rdp_job_date.Text);
            }
            catch (Exception Ex)
            {

            }
            /////////////////////////////////////////////////////////////////////////////////////////////////////////

            obj_tbl_emp_data.User_Action_Date = DateTime.Now;
            if (int.Parse(ViewState["Emp_ID"].ToString()) > 0)
            {

                obj_tbl_emp_data.Dept_ID = int.Parse(Dept_RCB.SelectedItem.Value);
                //grd.DataSource = DS_items.Tables[0];
                obj_tbl_emp_data.Emp_ID = int.Parse(ViewState["Emp_ID"].ToString());
                obj_tbl_emp_data.User_Action = "Edit";
                TeiLib_AD.EmployeesDAL.Update(obj_tbl_emp_data);


            }
            else
            {
                obj_tbl_emp_data.Dept_ID = int.Parse(Dept_RCB.SelectedItem.Value);
                obj_tbl_emp_data.User_Action = "New";
                TeiLib_AD.EmployeesDAL.Insert(obj_tbl_emp_data);

                DataSet Get_emp_code = TeiLib_AD.EmployeesDAL.GetByEmp_code(int.Parse(Dept_RCB.SelectedItem.Value));
                if (Get_emp_code.Tables[1].Rows.Count > 0)
                {
                    //TeiLib_AD.Employees obj_emps = new TeiLib_AD.Employees();
                    obj_tbl_emp_data.Emp_Code = Get_emp_code.Tables[1].Rows[0][0].ToString();
                    obj_tbl_emp_data.Emp_ID = int.Parse(Get_emp_code.Tables[0].Rows[0][0].ToString());
                    TeiLib_AD.EmployeesDAL.Update(obj_tbl_emp_data);
                }


            }
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "msg", "<script type='text/javascript' language='javascript'>alert(' Saved Succefully '); window.location.href='viewEmployee.aspx';</script>", false);
            Response.Redirect("viewEmployee.aspx");
        }
    }

    protected void btn_Back_Click(object sender, EventArgs e)
    {
        Response.Redirect("viewEmployee.aspx");
    }
    protected void btn_Restore_Click(object sender, EventArgs e)
    {
        //obj_tbl_emp_data.emp_id = int.Parse(obj_EmpSession.EmpID.ToString());
        //obj_tbl_emp_data.user_action = "Edit";
        //obj_tbl_emp_data.Update();
        //Response.Redirect("viewEmployee.aspx");

        //obj_EmpSession.EmpID = int.Parse(e.CommandArgument.ToString());
        //obj_tbl_emp_data.user_action = "del";
        //obj_tbl_emp_data.Update();
        //ObjectDataSource1.SelectParameters[0].DefaultValue = "([tbl_emp_data].user_action != 'del' or [tbl_emp_data].user_action is null)";
        RadWindow window1 = new RadWindow();
        window1.Title = ".:: Restore Employee ::.";
        window1.ID = "RadWindow2";
        window1.NavigateUrl = "getBackReason.aspx";
        window1.VisibleOnPageLoad = true;
        window1.OnClientClose = "ReloadForm";
        window1.Width = 800;
        window1.Skin = "Vista";
        window1.ReloadOnShow = true;
        window1.Height = 350;
        RadWindowManager2.Windows.Add(window1);
    }
    protected void btn_Show_Click(object sender, EventArgs e)
    {
        Response.Redirect("viewEmployee.aspx");
    }

    protected void btn_add_new_prev_work_Click(object sender, EventArgs e)
    {
        Div_add_work_prev.Visible = true;
    }

    protected void btn_cancel_prev_work_Click(object sender, EventArgs e)
    {
        Div_add_work_prev.Visible = false;

    }
    protected void btn_save_prev_work_Click(object sender, EventArgs e)
    {
        Div_add_work_prev.Visible = false;
        TeiLib_AD.Employee_Previous_Work obj_Employee_Previous_Work = new TeiLib_AD.Employee_Previous_Work();
        obj_Employee_Previous_Work.Emp_ID = int.Parse(ViewState["Emp_ID"].ToString());
        obj_Employee_Previous_Work.Work_Place_Name_ara = txt_Work_Place_Name_ara.Text;
        obj_Employee_Previous_Work.Work_Title_Name_ara = txt_job_title_prev.Text;
        obj_Employee_Previous_Work.Leave_Reason_ara = txt_leave_work.Text;
        try
        {
            obj_Employee_Previous_Work.Work_From = DateTime.Parse(RadDP_start_work_prev.Text);
        }
        catch
        { }
        try
        {
            obj_Employee_Previous_Work.Work_To = DateTime.Parse(RadDP_end_work_prev.Text);
        }
        catch
        { }
        TeiLib_AD.Employee_Previous_WorkDAL.Insert(obj_Employee_Previous_Work);
        bind_prev_work();
    }
    private void bind_prev_work()
    {
        DataTable DT = TeiLib_AD.Employee_Previous_WorkDAL.GetById(int.Parse(ViewState["Emp_ID"].ToString()));
        if (DT.Rows.Count > 0)
        {
            grd_prev_work.DataSource = DT;
            grd_prev_work.DataBind();
        }
    }

    private void bind_sc_Cert()
    {
        DataTable DT = TeiLib_AD.Employee_Scientific_DegreeDAL.GetByEmpId(int.Parse(ViewState["Emp_ID"].ToString()));
        if (DT.Rows.Count > 0)
        {
            grd_scientific.DataSource = DT;
            grd_scientific.DataBind();
        }
    }
    protected void btn_cancel_sc_Click(object sender, EventArgs e)
    {
        add_cert.Visible = false;
    }

    protected void btn_Add_Click(object sender, EventArgs e)
    {
        add_cert.Visible = true;
    }
    protected void btn_save_sc_Click(object sender, EventArgs e)
    {
        if (ddr_certificate_type.SelectedIndex == 0)
        {
        }
        else
        {
            add_cert.Visible = false;
            TeiLib_AD.Employee_Scientific_Degree obj_Employee_Scientific_Degree = new TeiLib_AD.Employee_Scientific_Degree();
            obj_Employee_Scientific_Degree.Emp_ID = int.Parse(ViewState["Emp_ID"].ToString());
            obj_Employee_Scientific_Degree.Emp_Scientific_Type = int.Parse(ddr_certificate_type.SelectedItem.Value);
            obj_Employee_Scientific_Degree.Emp_University_Degres_Name_ara = University_txt.Text;
            obj_Employee_Scientific_Degree.Emp_Faculty_Degree_Name_ara = txt_faculty.Text;
            obj_Employee_Scientific_Degree.Emp_Degree_Year = int.Parse(txt_Year.Text);
            obj_Employee_Scientific_Degree.Emp_Degree_Desc_ara = TextBox2.Text;
            TeiLib_AD.Employee_Scientific_DegreeDAL.Insert(obj_Employee_Scientific_Degree);
            bind_sc_Cert();
        }
    }
    protected void txt_Family_Name_TextChanged(object sender, EventArgs e)
    {
        txt_Full_Name.Text = txt_Emp_First_Name.Text + " " + txt_Emp_Second_Name.Text + " " + txt_Family_Name.Text;
    }
    protected void txt_ID_No_TextChanged(object sender, EventArgs e)
    {
        DataTable dt = TeiLib_AD.EmployeesDAL.GetByIDNo(txt_ID_No.Text);
        if (dt.Rows.Count > 0)
        {
            ScriptManager.RegisterStartupScript(this, typeof(Page), "dddd", "alert('يوجد موظف بهذا الرقم');", true);
            txt_ID_No.Focus();
        }
        else
        { 

        }
    }
    protected void grd_prev_work_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Row_Delete")
        {
            Employee_Previous_WorkDAL.Delete(int.Parse(e.CommandArgument.ToString()));
        }
    }
    protected void grd_scientific_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Row_Delete")
        {
            Employee_Scientific_DegreeDAL.Delete(int.Parse(e.CommandArgument.ToString()));
        }
    }
}
