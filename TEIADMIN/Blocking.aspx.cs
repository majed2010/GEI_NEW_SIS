using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;
using System.Data;
using System.Collections;
public partial class Blocking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Blocking"))
            PageView.ActiveViewIndex = 1;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        DataTable tblStudents = StudentsDAL.GetByCode(txtٍStudentCode.Text);
        if (tblStudents.Rows.Count == 1)
        {
            studentId.Value = tblStudents.Rows[0]["StudentId"].ToString();
            lblFullName.Text = tblStudents.Rows[0]["ArFullName"].ToString();
            lblDept.Text = tblStudents.Rows[0]["ArDepartmentName"].ToString();
            lblLevel.Text = tblStudents.Rows[0]["ArLevelName"].ToString();
            BlockingGridView.DataBind();
            addCoursesHolder.Visible = true;
            BlockingGridView.Visible = true;
        }
        else
        {
            lblFullName.Text = "";
            lblDept.Text = "";
            lblLevel.Text = "";
        }

    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        Block block = new Block();
        block.StudentCode = txtٍStudentCode.Text;
        block.Type =Convert.ToInt32 (BlockStudents.SelectedValue);
        //InsertBlockedStudent(block);
        int ErrorCode = BlockedDAL.Insert(block, out ErrorCode);

       


        if (ErrorCode==0)
        {
            LogStudentsAdvising log = new LogStudentsAdvising();
            log.StudentId = Convert.ToInt32(studentId.Value);
            log.SemesterId = 1;
            log.Action = "InsertRowTblBlocked";
            log.CourseId = Convert.ToInt32(BlockStudents.SelectedValue);
            log.UserName = Page.User.Identity.Name.ToString();
            LogStudentsAdvisingDAL.Insert(log);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('تم الحفظ')", true);
            

        }
      else if (ErrorCode == 100 && block.Type!=0)
        {
            block.StudentCode = txtٍStudentCode.Text;
            BlockedDAL.Update(block);
            LogStudentsAdvising log = new LogStudentsAdvising();
            log.StudentId = Convert.ToInt32(studentId.Value);
            log.SemesterId = 1;
            log.Action = "UpdatetRowTblBlocked";
            log.CourseId = Convert.ToInt32(BlockStudents.SelectedValue);
            log.UserName = Page.User.Identity.Name.ToString();
            LogStudentsAdvisingDAL.Insert(log);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('تم التعديل')", true);
            
        }
       else if (ErrorCode == 100 && block.Type == 0)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('كود الطالب موجود مسبقاً')", true);
        }
        BlockingGridView.DataBind();
    }

    /*private void InsertBlockedStudent(Block block)
    {
        int ErrorCode =BlockedDAL.Insert(block,out ErrorCode);

        if (ErrorCode == 100)
        {

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('كود الطالب موجود مسبقاً')", true);
        }
        else
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alert", "alert('تم الحفظ')", true);

    }
    */
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }

    protected void CoursesDS_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        
    }

    protected void btnGenerateReport_Click(object sender, EventArgs e)
    {

       
    }
    protected void stateDDL_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }
    protected void BlockingGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "rowEdit")
        {
            //BlockedDataSource.DataBind();
            //BlockStudents.DataBind();
            Block block = BlockedDAL.GetById(e.CommandArgument.ToString());
            txtٍStudentCode.Text = block.StudentCode;
            BlockStudents.SelectedValue = block.Type.ToString();
            txtٍStudentCode.Text = e.CommandArgument.ToString();
            //BlockStudents.SelectedValue = block.ArBlockingTypeName.ToString();
        }
        else  if (e.CommandName == "rowDelete")
        {
            BlockedDAL.Delete(Convert.ToString(e.CommandArgument));
            LogStudentsAdvising log = new LogStudentsAdvising();
            log.StudentId = Convert.ToInt32(studentId.Value);
            log.SemesterId = 1;
            log.Action = "DeleteRowTblBlocked";
            log.CourseId = 1;
            log.UserName = Page.User.Identity.Name.ToString();
            LogStudentsAdvisingDAL.Insert(log);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('تم الحذف')", true);
            BlockingGridView.DataBind();
        }
    }
}
