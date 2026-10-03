using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using TeiLib;
public partial class StudentsInformationForCards : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable tblStudents = StudentsDAL.GetByCode(txtStudentCode.Text);
        if (tblStudents.Rows.Count == 1)
        {
            studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
            lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
            departmentIdHdn.Value = tblStudents.Rows[0]["DepartmentId"].ToString();
            lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();
            int recordsCount;
            decimal GPA;
            string LevelName;
            int completedHours1;
            int registeredHours1;
            int restHours1;
            DataTable dt = StudentsAdvisingDAL.GetByStudent(Convert.ToInt32(studentId.Value), out recordsCount, out GPA, out LevelName, out completedHours1, out registeredHours1, out restHours1);
            lblGPA.Text = GPA.ToString();
            lblLevel.Text = LevelName;
            completedHours.Text = completedHours1.ToString();
            registeredHours.Text = registeredHours1.ToString();
            restHours.Text = restHours1.ToString();



        }
        else
        {
            lblFullName.Text = "";
            lblDept.Text = "";
        }

    }
}