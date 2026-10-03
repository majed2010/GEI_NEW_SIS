using System;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using TeiLib;

public partial class admin_login : System.Web.UI.Page
{
    Hashtable cookie_values = new Hashtable();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Authenticate(object sender, EventArgs e)
    {
        //string password = Common.HashData(Password.Text);
        int error_code;

        User usr = UsersDAL.Authenticate(UserName.Text, Password.Text, 5, 15, DateTime.Now, out error_code);
        if (error_code == 0)
        {
            cookie_values.Add("UserId", usr.UserId);
            cookie_values.Add("FirstName", usr.FirstName);
            cookie_values.Add("LastName", usr.LastName);
            cookie_values.Add("DepartmentId", usr.DepartmentId);
            cookie_values.Add("Role", usr.RoleId);
            cookie_values.Add("UserName", UserName.Text);
            string sections = string.Empty;
            if (usr.RoleId != 1)
            {
                for (int i = 0; i < usr.Sections.Count; i++)
                {
                    sections += usr.Sections.GetKey(i) + ",";
                }
            }

            cookie_values.Add("Sections", sections.TrimEnd(','));
            CurrentUser.SetCookie(cookie_values);
            FormsAuthentication.SetAuthCookie(UserName.Text, true);

            FormsAuthentication.RedirectFromLoginPage(UserName.Text, false);
        }
        else
        {
            if (error_code == 2)
                FailureText.Text = "The account has been locked out due to multiple invalid login attempts.";
            else
                FailureText.Text = "Your login attempt was not successfull. Please try again.";
        }
    }
}
