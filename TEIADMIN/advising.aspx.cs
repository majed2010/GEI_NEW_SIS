using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using System.Collections;
public partial class advising : System.Web.UI.Page
{
    int TotalCreditperSemester = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Advising"))
        {
            PageView.ActiveViewIndex = 1;
            noAccessLbl.Visible = true;
        }
        
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        int rowCount = BlockedDAL.GetBlockingOfStudent(txtٍStudentCode.Text).Rows.Count;
        string _str = StudentsDAL.GetByCode(txtٍStudentCode.Text).Rows[0]["DepartmentId"].ToString();
        if (CurrentUser.GetDepartmentId() == Convert.ToInt32(_str) || CurrentUser.GetUserRole()==1 )
        {
            noRegisterlbl.Visible = false;
            if (rowCount > 0)
            {
                PageView.ActiveViewIndex = 1;
                Label2.Visible = true;
                returnBTN.Visible = true;
                if (rowCount == 1)
                    if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(txtٍStudentCode.Text).Rows[0]["Type"]) == 1)
                        finance.Visible = true;
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(txtٍStudentCode.Text).Rows[0]["Type"]) == 2)
                        affairs.Visible = true;
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(txtٍStudentCode.Text).Rows[0]["Type"]) == 3)
                        AdvisingDepart.Visible = true;
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(txtٍStudentCode.Text).Rows[0]["Type"]) == 4)
                    {
                        affairs.Visible = true;
                        affairs.Text += " و";
                        AdvisingDepart.Visible = true;
                    }
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(txtٍStudentCode.Text).Rows[0]["Type"]) == 5)
                    {
                        finance.Visible = true;
                        finance.Text += " و";
                        AdvisingDepart.Visible = true;
                    }
                    else
                    {
                        finance.Visible = true;
                        finance.Text += " و";
                        affairs.Visible = true;
                    }
            }
            else
            {

                DataTable tblStudents = StudentsDAL.GetByCode(txtٍStudentCode.Text);
                if (tblStudents.Rows.Count == 1)
                {
                    studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
                    lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
                    departmentIdHdn.Value = tblStudents.Rows[0]["DepartmentId"].ToString();
                    lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();
                    
                    DataTable tblExpenses=StudentsAccountingDAL.GET_ExpensesId_By_StudentCode(txtٍStudentCode.Text);
                    hdnExpensesId.Value = tblExpenses.Rows[0]["ExpensesId"].ToString();

                    if (Convert.ToInt32( departmentIdHdn.Value)==1)
                    {
                    ADDAdvisingByBlock.Visible=true;
                    //AddCivilBlock.Visible = false;
                    //AddCivil4Level.Visible = false;
                     }
                    else if (Convert.ToInt32(departmentIdHdn.Value) == 4)
                    {
                        ADDAdvisingByBlock.Visible = false;
                        //AddCivilBlock.Visible = true;
                        //AddCivil4Level.Visible = true;
                    }
                    else
                    {
                        ADDAdvisingByBlock.Visible = false;
                        //AddCivilBlock.Visible = false;
                        //AddCivil4Level.Visible = false;
                    }
                    GridView1.DataBind();
                    addCoursesHolder.Visible = true;
                }
                else
                {
                    lblFullName.Text = "";
                    lblDept.Text = "";
                    addCoursesHolder.Visible = false;
                }
            }
        }
        else
        {
            PageView.ActiveViewIndex = 1;
            noRegisterlbl.Visible = true;
            Label2.Visible = false;
            returnBTN.Visible = true;
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        int comphours = Convert.ToInt32(hdnCompltedhours.Value);
        int departid = Convert.ToInt32(departmentIdHdn.Value);
        int cousid = Convert.ToInt32(courses.SelectedValue);
        //float GPAStudent = (lblGPA.Text);

        int ErrorCode;
        ErrorCode = StudentsAdvisingDAL.ChackGroupMaximumByCourseSemesterDoctor(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(ddlDoctor.SelectedValue), out ErrorCode);
        if (ddlDoctor.SelectedValue=="0")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('يجب اختيار دكتور')", true);
            
        }

                 
        else if (ErrorCode == 101)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('مجموعة الدكتور مكتاملة يجب اختيار دكتور اخر')", true);
            
        }
       

        else
        {

       
   

        if (courses.SelectedValue != "0" && cousid == 166 && departid == 2 && comphours < 124)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لا يمكنك تسجيل مادة المشروع حيث لم تجتاز الساعات المطلوب')", true);
        }
        else if (courses.SelectedValue != "0" && cousid == 169 && departid == 3 && comphours < 120)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لا يمكنك تسجيل مادة المشروع حيث لم تجتاز الساعات المطلوب')", true);
        }
        else if (courses.SelectedValue != "0" && cousid == 174 && departid == 4 && comphours < 115)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لا يمكنك تسجيل مادة المشروع حيث لم تجتاز الساعات المطلوب')", true);
        }
        else if (courses.SelectedValue != "0" && cousid == 160 && departid == 2 && comphours < 120)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لا يمكنك تسجيل مادة التدريب الصيفي حيث لم تجتاز الساعات المطلوب')", true);
        }
        else if (courses.SelectedValue != "0" && cousid == 161 && departid == 3 && comphours < 120)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لا يمكنك تسجيل مادة التدريب الصيفي حيث لم تجتاز الساعات المطلوب')", true);
        }
        else if (courses.SelectedValue != "0" && cousid == 159 && departid == 4 && comphours < 120)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لا يمكنك تسجيل مادة التدريب الصيفي حيث لم تجتاز الساعات المطلوب')", true);
        }
        //else if (comphours < 163 && GPAStudent < 1.6 && TotalCreditperSemester )
        //{
        //    lblGPA.Text = "";
        //}

        else
        {


            StudentsAdvising studentAdv = new StudentsAdvising();
            studentAdv.StudentId = Convert.ToInt32(studentId.Value);
            studentAdv.SemesterId = Convert.ToInt32(semesters.SelectedValue);
            studentAdv.CourseId = Convert.ToInt32(courses.SelectedValue);
            studentAdv.AdvisingBy = Page.User.Identity.Name.ToString();
            studentAdv.YearId = Convert.ToInt32(hdn_yearId.Value);
            
            studentAdv.DoctorCoursesId = Convert.ToInt32(ddlDoctor.SelectedValue);
            InsertCourse(studentAdv);

            grdCourses.DataBind();

            LogStudentsAdvising log = new LogStudentsAdvising();
            log.StudentId = Convert.ToInt32(studentId.Value);
            log.SemesterId = Convert.ToInt32(semesters.SelectedValue);
            log.Action = "InsertRow";
            log.CourseId = Convert.ToInt32(courses.SelectedValue);
            log.UserName = Page.User.Identity.Name.ToString();
            LogStudentsAdvisingDAL.Insert(log);
        }
    }
    }
    private void InsertCourse(StudentsAdvising studentAdv)
    {
        int IsRepeated = 0;
        int TotalActualCredit = 0;
        int ContactHours = 0;
        int ErrorCode = 0;
        int TotalCredit = StudentsAdvisingDAL.Insert(studentAdv, out IsRepeated, out TotalActualCredit, out ContactHours, out ErrorCode);
        TotalCreditperSemester = TotalCredit;
        if (TotalCredit > 21 || ErrorCode == 108)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لقد تعديت عدد الساعات المسموح بها للتسجيل')", true);
        else if (ErrorCode == 101)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('يجب ان يجتاز الطالب المتطلب السابق - راجع المرشد الأكاديمي')", true);
        else if (ErrorCode == 102)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('هذه المادة مكررة في الفصل الدراسي المختار')", true);
        else if (ErrorCode == 103)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('المتطلب السابق تم اختياره مسبقا في نفس الفصل الدراسي')", true);
        else if (ErrorCode == 104)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('الطالب لم يسجل في المتطلب السابق')", true);
        else if (ErrorCode == 105)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('انتبه! الطالب سجل هذه المادة أكثر من مرتين')", true);
        else if (ErrorCode == 106)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('انتبه! هذه المرة السابعة لدخول هذه المادة ويعتبر الطالب مفصول فصلا نهائيا من المعهد')", true);
        else if (ErrorCode == 107)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('الترم الصيفي لا يمكن تسجيل أكثر من 6 ساعات معتمدة')", true);
        else if (ErrorCode == 320)
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('المادة المسجلة سوف تحتسب كمادة تحسين لانك ناجح فيها من قبل')", true); 

    }



    protected void grdCourses_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            e.ExceptionHandled = true;
            errorsHolder.Visible = true;
            deleteErr.Visible = true;
        }

    }
    protected void grdCourses_SelectedIndexChanged(object sender, EventArgs e)
    {
        //PageView.ActiveViewIndex = 0;
        //Deptform.ChangeMode(FormViewMode.Edit);
    }
    protected void grdCourses_DataBound(object sender, EventArgs e)
    {
        //  btnAdd1.Visible = btnUpdate.Visible = Convert.ToBoolean(grdDepts.Rows.Count);
    }
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }
    protected void AdvObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        int result = 0;
        if (!int.TryParse(e.ReturnValue.ToString(), out result))
        {
            if (e.OutputParameters["TotalCredit"].ToString() != "0" && e.OutputParameters["TotalContact"].ToString() != "0")
            {
                errorsHolder.Visible = true;
                totalCredit.Visible = true;
                contactHours.Visible = true;
                totalCredit.Text = e.OutputParameters["TotalCredit"].ToString();
                contactHours.Text = e.OutputParameters["TotalContact"].ToString();
                
            }
            else
            {
                errorsHolder.Visible = false;
            }
        }
    }
    protected void Adv1ObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        int result = 0;
        if (e.ReturnValue != null)
        {
            if (!int.TryParse(e.ReturnValue.ToString(), out result))
            {
                lblGPA.Text = Convert.IsDBNull(e.OutputParameters["GPA"]) ? "" : e.OutputParameters["GPA"].ToString();
                lblLevel.Text = Convert.IsDBNull(e.OutputParameters["LevelName"]) ? "" : e.OutputParameters["LevelName"].ToString();
                completedHours.Text = Convert.IsDBNull(e.OutputParameters["completedHours"]) ? "" : e.OutputParameters["completedHours"].ToString();
                registeredHours.Text = Convert.IsDBNull(e.OutputParameters["registeredHours"]) ? "" : e.OutputParameters["registeredHours"].ToString();
                restHours.Text = Convert.IsDBNull(e.OutputParameters["restHours"]) ? "" : e.OutputParameters["restHours"].ToString();
                hdnCompltedhours.Value = completedHours.Text;
            }
            courses.DataBind();
        }
    }



    protected void btnGenerateReport2_Click(object sender, EventArgs e)
    {

        int credit, contact;
        DataTable table2 = StudentsAdvisingDAL.GetByPage(Convert.ToInt32(studentId.Value), Convert.ToInt32(semesters.SelectedValue), 0, 30, out credit, out contact);
        int x= 0;
        decimal yyy = 0;
        string uuu = "";
        DataTable table = StudentsAdvisingDAL.GetByStudent(Convert.ToInt32(studentId.Value), out x, out yyy,out uuu, out x, out x, out x);

        Session["totalCredit"] = credit;// = e.OutputParameters["TotalCredit"].ToString();
        Session["contactHours"] = contact;// = e.OutputParameters["TotalContact"].ToString();
        Session["studentCode"] = txtٍStudentCode.Text;
        Session["FullName"] = lblFullName.Text;// = tblStudents.Rows[0]["ArFullName"].ToString();
        Session["StudentDept"] = lblDept.Text;// = tblStudents.Rows[0]["ArDepartmentName"].ToString();lblLevel
        Session["Semester"] = semesters.SelectedItem.Text;
        Session["Level"] = lblLevel.Text;
        Session["GPA"] = lblGPA.Text;
        Session["CompletedHours"] = completedHours.Text;
        Session["RegisteredHours"] = registeredHours.Text;
        Session["RestHours"] = restHours.Text;

        Session["table"] = table;

        Response.Redirect("StudentOldGrades.aspx");
    }

    protected void btnStudentSituationReport3_Click(object sender, EventArgs e)
    {
        DataTable table2 = StudentsAdvisingDAL.StudentSituation_NotDuplicateCrs(Convert.ToInt32(studentId.Value));
       
        Session["studentCode"] = txtٍStudentCode.Text;
        Session["FullName"] = lblFullName.Text;// = tblStudents.Rows[0]["ArFullName"].ToString();
        Session["StudentDept"] = lblDept.Text;// = tblStudents.Rows[0]["ArDepartmentName"].ToString();lblLevel
        //Session["Semester"] = semesters.SelectedItem.Text;
        Session["Level"] = lblLevel.Text;
        Session["GPA"] = lblGPA.Text;
        Session["CompletedHours"] = completedHours.Text;
        Session["RegisteredHours"] = registeredHours.Text;
        Session["RestHours"] = restHours.Text;

        Session["NotDuplicateTable"] = table2;

        Response.Redirect("StudentSituation_NotDuplicateCourses.aspx");
    }

    private int GetType(int ExpensesID)
    {
        ExpensesRegular expen = ExpensesRegularDAL.GetById(ExpensesID);
        return expen.ExpensesType;
    }
    

    protected void btnGenerateReport_Click(object sender, EventArgs e)
    {
        int credit, contact;
        string TotalCost;

        ExpensesRegular exp = ExpensesRegularDAL.GetById(Convert.ToInt32(hdnExpensesId.Value));
        
        int _type = GetType(Convert.ToInt32(hdnExpensesId.Value));
        if (_type == 2)
        {
            TotalCost = exp.PricePerSemester.ToString();
            
        }
        else
        {
            TotalCost = StudentsAccountingDAL.GetHoursCost(Convert.ToInt32(studentId.Value), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(hdnExpensesId.Value)).Rows[0]["TotalCost"].ToString();
        }

        
        //TotalCost = tlbCosts.Rows[0]["TotalCost"].ToString();
        DataTable table = StudentsAdvisingDAL.GetByPage(Convert.ToInt32(studentId.Value), Convert.ToInt32(semesters.SelectedValue), 0, 30, out credit, out contact);
        int completedHours_var = 0;
         int registeredHours_var = 0;
         int restHours_var = 0;
         int x = 0;
        decimal yyy = 0;
        string uuu = "";
        string ccc = "500 " + "جنيهاً";
        DataTable table_1 = StudentsAdvisingDAL.GetByStudent(Convert.ToInt32(studentId.Value), out x, out yyy, out uuu, out completedHours_var, out registeredHours_var, out restHours_var);

        Session["totalCredit"] = credit;// = e.OutputParameters["TotalCredit"].ToString();
        Session["contactHours"] = contact;// = e.OutputParameters["TotalContact"].ToString();
        Session["studentCode"] = txtٍStudentCode.Text;
        Session["FullName"] = lblFullName.Text;// = tblStudents.Rows[0]["ArFullName"].ToString();
        Session["StudentDept"] = lblDept.Text;// = tblStudents.Rows[0]["ArDepartmentName"].ToString();lblLevel
        Session["Semester"] = semesters.SelectedItem.Text;
        Session["Level"] = lblLevel.Text;
        Session["GPA"] = lblGPA.Text;
        Session["CompletedHours"] = completedHours_var;
        Session["RegisteredHours"] = registeredHours_var;
        Session["RestHours"] = restHours_var;
        Session["TotalCost"] = TotalCost;
        Session["Advisior"] = CurrentUser.GetFullName();
        Session["penlaty"] = ccc;
        Session["table"] = table;

        Response.Redirect("StudentAdv.aspx");
    }

    protected void returnBTN_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        returnBTN.Visible = false;

    }


    protected void btnStudentPayment_Click(object sender, EventArgs e)
    {
        int credit, contact;
        string TotalCost;

        ExpensesRegular exp = ExpensesRegularDAL.GetById(Convert.ToInt32(hdnExpensesId.Value));

        int _type = GetType(Convert.ToInt32(hdnExpensesId.Value));
        if (_type == 2)
        {
            TotalCost = exp.PricePerSemester.ToString();

            //decimal totPrice = Convert.ToDecimal(TotalCost) + Convert.ToDecimal(100);
            //TotalCost = Convert.ToString(totPrice);

        }
        else
        {
            TotalCost = StudentsAccountingDAL.GetHoursCost(Convert.ToInt32(studentId.Value), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(hdnExpensesId.Value)).Rows[0]["TotalCost"].ToString();
            //decimal totPrice = Convert.ToDecimal(TotalCost) + Convert.ToDecimal(602);
            //TotalCost = Convert.ToString(totPrice);
        }


        //TotalCost = tlbCosts.Rows[0]["TotalCost"].ToString();
        DataTable table = StudentsAdvisingDAL.GetByPage(Convert.ToInt32(studentId.Value), Convert.ToInt32(semesters.SelectedValue), 0, 30, out credit, out contact);
        int completedHours_var = 0;
        int registeredHours_var = 0;
        int restHours_var = 0;
        int x = 0;
        decimal yyy = 0;
        string uuu = "";
        string ccc = "";
        DataTable table_1 = StudentsAdvisingDAL.GetByStudent(Convert.ToInt32(studentId.Value), out x, out yyy, out uuu, out completedHours_var, out registeredHours_var, out restHours_var);


        Session["totalCredit"] = credit;// = e.OutputParameters["TotalCredit"].ToString();
        Session["contactHours"] = contact;// = e.OutputParameters["TotalContact"].ToString();
        Session["studentCode"] = txtٍStudentCode.Text;
        Session["FullName"] = lblFullName.Text;// = tblStudents.Rows[0]["ArFullName"].ToString();
        Session["StudentDept"] = lblDept.Text;// = tblStudents.Rows[0]["ArDepartmentName"].ToString();lblLevel
        Session["Semester"] = semesters.SelectedItem.Text;
        Session["Level"] = lblLevel.Text;
        Session["GPA"] = lblGPA.Text;
        Session["CompletedHours"] = completedHours_var;
        Session["RegisteredHours"] = registeredHours_var;
        Session["RestHours"] = restHours_var;
        Session["TotalCost"] = TotalCost;
        Session["Advisior"] = CurrentUser.GetFullName();
        Session["penlaty"] = ccc;
        Session["table"] = table;

        Response.Redirect("StudentAdvPayment.aspx");
    }

    protected void btnStudentExpectedGPAReport4_Click(object sender, EventArgs e)
    {
        DataTable table3 = StudentsAdvisingDAL.CalcualateExpectedGPAByStudent(Convert.ToInt32(studentId.Value) ,Convert.ToInt32(semesters.SelectedValue));

        int completedHours_var = 0;
        int registeredHours_var = 0;
        int restHours_var = 0;
        int x = 0;
        decimal yyy = 0;
        string uuu = "";
        DataTable table_1 = StudentsAdvisingDAL.GetByStudent(Convert.ToInt32(studentId.Value), out x, out yyy, out uuu, out completedHours_var, out registeredHours_var, out restHours_var);
        Session["studentCode"] = txtٍStudentCode.Text;
        Session["FullName"] = lblFullName.Text;// = tblStudents.Rows[0]["ArFullName"].ToString();
        Session["StudentDept"] = lblDept.Text;// = tblStudents.Rows[0]["ArDepartmentName"].ToString();lblLevel
        Session["Semester"] = semesters.SelectedItem.Text;
        Session["Level"] = lblLevel.Text;
        Session["GPA"] = lblGPA.Text;
        Session["CompletedHours"] = completedHours_var.ToString();
        Session["RegisteredHours"] = registeredHours_var.ToString();
        Session["RestHours"] = restHours_var.ToString();

        Session["table_1"] = table3;

        Response.Redirect("Calcualate_Expected_GPA_Student_Report.aspx");
    }

    protected void semesters_SelectedIndexChanged(object sender, EventArgs e)
    {
        Semester sem = SemestersDAL.GetById(Convert.ToInt32(semesters.SelectedValue));
        hdn_yearId.Value = sem.YearId.ToString();
    }

    private void FillDoctors()
    {

        ddlDoctor.Items.Clear();
        ddlDoctor.DataSource = AssignMemberToCourseDAL.GetMembersByCourse(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue));
        ddlDoctor.DataValueField = "MemberId";
        ddlDoctor.DataTextField = "MemberName";
        ddlDoctor.DataBind();
        ddlDoctor.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }
    protected void courses_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillDoctors();

    }

    protected void ddlDoctor_SelectedIndexChanged(object sender, EventArgs e)
    {
        int ErrorCode;
        ErrorCode = StudentsAdvisingDAL.ChackGroupMaximumByCourseSemesterDoctor(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(semesters.SelectedValue), Convert.ToInt32(ddlDoctor.SelectedValue),out ErrorCode);
        if (ErrorCode==101)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('مجموعة الدكتور مكتاملة يجب اختيار دكتور اخر')", true);
            btnAdd.Enabled = false;
        }
        else
        {
            btnAdd.Enabled = true;
        }

    }

    protected void ADDAdvisingByBlock_Click(object sender, EventArgs e)
    {
      StudentsAdvisingDAL.AdvisingSemesterCoursesInsert(1,Convert.ToInt32(studentId.Value),Convert.ToInt32(semesters.SelectedValue), Page.User.Identity.Name.ToString(),Convert.ToInt32(hdn_yearId.Value));

            grdCourses.DataBind();
        }
    //protected void AddCivilBlock_Click(object sender, EventArgs e)
    //{
    //    StudentsAdvisingDAL.AdvisingSemesterCoursesInsert(2, Convert.ToInt32(studentId.Value), Convert.ToInt32(semesters.SelectedValue), Page.User.Identity.Name.ToString(), Convert.ToInt32(hdn_yearId.Value));

    //    grdCourses.DataBind();
    //}

    //protected void AddCivil4Level_Click(object sender, EventArgs e)
    //{
    //    StudentsAdvisingDAL.AdvisingSemesterCoursesInsert(3,Convert.ToInt32(studentId.Value), Convert.ToInt32(semesters.SelectedValue), Page.User.Identity.Name.ToString(), Convert.ToInt32(hdn_yearId.Value));

    //    grdCourses.DataBind();
    //}

    protected void grdCourses_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            StudentsAdvisingDAL.Delete(Convert.ToInt32(e.CommandArgument), Page.User.Identity.Name.ToString());
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم حذف المادة')", true);

        }
    }

}


