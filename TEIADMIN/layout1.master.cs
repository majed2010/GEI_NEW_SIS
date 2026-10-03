using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using TeiLib;
using System.Collections;

public partial class layout : System.Web.UI.MasterPage
{
    HttpCookie cookie = HttpContext.Current.Request.Cookies["TEIAdmin1"];

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            if (cookie != null)
            {

                KeepAliveFrame.Attributes.Add("src", "blank.aspx");
                up1.Update();

                //userName.Text += CurrentUser.GetFullName();
                userId.Value = CurrentUser.GetUserId();

            }
            else
            {
                User user = new User();
                user = UsersDAL.GetById(Convert.ToInt32(userId.Value));
                Hashtable cookie_values = new Hashtable();
                cookie_values.Add("UserId", user.UserId);
                cookie_values.Add("FirstName", user.FirstName);
                cookie_values.Add("LastName", user.LastName);
                cookie_values.Add("Role", user.RoleId);

                CurrentUser.SetCookie(cookie_values);
            }
    }
    protected void btnLogout_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        FormsAuthentication.RedirectToLoginPage();
        CurrentUser.RemoveCookie();
    }
}
