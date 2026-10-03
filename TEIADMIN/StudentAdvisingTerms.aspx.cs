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
//using NewAdvisingData;
using TermsAdvisingBL;
using System.Transactions;
using TeiLib.BO;
using TermsAdvisingData;

public partial class StudentAdvisingTerms : System.Web.UI.Page
{
    int TotalCreditperSemester = 0;
    protected void Page_Load(object sender, EventArgs e)
    {

        //bool canRegister = false;
        //StudentsAdvisingDAL.CheckCanRegister(CurrentUser.GetStudentId(),33,out canRegister);

        //if (!canRegister)
        //{
        //    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "alerts", "alert('عفوا, لا يمكنك التسجيل')", true);

        //    Response.Redirect("Default.aspx");
        //}

        if (!IsPostBack)
        {
            FillSemesters();
            //semesters.SelectedValue = WebConfigurationManager.AppSettings["ActiveSemester"].ToString();
            hdnSemesterId.Value = WebConfigurationManager.AppSettings["AdvActiveSemester"].ToString();
            hdnResultSemesterId.Value = WebConfigurationManager.AppSettings["ResultActiveSemester"].ToString();
            //semesters.Enabled = false;
            TeiLib.Semester sem = SemestersDAL.GetById(Convert.ToInt32(WebConfigurationManager.AppSettings["AdvActiveSemester"].ToString()));
            hdnSemesterName.Value = sem.ArSemesterName;
            //  GetStudentData();
            hdn_yearId.Value = sem.YearId.ToString();
            //TermsAdvising bl = new TermsAdvising();
            //StudentAdvDTO dto = new StudentAdvDTO();
            //dto.StudentId = Convert.ToInt32(studentId.Value);
            //dto.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
            //dto.YearId = Convert.ToInt32(hdn_yearId.Value);
            //StudentLevel level = bl.GetStudentLevel(dto);
            //if (level.LevelId == 44 && level.YearId == 20 && level.IsPassed == true)
            //{
            //    FillLevels();
            //    selectLevelHolder.Visible = true;
            //    notPrepHolder.Visible = false;
            //    levelHolder.Visible = false;

            //}
            //else
            //{


            //    notPrepHolder.Visible = true;
            //    selectLevelHolder.Visible = false;
            //    levelHolder.Visible = true;
            //    FillSchedules();

            //    BindSchedule();
            //}




        }
    }

    private void BindSchedule()
    {
        GetStudentData();
        TermsAdvising adv = new TermsAdvising();

        StudentAdvDTO dto = new StudentAdvDTO();
        dto.StudentId = Convert.ToInt32(studentId.Value);
        dto.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
        Common cmn = new Common();

        ResultGrid.DataSource = Common.GetStudentTermsResults(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnResultSemesterId.Value));
        ResultGrid.DataBind();

