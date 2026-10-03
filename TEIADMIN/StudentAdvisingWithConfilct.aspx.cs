using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using System.Collections;
using System.Web.Configuration;
using TeiLib.DTO;
using NewAdvisingData;

using System.Transactions;
using TeiLib.BO;


public partial class StudentAdvisingWithConfilct : System.Web.UI.Page
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



        if (!IsPostBack)
        {
            FillSemesters();
            semesters.SelectedValue = WebConfigurationManager.AppSettings["AdvActiveSemester"].ToString();
            hdnSemesterId.Value = WebConfigurationManager.AppSettings["AdvActiveSemester"].ToString();
           
            TeiLib.Semester sem = SemestersDAL.GetById(Convert.ToInt32(WebConfigurationManager.AppSettings["AdvActiveSemester"].ToString()));

            hdn_yearId.Value = sem.YearId.ToString();


        }
    }
   
 
    private void GetStudentData( string studentCode)
    {
        studentCode = txtStudentCode.Text;
      
        int rowCount = BlockedDAL.GetBlockingOfStudent(studentCode).Rows.Count;
        hdnStudentCode.Value = studentCode;

        string _str = StudentsDAL.GetByCode(studentCode).Rows[0]["DepartmentId"].ToString();
        if (CurrentUser.GetUserRole() == 1

             || CurrentUser.GetUserId() == "52" || CurrentUser.GetUserId() == "119" || CurrentUser.GetUserId() == "136"

                    || CurrentUser.GetDepartmentId() == Convert.ToInt32(_str))
        {
            noRegisterlbl.Visible = false;
            if (rowCount > 0)
            {
                PageView.ActiveViewIndex = 1;
                Label2.Visible = true;
                returnBTN.Visible = true;
                departmentIdHdn.Value = _str;
                if (rowCount == 1)
                    if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 1)
                        finance.Visible = true;
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 2)
                        affairs.Visible = true;
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 3)
                        AdvisingDepart.Visible = true;
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 13)
                        Label1.Visible = true;
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 4)
                    {
                        affairs.Visible = true;
                        affairs.Text += " و";
                        AdvisingDepart.Visible = true;
                    }
                    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 5)
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

                DataTable tblStudents = StudentsDAL.GetByCode(studentCode);
                if (tblStudents.Rows.Count == 1)
                {
                  
                    studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
                    lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
                    departmentIdHdn.Value = tblStudents.Rows[0]["DepartmentId"].ToString();
                    lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();
                    FillCourses(Convert.ToInt32(hdnSemesterId.Value), Convert.ToInt32(studentId.Value));
                    Adv1ObjectDataSource.Select();
                    DataTable tblExpenses = StudentsAccountingDAL.GET_ExpensesId_By_StudentCode(studentCode);
                    hdnExpensesId.Value = tblExpenses.Rows[0]["ExpensesId"].ToString();

                    if (Convert.ToInt32(departmentIdHdn.Value) == 1)
                    {
                        //generalnumbers.Visible = true;
                       
                     
                    }
                    else if (Convert.ToInt32(departmentIdHdn.Value) == 4)
                    {
                        // generalnumbers.Visible = false;
                        
                       
                    }

                    else if (Convert.ToInt32(departmentIdHdn.Value) == 3)
                    {
                        // generalnumbers.Visible = false;
                       
                       
                    }

                    else if (Convert.ToInt32(departmentIdHdn.Value) == 2)
                    {
                        // generalnumbers.Visible = false;
                       
                       
                    }
                    else
                    {
                        //   ADDAdvisingByBlock.Visible = false;
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


    protected void childrenTitleRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "AddSection")
        {
            try
            {
                using (TransactionScope transactionScope = new TransactionScope(TransactionScopeOption.RequiresNew, new TransactionOptions() { IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted }))
                {
                    int _studentId = Convert.ToInt32(studentId.Value);
                    int _parentId = Convert.ToInt32(hdnParentId.Value);
                    int sectionId = Convert.ToInt32(e.CommandArgument);
                    int courseId = Convert.ToInt32(courses.SelectedValue);
                    string errorMessage = "";
                    int _semesterId = Convert.ToInt32(hdnSemesterId.Value);
                    if (!CoursesDAL.IsCourseExist(courseId, _parentId, _studentId, _semesterId))
                    {
                        if (!CoursesDAL.IsSectionExist(sectionId, _parentId, _studentId, _semesterId))
                        {
                            //List<StudentAdvisingDTO> conflictList = CoursesDAL.CheckSectionConflict(_parentId,sectionId, _studentId, _semesterId);

                            //if (conflictList.Count == 0)
                            //{
                                // Insert Course
                                ResultValue result = new ResultValue();
                                result = AddCourse(courseId, _semesterId);
                                if (result.Id == 200 || result.Id == 320 || result.Id == 105)
                                {
                                    CoursesDAL courseDal = new CoursesDAL();
                                    if (courseDal.InsertSection(_parentId, result.ResultId, 0))
                                    {
                                        if (courseDal.InsertSection(sectionId, result.ResultId, 0))
                                        {
                                            if (result.Id == 200)
                                            {
                                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('تمت الاضافة بنجاح !','" + result.Message + "','success')", true);
                                            }
                                            else if (result.Id == 320 || result.Id == 105)
                                            {
                                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('تمت الاضافة بنجاح !','" + result.Message + "','success')", true);
                                            }
                                            FillCourses(_semesterId,_studentId);
                                            ClearSectionData();
                                            grdCourses.DataBind();
                                            transactionScope.Complete();
                                            return;
                                        }
                                        else
                                        {
                                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('عفوا !','" + "لا يمكن اضافة هذا السيكشن نظرا لاكتمال سعته" + "','error')", true);

                                            // FillCourses(_semesterId,_studentId);
                                            ClearSectionData();
                                            transactionScope.Dispose();
                                            return;
                                        }
                                    }
                                    else
                                    {
                                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('عفوا !','" + "لا يمكن اضافة هذا السيكشن نظرا لاكتمال سعته" + "','error')", true);

                                        //  FillCourses(_semesterId,_studentId);
                                        ClearSectionData();
                                        transactionScope.Dispose();
                                        return;
                                    }
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ !','" + result.Message + "','error')", true);

                                  //  FillCourses(_semesterId,_studentId);
                                    ClearSectionData();
                                    transactionScope.Dispose();
                                    return;
                                }
                                // Insert Sections Method With Update Status
                            //}
                            //else
                            //{
                            //    foreach (var item in conflictList)
                            //    {
                            //        errorMessage += "-المادة : " + item.SectionCode + " -قاعة : " + item.ClassName + "-اليوم: " + item.DayName + " التوقيت-: " + "(" + item.TimeFrom + " - " + item.TimeTo + ")" + " اسم المحاضر: " + item.EmployeeName + "<br>";
                            //    }
                            //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('تعارض !','" + errorMessage + "','warning')", true);
                            //  //  FillCourses(_semesterId,_studentId);
                            //    ClearSectionData();
                            //    transactionScope.Dispose();

                            //    return;
                            //}
                        }
                        else
                        {
                            errorMessage = "تم إضافة هذا السيكشن مسبقأ";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ !','" + errorMessage + "','warning')", true);
                           // FillCourses(_semesterId,_studentId);
                            ClearSectionData();
                            transactionScope.Dispose();
                            return;
                        }
                    }
                    else
                    {
                        errorMessage = "تم إضافة هذا الكورس من قبل ";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ !','" + errorMessage + "','warning')", true);
                      //  FillCourses(_semesterId,_studentId);
                        ClearSectionData();
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ أثناء الاضافة !','','error')", true);
                //transactionScope.Dispose();
                return;
            }
        }
    }

    protected ResultValue AddCourse(int _courseId, int _semesterId)
    {
        //  int comphours = Convert.ToInt32(hdnCompltedhours.Value);
        int departid = Convert.ToInt32(departmentIdHdn.Value);
        int cousid = Convert.ToInt32(courses.SelectedValue);
        //decimal studentGPA = Convert.ToDecimal(lblGPA.Text);

        ResultValue result = new ResultValue();


        TeiLib.StudentsAdvising studentAdv = new TeiLib.StudentsAdvising();
        studentAdv.StudentId = Convert.ToInt32(studentId.Value);
        studentAdv.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
        studentAdv.CourseId = Convert.ToInt32(courses.SelectedValue);
        studentAdv.AdvisingBy = Page.User.Identity.Name.ToString();
        studentAdv.YearId = Convert.ToInt32(hdn_yearId.Value);
        studentAdv.DoctorCoursesId = Convert.ToInt32(ddlDoctor.SelectedValue);
        result = InsertCourse(studentAdv);
        if (result.Id == 200 || result.Id == 320 || result.Id==105)
        {
            LogStudentsAdvising log = new LogStudentsAdvising();
            log.StudentId = Convert.ToInt32(studentId.Value);
            log.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
            log.Action = "InsertRow";
            log.CourseId = Convert.ToInt32(courses.SelectedValue);
            log.UserName = Page.User.Identity.Name.ToString()+" With Confilct";
            LogStudentsAdvisingDAL.Insert(log);

        }

        return result;

    }
    private ResultValue InsertCourse(TeiLib.StudentsAdvising studentAdv)
    {
        int IsRepeated = 0;
        int TotalActualCredit = 0;
        int ContactHours = 0;
        int ErrorCode = 0;
        int AdvisingId = 0;
        ResultValue result = new ResultValue();
        int TotalCredit = StudentsAdvisingDAL.Insert(studentAdv, out IsRepeated, out TotalActualCredit, out ContactHours, out ErrorCode, out AdvisingId);
        TotalCreditperSemester = TotalCredit;
        if (TotalCredit > 21 || ErrorCode == 108)
        {
            result.Id = 108;
            result.Message = "لقد تعديت عدد الساعات المسموح بها للتسجيل";
            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لقد تعديت عدد الساعات المسموح بها للتسجيل')", true);
        }
        else if (ErrorCode == 101)
        {
            result.Id = 101;
            result.Message = "يجب ان يجتاز الطالب المتطلب السابق - راجع المرشد الأكاديمي";
            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('')", true);
        }
        else if (ErrorCode == 102)
        {
            result.Id = 102;
            result.Message = "هذه المادة مكررة في الفصل الدراسي المختار";
        }

        else if (ErrorCode == 103)
        {
            result.Id = 103;
            result.Message = "المتطلب السابق تم اختياره مسبقا في نفس الفصل الدراسي";
        }

        else if (ErrorCode == 104)
        {
            result.Id = 104;
            result.Message = "الطالب لم يسجل في المتطلب السابق";
        }

        else if (ErrorCode == 105)
        {
            result.Id = 105;
            result.Message = "انتبه! الطالب سجل هذه المادة أكثر من مرتين";
            result.ResultId = AdvisingId;
        }

        else if (ErrorCode == 106)
        {
            result.Id = 106;
            result.Message = "انتبه!هذه المرة السابعة لدخول هذه المادة ويعتبر الطالب مفصول فصلا نهائيا من المعهد";

        }

        else if (ErrorCode == 107)
        {
            result.Id = 107;
            result.Message = "الترم الصيفي لا يمكن تسجيل أكثر من 6 ساعات معتمدة";
        }

        else if (ErrorCode == 320)
        {
            result.Id = 320;
            result.Message = "المادة المسجلة سوف تحتسب كمادة تحسين لانك ناجح فيها من قبل";
            result.ResultId = AdvisingId;
        }
        else
        {
            result.Id = 200;
            result.Message = "تمت الاضافة بنجاح";
            result.ResultId = AdvisingId;
        }

        return result;
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
        DataTable table2 = StudentsAdvisingDAL.GetByPage(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnSemesterId.Value), 0, 30, out credit, out contact);
        int x = 0;
        decimal yyy = 0;
        string uuu = "";
        DataTable table = StudentsAdvisingDAL.GetByStudent(Convert.ToInt32(studentId.Value), out x, out yyy, out uuu, out x, out x, out x);

        Session["totalCredit"] = credit;// = e.OutputParameters["TotalCredit"].ToString();
        Session["contactHours"] = contact;// = e.OutputParameters["TotalContact"].ToString();
        Session["studentCode"] = hdnStudentCode.Value;
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

        Session["studentCode"] = hdnStudentCode.Value;
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
            TotalCost = StudentsAccountingDAL.GetHoursCost(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnSemesterId.Value), Convert.ToInt32(hdnExpensesId.Value)).Rows[0]["TotalCost"].ToString();
        }


        //TotalCost = tlbCosts.Rows[0]["TotalCost"].ToString();
        DataTable table = StudentsAdvisingDAL.GetByPage(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnSemesterId.Value), 0, 30, out credit, out contact);
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
        Session["studentCode"] = hdnStudentCode.Value;
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
            TotalCost = StudentsAccountingDAL.GetHoursCost(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnSemesterId.Value), Convert.ToInt32(hdnExpensesId.Value)).Rows[0]["TotalCost"].ToString();
            //decimal totPrice = Convert.ToDecimal(TotalCost) + Convert.ToDecimal(602);
            //TotalCost = Convert.ToString(totPrice);
        }


        //TotalCost = tlbCosts.Rows[0]["TotalCost"].ToString();
        DataTable table = StudentsAdvisingDAL.GetByPage(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnSemesterId.Value), 0, 30, out credit, out contact);
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
        Session["studentCode"] = hdnStudentCode.Value;
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

    protected void returnBTN_Click(object sender, EventArgs e)
    {
        PageView.ActiveViewIndex = 0;
        returnBTN.Visible = false;
        Response.Redirect("Default.aspx");

    }

    protected void btnStudentExpectedGPAReport4_Click(object sender, EventArgs e)
    {
        DataTable table3 = StudentsAdvisingDAL.CalcualateExpectedGPAByStudent(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnSemesterId.Value));

        int completedHours_var = 0;
        int registeredHours_var = 0;
        int restHours_var = 0;
        int x = 0;
        decimal yyy = 0;
        string uuu = "";
        DataTable table_1 = StudentsAdvisingDAL.GetByStudent(Convert.ToInt32(studentId.Value), out x, out yyy, out uuu, out completedHours_var, out registeredHours_var, out restHours_var);
        Session["studentCode"] = hdnStudentCode.Value;
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
        TeiLib.Semester sem = SemestersDAL.GetById(Convert.ToInt32(hdnSemesterId.Value));
        hdn_yearId.Value = sem.YearId.ToString();

    }

    private void FillCourses(int semesterId,int _studentId)
    {

        courses.Items.Clear();
        courses.DataSource = CoursesDAL.GetOfferedCourse(Convert.ToInt32(departmentIdHdn.Value), semesterId,_studentId);
        courses.DataValueField = "CourseId";
        courses.DataTextField = "ArCourseName";
        courses.DataBind();
        courses.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }
    private void FillSemesters()
    {

        semesters.Items.Clear();
        semesters.DataSource = SemestersDAL.GetAll();
        semesters.DataValueField = "SemesterId";
        semesters.DataTextField = "ArSemesterName";
        semesters.DataBind();
        semesters.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }

    private void FillDoctors()
    {

        ddlDoctor.Items.Clear();
        ddlDoctor.DataSource = CoursesDAL.GetParentSection(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(hdnSemesterId.Value)).GroupBy(test => test.SectionCode)
                   .Select(grp => grp.First())
                   .ToList(); ;
        ddlDoctor.DataValueField = "SectionId";
        ddlDoctor.DataTextField = "SectionWithInstructor";
        ddlDoctor.DataBind();
        ddlDoctor.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }

    protected void courses_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (courses.SelectedValue == "0")
        {
            ClearSectionData();

        }
        FillDoctors();

    }

    protected void ddlDoctor_SelectedIndexChanged(object sender, EventArgs e)
    {

        if (ddlDoctor.SelectedValue == "0")
        {
            ClearSectionData();
            return;
        }

        int sectionId = Convert.ToInt32(ddlDoctor.SelectedValue);
        hdnParentId.Value = sectionId.ToString();
        List<SectionDTO> sectionList = CoursesDAL.GetSectionDetails(sectionId,Convert.ToInt32(hdnSemesterId.Value));
        parentmeSegments.DataSource = sectionList;
        parentmeSegments.DataBind();

        if (sectionList.Count > 0)
        {
            if (sectionList[0].ReservedCapacity >= sectionList[0].Capacity)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('مجموعة الدكتور مكتاملة يجب اختيار دكتور اخر')", true);
                return;
                //btnAdd.Enabled = false;
            }
            List<SectionDTO> childrenList = CoursesDAL.GetChildrenSections(sectionId, Convert.ToInt32(hdnSemesterId.Value));
            if (childrenList.Count > 0 && sectionList[0].HasChild == 1)
            {
                sectionPlaceHolder.Visible = true;
                noChildrenHolder.Visible = false;
                childrenTitleRepeater.DataSource = childrenList.GroupBy(x => x.SectionCode).Select(grp => grp.First())
                   .ToList();

                childrenTitleRepeater.DataBind();

            }
            else if (sectionList[0].HasChild == 0)
            {
                sectionPlaceHolder.Visible = false;
                noChildrenHolder.Visible = false;
            }
            else
            {
                sectionPlaceHolder.Visible = false;
                noChildrenHolder.Visible = true;
            }

            //else
            //    btnAdd.Enabled = true;

        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('لا يوجد مواعيد متاحة لهذه المجموعة')", true);
            ClearSectionData();
            return;

        }

    }
    protected void childrenRepeater_OnItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int sectionId = Convert.ToInt32((e.Item.FindControl("hdnSectionId") as HiddenField).Value);
            Repeater childrenRepeater = e.Item.FindControl("childrenRepeater") as Repeater;
            childrenRepeater.DataSource = CoursesDAL.GetSectionDetails(sectionId, Convert.ToInt32(hdnSemesterId.Value));
            childrenRepeater.DataBind();
        }
    }
    private void ClearSectionData()
    {
        FillDoctors();
        parentmeSegments.DataSource = null;
        parentmeSegments.DataBind();
        childrenTitleRepeater.DataSource = null;
        childrenTitleRepeater.DataBind();
        sectionPlaceHolder.Visible = false;
        noChildrenHolder.Visible = false;
    }
    protected void grdCourses_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            try
            {
                using (TransactionScope transactionScope = new TransactionScope(TransactionScopeOption.RequiresNew, new TransactionOptions() { IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted }))
                {
                    HiddenField sectionLbl = (((e.CommandSource as LinkButton).Parent.FindControl("sectionLbl")) as HiddenField);
                    StudentsAdvisingDAL stuAdvDal = new StudentsAdvisingDAL();
                    CoursesDAL coursesDal = new CoursesDAL();
                    if (coursesDal.DeleteSection(Convert.ToInt32(sectionLbl.Value), Convert.ToInt32(e.CommandArgument)))
                    {
                        if (stuAdvDal.Delete(Convert.ToInt32(e.CommandArgument), Page.User.Identity.Name.ToString()) > 0)
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('تم حذف المادة','','success')", true);
                            grdCourses.DataBind();
                            transactionScope.Complete();
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ أثناء الحذف !','','error')", true);
                            transactionScope.Dispose();
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ أثناء الحذف !','','error')", true);
                        transactionScope.Dispose();
                    }

                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ أثناء الحذف !','','error')", true);
                //transactionScope.Dispose();
                return;
            }

        }
    }


    //protected void parentmeSegments_ItemCreated(object sender, RepeaterItemEventArgs e)
    //{
    //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
    //    {
    //        int hasChildren = Convert.ToInt32((e.Item.FindControl("hdnHasChildren") as HiddenField).Value);
    //        e.Item.FindControl("btnAdd").Visible = hasChildren ==0?false:true;
    //    }
    //}


    protected void parentmeSegments_OnItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            int hasChildren = Convert.ToInt32((e.Item.FindControl("hdnHasChildren") as HiddenField).Value);
            int hdnIndex = Convert.ToInt32((e.Item.FindControl("hdnParentIndex") as HiddenField).Value);
            e.Item.FindControl("btnAdd").Visible = hasChildren == 0  ? true : false;
        }
    }
    protected void parentmeSegments_ItemCommand(object source, RepeaterCommandEventArgs e)
    {

        if (e.CommandName == "AddSection")
        {
            try
            {
                using (TransactionScope transactionScope = new TransactionScope(TransactionScopeOption.RequiresNew, new TransactionOptions() { IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted }))
                {
                    int _studentId = Convert.ToInt32(studentId.Value);
                    int _parentId = Convert.ToInt32(hdnParentId.Value);
                    int sectionId = Convert.ToInt32(e.CommandArgument);
                    int courseId = Convert.ToInt32(courses.SelectedValue);
                    string errorMessage = "";
                    int _semesterId = Convert.ToInt32(hdnSemesterId.Value);
                    if (!CoursesDAL.IsCourseExist(courseId, _parentId, _studentId, _semesterId))
                    {
                        if (!CoursesDAL.IsSectionExist(sectionId, _parentId, _studentId, _semesterId))
                        {
                            //List<StudentAdvisingDTO> conflictList = CoursesDAL.CheckSectionConflict(0,sectionId, _studentId, _semesterId);

                            //if (conflictList.Count == 0)
                            //{
                                // Insert Course
                                ResultValue result = new ResultValue();
                                result = AddCourse(courseId, _semesterId);
                                if (result.Id == 200 || result.Id == 320 || result.Id == 105)
                                {
                                    CoursesDAL courseDal = new CoursesDAL();
                                    //if (courseDal.InsertSection(_parentId, result.ResultId, 0))
                                    //{
                                    if (courseDal.InsertSection(sectionId, result.ResultId, 0))
                                    {
                                        if (result.Id == 200)
                                        {
                                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('تمت الاضافة بنجاح !','" + result.Message + "','success')", true);
                                        }
                                        else if (result.Id == 320 || result.Id == 105)
                                        {
                                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('تمت الاضافة بنجاح !','" + result.Message + "','success')", true);
                                        }

                                        FillCourses(_semesterId,_studentId);
                                        ClearSectionData();
                                        grdCourses.DataBind();
                                        transactionScope.Complete();
                                        return;
                                    }
                                    else
                                    {
                                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('عفوا !','" + "لا يمكن اضافة هذا السيكشن نظرا لاكتمال سعته" + "','error')", true);
                                        transactionScope.Dispose();
                                       // FillCourses(_semesterId,_studentId);
                                        ClearSectionData();
                                        return;
                                    }
                                    //    else
                                    //    {
                                    //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ أثناء الاضافة !','','error')", true);
                                    //        //transactionScope.Dispose();
                                    //        return;
                                    //    }
                                    //}

                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ !','" + result.Message + "','error')", true);
                                    transactionScope.Dispose();
                                  //  FillCourses(_semesterId,_studentId);
                                    ClearSectionData();
                                    return;
                                }
                                // Insert Sections Method With Update Status
                           // }
                            //else
                            //{
                            //    foreach (var item in conflictList)
                            //    {
                            //        errorMessage += "-المادة : " + item.SectionCode + " -قاعة : " + item.ClassName + "-اليوم: " + item.DayName + " التوقيت-: " + "(" + item.TimeFrom + " - " + item.TimeTo + ")" + " اسم المحاضر: " + item.EmployeeName + "<br>";
                            //    }
                            //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('تعارض !','" + errorMessage + "','warning')", true);
                            //    transactionScope.Dispose();
                            //  //  FillCourses(_semesterId,_studentId);
                            //    ClearSectionData();
                            //    return;
                            //}
                        }
                        else
                        {
                            errorMessage = "تم إضافة هذا السيكشن مسبقأ";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ !','" + errorMessage + "','warning')", true);
                            transactionScope.Dispose();
                           // FillCourses(_semesterId,_studentId);
                            ClearSectionData();
                            return;
                        }
                    }
                    else
                    {
                        errorMessage = "تم إضافة هذا الكورس من قبل ";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ !','" + errorMessage + "','warning')", true);
                       // FillCourses(_semesterId,_studentId);
                        ClearSectionData();
                        transactionScope.Dispose();
                        return;
                    }


                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('خطأ أثناء الاضافة !','','error')", true);
                //transactionScope.Dispose();
                return;
            }
        }
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetStudentData(txtStudentCode.Text);
    }
}


