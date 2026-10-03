using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using TeiLib;

public partial class AssignCourses : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCourses();
            int CategoryId;
            if (Request.QueryString["CategoryId"] == null || !int.TryParse(Request.QueryString["CategoryId"], out CategoryId) || CategoryId <= -1)
                Response.Redirect("Categories.aspx", true);
        }
    }
    
    protected void CategoriesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "deleteMethod")
        {
            if (CategoriesBL.Categories_Courses_Delete(Convert.ToInt32(e.CommandArgument)) > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "msg", "<script type='text/javascript' language='javascript'>alert('Deleted Successfully');</script>", false);
                BindCourses();                
                CategoriesGrid.DataBind();

            }
            else
            {
                deleteErr.Visible = true;
            }
        }
    
    }
   
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        int rows= CategoriesBL.Categories_Assign_Courses(Convert.ToInt32(Request.QueryString["CategoryId"]), Convert.ToInt32(ddlCourses.SelectedValue));
        if (rows > 0)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "msg", "<script type='text/javascript' language='javascript'>alert('Saved Successfully');</script>", false);
            BindCourses(); 
            CategoriesGrid.DataBind();
        }
        else
        {
            submitErr.Visible = true;
        }
    }

    protected void CategoriesDS_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        lnkCategory.Text = e.OutputParameters["categoryName"].ToString();
    }

    private void BindCourses()
    {
        ddlCourses.Items.Clear();
        ddlCourses.DataSource= CategoriesBL.Courses_NotInCategories(Convert.ToInt32(Request.QueryString["CategoryId"]),txtCourseName.Text);
        ddlCourses.DataTextField = "ArCourseName";
        ddlCourses.DataValueField = "CourseId";
        ddlCourses.Items.Insert(0,new ListItem("اختر","-"));
        ddlCourses.DataBind();
    }
    protected void btnSearch_Click2(object sender, EventArgs e)
    {
        BindCourses();
    }
    protected void btnSearch_Click1(object sender, EventArgs e)
    {
        CategoriesDS.SelectParameters["categoryId"].DefaultValue = Request.QueryString["CategoryId"].ToString();
        CategoriesDS.SelectParameters["searchCourseName"].DefaultValue = txtSearch.Text;
    }
   
}