        RepeatGrid.DataSource = Common.GetStudentRepeatTermsResults(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnResultSemesterId.Value));
        RepeatGrid.DataBind();
        StudentAdvising_Terms term = new StudentAdvising_Terms();
        term = adv.GetSavedSchedule(dto);
        if (term != null)
        {
            //if (term.Active != true)
            //{

            hdnSavedSchedule.Value = term.ScheduleId.ToString();
            dto.SelectedScheduleId = term.ScheduleId;
            List<TermsTimeSegment_Adv_View> schedule = adv.GetScheduleDetails(dto);
            grdCourses.DataSource = schedule;
            grdCourses.DataBind();
            lblSchedule.Text = schedule.FirstOrDefault().ScheduleName;
            HideAddSchedule();
            //}
            //else
            //{
            //    Response.Redirect("TermsPayment.aspx");
            //}

        }
        else
        {
            dto.YearId = Convert.ToInt32(hdn_yearId.Value);
            StudentLevel level = adv.GetStudentLevel(dto);
            if ((level.LevelId == 45 || level.LevelId == 49 || level.LevelId == 53) && level.YearId == 21 && level.IsPassed == true)
            {
                //FillLevels();
                //selectLevelHolder.Visible = true;
                //notPrepHolder.Visible = false;
                //levelHolder.Visible = false;
                //btnChangeLevel.Visible = true;

            }
            else
            {
                btnChangeLevel.Visible = false;


            }

            //else
            //{
            //    ddlSchedules.SelectedValue = "0";
            levelHolder.Visible = true;
            grdCourses.DataSource = null;
            grdCourses.DataBind();
            HideRemoveSchedule();
            // }
        }
    }

    private void HideAddSchedule()
    {
        addScheduleHolder.Visible = false;
        removeSchedule.Visible = true;
        levelHolder.Visible = false;
    }

    private void HideRemoveSchedule()
    {
        removeSchedule.Visible = false;
        addScheduleHolder.Visible = true;
        levelHolder.Visible = true;
    }
    public void FillSchedules()
    {
        TermsAdvising bl = new TermsAdvising();
        StudentAdvDTO advDTO = new StudentAdvDTO();
        advDTO.StudentId = Convert.ToInt32(studentId.Value);
        advDTO.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
        advDTO.LevelId = Convert.ToInt32(hdnLevelId.Value);
        advDTO.DepartmentId = Convert.ToInt32(departmentIdHdn.Value);
        ddlSchedules.Items.Clear();
        ddlSchedules.DataSource = bl.GetValidSchedules(advDTO);
        ddlSchedules.DataValueField = "ScheduleID";
        ddlSchedules.DataTextField = "ScheduleName";
        ddlSchedules.DataBind();
        ddlSchedules.Items.Insert(0, new ListItem("-- اختر --", "0"));

    }

    public void FillLevels()
    {
        TermsAdvising bl = new TermsAdvising();

        ddlLevel.Items.Clear();
        ddlLevel.DataSource = bl.GetLevels();
        ddlLevel.DataValueField = "LevelId";
        ddlLevel.DataTextField = "ArLevelName";
        ddlLevel.DataBind();
        ddlLevel.Items.Insert(0, new ListItem("-- اختر --", "0"));

    }
    string studentCode;
    int CertificateId = 0;
    private void GetStudentData(string txtSudentCode)
    {
        //Common cmn = new Common();

        //Common.GetStudentTermsResults(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnResultSemesterId.Value));
        // ResultGrid.DataBind();
        DataTable studentTable = StudentsDAL.GetByCode(txtSudentCode);
        bool isterms;
        isterms = Convert.ToBoolean(studentTable.Rows[0]["Isterms"]);
        if (isterms == false)
        {
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "alerts", "alert('الطالب خريج ولا يمكنه التسجيل مرة اخرى')", true);

            Response.Redirect("Default.aspx");
        }
        studentCode = studentTable.Rows[0]["StudentCode"].ToString();
        CertificateId = Convert.ToInt32(studentTable.Rows[0]["CertificateId"]);
        //hdnLevelId.Value =studentTable.Rows[0]["LevelId"].ToString();
        lblLevel.Text = studentTable.Rows[0]["TermsLevel"].ToString();
        //lblGrade.Text = Common.GetStudentTotalResults(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnResultSemesterId.Value)).Rows[0]["GradeName"].ToString();
        int rowCount = BlockedDAL.GetBlockingOfStudent(studentCode).Rows.Count;
        hdnStudentCode.Value = studentCode;
        if (rowCount == 1)
        {
            PageView.ActiveViewIndex = 1;
            Label2.Visible = true;
            if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 1 
                || Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 16)
                finance.Visible = true;
            else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 2)
                affairs.Visible = true;
            else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 3)
                AdvisingDepart.Visible = true;
            //else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 13)
            //Label1.Visible = true;
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
            PageView.ActiveViewIndex = 0;
            string _str = StudentsDAL.GetByCode(studentCode).Rows[0]["DepartmentId"].ToString();
        }
        //if (CurrentUser.GetDepartmentId() == Convert.ToInt32(_str))
        //{
        //    //  noRegisterlbl.Visible = false;
        //    if (rowCount > 0)
        //{
        //    //PageView.ActiveViewIndex = 1;
        //    //Label2.Visible = true;
        //    //returnBTN.Visible = true;
        //    departmentIdHdn.Value = _str;
        ////if (rowCount == 1)
        ////    if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 1)
        ////        finance.Visible = true;
        ////    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 2)
        ////        affairs.Visible = true;
        ////    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 3)
        ////        AdvisingDepart.Visible = true;
        ////    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 13)
        ////        Label1.Visible = true;
        ////    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 4)
        ////    {
        ////        affairs.Visible = true;
        ////        affairs.Text += " و";
        ////        AdvisingDepart.Visible = true;
        ////    }
        ////    else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 5)
        ////    {
        ////        finance.Visible = true;
        ////        finance.Text += " و";
        ////        AdvisingDepart.Visible = true;
        ////    }
        ////    else
        ////    {
        ////        finance.Visible = true;
        ////        finance.Text += " و";
        ////        affairs.Visible = true;
        ////    }
        //    //hdn_yearId.Value = sem.YearId.ToString();
        //    FillSchedules();
        //}
        //else
        //    {


        DataTable tblStudents = StudentsDAL.GetByCode(studentCode);
        if (tblStudents.Rows.Count == 1)
        {
            lblStudentCode.Text = tblStudents.Rows[0]["StudentCode"].ToString();
            studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
            lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
            departmentIdHdn.Value = tblStudents.Rows[0]["DepartmentId"].ToString();
            lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();
            FillCourses(Convert.ToInt32(hdnSemesterId.Value), Convert.ToInt32(studentId.Value));
            if (Common.GetStudentTotalResults(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnResultSemesterId.Value)).Rows.Count > 0)
                lblGrade.Text = Common.GetStudentTotalResults(Convert.ToInt32(studentId.Value), Convert.ToInt32(hdnResultSemesterId.Value)).Rows[0]["YearGrade"].ToString();
            // Adv1ObjectDataSource.Select();
            // DataTable tblExpenses = StudentsAccountingDAL.GET_ExpensesId_By_StudentCode(studentCode);
            // hdnExpensesId.Value = tblExpenses.Rows[0]["ExpensesId"].ToString();
            GetScheduleInfo();
            if (Convert.ToInt32(departmentIdHdn.Value) == 1)
            {
                //generalnumbers.Visible = true;
                //civinumbers.Visible = false;
                //archnumbers.Visible = false;
                //ceenumbers.Visible = false;
                //GridView1.Visible = false;
            }
            else if (Convert.ToInt32(departmentIdHdn.Value) == 4)
            {
                // generalnumbers.Visible = false;
                //civinumbers.Visible = false;
                //CivilTables.Visible = false;
                //archnumbers.Visible = false;
                //ceenumbers.Visible = false;
                //ArchTables.Visible = false;
                //CEETables.Visible = false;
                // GridView1.Visible = false;
            }

            else if (Convert.ToInt32(departmentIdHdn.Value) == 3)
            {
                // generalnumbers.Visible = false;
                //civinumbers.Visible = false;
                //archnumbers.Visible = false;
                //ArchTables.Visible = false;
                //ceenumbers.Visible = false;
                //CEETables.Visible = false;
                //CivilTables.Visible = false;
                // GridView1.Visible = false;
            }

            else if (Convert.ToInt32(departmentIdHdn.Value) == 2)
            {
                // generalnumbers.Visible = false;
                //civinumbers.Visible = false;
                //archnumbers.Visible = false;
                //ceenumbers.Visible = false;
                //CEETables.Visible = false;
                //ArchTables.Visible = false;
                //CivilTables.Visible = false;
                //GridView1.Visible = false;
            }
            else
            {
                //   ADDAdvisingByBlock.Visible = false;
                //AddCivilBlock.Visible = false;
                //AddCivil4Level.Visible = false;
            }
            //GridView1.DataBind();
            //GridView1.Visible = false;
            //addCoursesHolder.Visible = true;
        }
        else
        {
            lblFullName.Text = "";
            lblDept.Text = "";
            //  addCoursesHolder.Visible = false;
        }
        // }
        //}
        //else
        //{
        //    //PageView.ActiveViewIndex = 1;
        //    //noRegisterlbl.Visible = true;
        //    //Label2.Visible = false;
        //    //returnBTN.Visible = true;
        //}
    }

    private void GetScheduleInfo()
    {
        TermsAdvising bl = new TermsAdvising();
        StudentAdvDTO dto = new StudentAdvDTO();
        dto.StudentId = Convert.ToInt32(studentId.Value);
        dto.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
        dto.YearId = Convert.ToInt32(hdn_yearId.Value);
        StudentLevel level = bl.GetStudentLevel(dto);
        hdnLevelId.Value = level.LevelId.ToString();
        if (level.LevelId == 44 && level.YearId == 20 && level.IsPassed == true)
        {
            FillLevels();
            selectLevelHolder.Visible = true;
            notPrepHolder.Visible = false;
            levelHolder.Visible = false;

        }
        else
        {


            notPrepHolder.Visible = true;
            selectLevelHolder.Visible = false;
            levelHolder.Visible = true;
            FillSchedules();

            BindSchedule();
        }
    }

    private void GetStudentData()
    {

        DataTable studentTable = StudentsDAL.GetById2(Convert.ToInt32(studentId.Value));

        studentCode = studentTable.Rows[0]["StudentCode"].ToString();
        CertificateId = Convert.ToInt32(studentTable.Rows[0]["CertificateId"]);
        hdnLevelId.Value = studentTable.Rows[0]["LevelId"].ToString();
        int rowCount = BlockedDAL.GetBlockingOfStudent(studentCode).Rows.Count;
        hdnStudentCode.Value = studentCode;

        string _str = StudentsDAL.GetByCode(studentCode).Rows[0]["DepartmentId"].ToString();
        if (CurrentUser.GetDepartmentId() == Convert.ToInt32(_str))
        {
            //  noRegisterlbl.Visible = false;
            if (rowCount > 0)
            {
                //PageView.ActiveViewIndex = 1;
                //Label2.Visible = true;
                //returnBTN.Visible = true;
                departmentIdHdn.Value = _str;
                //if (rowCount == 1)
                //if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 1)
                //    finance.Visible = true;
                //else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 2)
                //    affairs.Visible = true;
                //else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 3)
                //    AdvisingDepart.Visible = true;
                //else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 13)
                //    Label1.Visible = true;
                //else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 4)
                //{
                //    affairs.Visible = true;
                //    affairs.Text += " و";
                //    AdvisingDepart.Visible = true;
                //}
                //else if (Convert.ToInt32(BlockedDAL.GetBlockingOfStudent(studentCode).Rows[0]["Type"]) == 5)
                //{
                //    finance.Visible = true;
                //    finance.Text += " و";
                //    AdvisingDepart.Visible = true;
                //}
                //else
                //{
                //    finance.Visible = true;
                //    finance.Text += " و";
                //    affairs.Visible = true;
                //}
                GetScheduleInfo();
            }
            else
            {

                DataTable tblStudents = StudentsDAL.GetByCode(studentCode);
                if (tblStudents.Rows.Count == 1)
                {
                    lblStudentCode.Text = tblStudents.Rows[0]["StudentCode"].ToString();
                    studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
                    lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
                    departmentIdHdn.Value = tblStudents.Rows[0]["DepartmentId"].ToString();
                    lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();
                    FillCourses(Convert.ToInt32(hdnSemesterId.Value), Convert.ToInt32(studentId.Value));
                    // Adv1ObjectDataSource.Select();
                    // DataTable tblExpenses = StudentsAccountingDAL.GET_ExpensesId_By_StudentCode(studentCode);
                    // hdnExpensesId.Value = tblExpenses.Rows[0]["ExpensesId"].ToString();
                    GetScheduleInfo();
                    if (Convert.ToInt32(departmentIdHdn.Value) == 1)
                    {
                        //generalnumbers.Visible = true;
                        //civinumbers.Visible = false;
                        //archnumbers.Visible = false;
                        //ceenumbers.Visible = false;
                        //GridView1.Visible = false;
                    }
                    else if (Convert.ToInt32(departmentIdHdn.Value) == 4)
                    {
                        // generalnumbers.Visible = false;
                        //civinumbers.Visible = false;
                        //CivilTables.Visible = false;
                        //archnumbers.Visible = false;
                        //ceenumbers.Visible = false;
                        //ArchTables.Visible = false;
                        //CEETables.Visible = false;
                        // GridView1.Visible = false;
                    }

                    else if (Convert.ToInt32(departmentIdHdn.Value) == 3)
                    {
                        // generalnumbers.Visible = false;
                        //civinumbers.Visible = false;
                        //archnumbers.Visible = false;
                        //ArchTables.Visible = false;
                        //ceenumbers.Visible = false;
                        //CEETables.Visible = false;
                        //CivilTables.Visible = false;
                        // GridView1.Visible = false;
                    }

                    else if (Convert.ToInt32(departmentIdHdn.Value) == 2)
                    {
                        // generalnumbers.Visible = false;
                        //civinumbers.Visible = false;
                        //archnumbers.Visible = false;
                        //ceenumbers.Visible = false;
                        //CEETables.Visible = false;
                        //ArchTables.Visible = false;
                        //CivilTables.Visible = false;
                        //GridView1.Visible = false;
                    }
                    else
                    {
                        //   ADDAdvisingByBlock.Visible = false;
                        //AddCivilBlock.Visible = false;
                        //AddCivil4Level.Visible = false;
                    }
                    //GridView1.DataBind();
                    //GridView1.Visible = false;
                    //addCoursesHolder.Visible = true;
                }
                else
                {
                    lblFullName.Text = "";
                    lblDept.Text = "";
                    //  addCoursesHolder.Visible = false;
                }
            }
        }
        else
        {
            //PageView.ActiveViewIndex = 1;
            //noRegisterlbl.Visible = true;
            //Label2.Visible = false;
            //returnBTN.Visible = true;
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetStudentData(txtStudentCode.Text);
    }


    private int GetType(int ExpensesID)
    {
        ExpensesRegular expen = ExpensesRegularDAL.GetById(ExpensesID);
        return expen.ExpensesType;
    }

    protected void returnBTN_Click(object sender, EventArgs e)
    {
        //PageView.ActiveViewIndex = 0;
        //returnBTN.Visible = false;
        Response.Redirect("Default.aspx");

    }



    protected void semesters_SelectedIndexChanged(object sender, EventArgs e)
    {
        TeiLib.Semester sem = SemestersDAL.GetById(Convert.ToInt32(hdnSemesterId.Value));
        hdn_yearId.Value = sem.YearId.ToString();

    }

    private void FillCourses(int semesterId, int _studentId)
    {

        //courses.Items.Clear();
        //courses.DataSource = CoursesDAL.GetOfferedCourse(Convert.ToInt32(departmentIdHdn.Value), semesterId);
        //courses.DataValueField = "CourseId";
        //courses.DataTextField = "ArCourseName";
        //courses.DataBind();
        //courses.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }
    private void FillSemesters()
    {

        //semesters.Items.Clear();
        //semesters.DataSource = SemestersDAL.GetAll();
        //semesters.DataValueField = "SemesterId";
        //semesters.DataTextField = "ArSemesterName";
        //semesters.DataBind();
        //semesters.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }

    private void FillDoctors()
    {

        //ddlDoctor.Items.Clear();
        //ddlDoctor.DataSource = CoursesDAL.GetParentSection(Convert.ToInt32(courses.SelectedValue), Convert.ToInt32(hdnSemesterId.Value)).GroupBy(test => test.SectionCode)
        //           .Select(grp => grp.First())
        //           .ToList(); ;
        //ddlDoctor.DataValueField = "SectionId";
        //ddlDoctor.DataTextField = "SectionWithInstructor";
        //ddlDoctor.DataBind();
        //ddlDoctor.Items.Insert(0, new ListItem("-- اختر --", "0"));
    }

    protected void courses_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (courses.SelectedValue == "0")
        //{
        //    ClearSectionData();

        //}
        //FillDoctors();

    }



    private void ClearSectionData()
    {
        //FillDoctors();
        //parentmeSegments.DataSource = null;
        //parentmeSegments.DataBind();
        //childrenTitleRepeater.DataSource = null;
        //childrenTitleRepeater.DataBind();
        //sectionPlaceHolder.Visible = false;
        //noChildrenHolder.Visible = false;
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

                        /* change from stuAdvDal to  StudentsAdvisingDAL */
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
            e.Item.FindControl("btnAdd").Visible = hasChildren == 0 ? true : false;
        }
    }



    protected void ddlSchedules_SelectedIndexChanged(object sender, EventArgs e)
    {
        StudentAdvDTO dto = new StudentAdvDTO();
        dto.SelectedScheduleId = Convert.ToInt32(ddlSchedules.SelectedValue);
        TermsAdvising service = new TermsAdvising();
        grdCourses.DataSource = service.GetScheduleDetails(dto);
        grdCourses.DataBind();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        StudentAdvDTO dto = new StudentAdvDTO();
        dto.SelectedScheduleId = Convert.ToInt32(ddlSchedules.SelectedValue);
        dto.StudentId = Convert.ToInt32(studentId.Value);
        dto.LevelId = Convert.ToInt32(hdnLevelId.Value);
        dto.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
        dto.YearId = Convert.ToInt32(hdn_yearId.Value);
        TermsAdvising service = new TermsAdvising();
        service.SaveSchedule(dto);
    }

    protected void btnAdd_Click1(object sender, EventArgs e)
    {
        StudentAdvDTO dto = new StudentAdvDTO();
        dto.SelectedScheduleId = Convert.ToInt32(ddlSchedules.SelectedValue);
        dto.StudentId = Convert.ToInt32(studentId.Value);
        dto.LevelId = Convert.ToInt32(hdnLevelId.Value);
        dto.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
        dto.YearId = Convert.ToInt32(hdn_yearId.Value);
        TermsAdvising service = new TermsAdvising();
        TermsAdvisingBL.ResultValue result = service.SaveSchedule(dto);
        if (result.ResultId == 200)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('','" + "تمت الاضافة بنجاح" + "','success')", true);
            BindSchedule();
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('','" + result.Message + "' + ,'error')", true);
        }

    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        StudentAdvDTO dto = new StudentAdvDTO();
        dto.SavedScheduleId = Convert.ToInt32(hdnSavedSchedule.Value);
        dto.StudentId = Convert.ToInt32(studentId.Value);
        dto.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
        TermsAdvising service = new TermsAdvising();
        TermsAdvisingBL.ResultValue result = service.DeleteSchedule(dto);
        dto.YearId = Convert.ToInt32(hdn_yearId.Value);
        StudentLevel level = service.GetStudentLevel(dto);

        if (result.ResultId == 200)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('','" + "تمت  الحذف بنجاح" + "','success')", true);
            if ((level.LevelId == 45 || level.LevelId == 49 || level.LevelId == 53) && level.YearId == 21 && level.IsPassed == true)
            {
                FillLevels();
                selectLevelHolder.Visible = true;
                notPrepHolder.Visible = false;
                levelHolder.Visible = false;
                btnChangeLevel.Visible = true;

            }
            else
            {
                btnChangeLevel.Visible = false;
                BindSchedule();
                if ((level.LevelId == 45 || level.LevelId == 49 || level.LevelId == 53) && level.YearId == 21 && level.IsPassed == false)
                {

                }
            }

        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('','" + result.Message + "' + ,'error')", true);
        }
    }

    protected void btnStudentPayment_Click(object sender, EventArgs e)
    {
        int credit, contact;
        string TotalCost = "";
        DataTable studentTable = StudentsDAL.GetById2(Convert.ToInt32(studentId.Value));


        string studentCode = studentTable.Rows[0]["StudentCode"].ToString();
        string fullName = studentTable.Rows[0]["FullName"].ToString();
        string department = studentTable.Rows[0]["levelDept"].ToString();
        string levelName = studentTable.Rows[0]["ArLevelName"].ToString();
       
        if (lblLevel.Text == "الفرقة الاعدادية")
            TotalCost = "5750";
        else if (lblLevel.Text == "الفرقة الاولى اتصالات" || lblLevel.Text == "الفرقة الاولى عمارة" || lblLevel.Text == "الفرقة الاولى مدني")
            TotalCost = "6026";
        else if (lblLevel.Text == "الفرقة الثانية")
            TotalCost = "5655";
        else if (lblLevel.Text == "الفرقة الثالثة")
            TotalCost = "5406";
        else if (lblLevel.Text == "الفرقة الرابعة")
            TotalCost = "5176";

        Session["totalCredit"] = "0";// = e.OutputParameters["TotalCredit"].ToString();
        Session["contactHours"] = "0";// = e.OutputParameters["TotalContact"].ToString();
        Session["studentCode"] = hdnStudentCode.Value;
        Session["FullName"] = lblFullName.Text;// = tblStudents.Rows[0]["ArFullName"].ToString();
        Session["StudentDept"] = department;// = tblStudents.Rows[0]["ArDepartmentName"].ToString();lblLevel
        Session["Semester"] = hdnSemesterName.Value;
        Session["Level"] = levelName;
        Session["GPA"] = "0";
        Session["CompletedHours"] = "0";
        Session["RegisteredHours"] = "0";
        Session["RestHours"] = "0";
        Session["TotalCost"] = TotalCost;
        Session["Advisior"] = CurrentUser.GetFullName();
        Session["penlaty"] = "";
        Session["table"] = studentTable;

        Response.Redirect("StudentAdvPayment.aspx");
    }

    protected void btnSelectLevel_Click(object sender, EventArgs e)
    {
        TermsAdvising bl = new TermsAdvising();
        StudentAdvDTO dto = new StudentAdvDTO();
        dto.SelectedLevelId = Convert.ToInt32(ddlLevel.SelectedValue);
        dto.YearId = Convert.ToInt32(hdn_yearId.Value);
        dto.StudentId = Convert.ToInt32(studentId.Value);
        if (bl.UpdateStudentLevel(dto))
        {
            selectLevelHolder.Visible = false;
            levelHolder.Visible = true;
            notPrepHolder.Visible = true;
            hdnLevelId.Value = dto.SelectedLevelId.ToString();
            FillSchedules();
            BindSchedule();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('','" + "تمت  الاضافة بنجاح" + "','success')", true);

        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "sweetAlert('',' خطأ اثناء اختيار المستوى ' + ,'error')", true);
        }


    }

    protected void btnChangeLevel_Click(object sender, EventArgs e)
    {
        TermsAdvising adv = new TermsAdvising();

        StudentAdvDTO dto = new StudentAdvDTO();
        dto.StudentId = Convert.ToInt32(studentId.Value);
        dto.SemesterId = Convert.ToInt32(hdnSemesterId.Value);
        dto.YearId = Convert.ToInt32(hdn_yearId.Value);
        StudentLevel level = adv.GetStudentLevel(dto);
        if ((level.LevelId == 45 || level.LevelId == 49 || level.LevelId == 53) && level.YearId == 20)
        {
            FillLevels();
            selectLevelHolder.Visible = true;
            notPrepHolder.Visible = false;
            levelHolder.Visible = false;
            btnChangeLevel.Visible = false;
        }
    }
}


