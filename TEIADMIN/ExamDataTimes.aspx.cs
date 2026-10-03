using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using TeiLib;

public partial class ExamDataTimes : System.Web.UI.Page
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
             hdnStudentId.Value = studentId.Value;
            grvRequests.DataBind();
            
         }
    }
}