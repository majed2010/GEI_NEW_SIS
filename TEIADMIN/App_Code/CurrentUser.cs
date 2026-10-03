using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Collections;

/// <summary>
/// Summary description for CurrentUser
/// </summary>
public class CurrentUser
{
    public static void SetCookie(Hashtable user)
    {
        HttpCookie cookie = new HttpCookie("TEIAdmin1");
        
        cookie.Values.Add("FirstName", HttpContext.Current.Server.UrlEncode(user["FirstName"].ToString()));
        cookie.Values.Add("LastName", HttpContext.Current.Server.UrlEncode(user["LastName"].ToString()));
        cookie.Values.Add("UserId", user["UserId"].ToString());
        cookie.Values.Add("Role", user["Role"].ToString());
        cookie.Values.Add("DepartmentId", user["DepartmentId"].ToString());
        cookie.Values.Add("Sections", user["Sections"].ToString());
        cookie.Values.Add("UserName", user["UserName"].ToString());
        cookie.Expires = DateTime.Now.AddYears(1);
        HttpContext.Current.Response.Cookies.Add(cookie);
    }

    public static void RemoveCookie()
    {
        HttpCookie cookie = HttpContext.Current.Request.Cookies["TEIAdmin1"];
        if (cookie != null)
        {
            cookie.Expires = DateTime.Now.AddDays(-1);
            HttpContext.Current.Response.Cookies.Add(cookie);
        }
    }

    public static string GetFullName()
    {
        string fullname = string.Empty;
        HttpCookie cookie = HttpContext.Current.Request.Cookies["TEIAdmin1"];
        if (cookie != null)
            fullname = HttpContext.Current.Server.UrlDecode(cookie["FirstName"]) + " " + HttpContext.Current.Server.UrlDecode(cookie["LastName"]);

        return fullname;
    }


    public static int GetDepartmentId()
    {
        int DepartmentId = 0;
        HttpCookie cookie = HttpContext.Current.Request.Cookies["TEIAdmin1"];
        if (cookie != null)
            DepartmentId = Convert.ToInt32(cookie["DepartmentId"]);

        return DepartmentId;
    }

    public static string GetUserId()
    {
        string fullname = string.Empty;
        HttpCookie cookie = HttpContext.Current.Request.Cookies["TEIAdmin1"];
        if (cookie != null)
            fullname = HttpContext.Current.Server.UrlDecode(cookie["UserId"]);

        return fullname;
    }
    public static int GetUserRole()
    {
        ArrayList sections = new ArrayList();
        int roleId = 0;
        HttpCookie cookie = HttpContext.Current.Request.Cookies["TEIAdmin1"];
        if (cookie != null)
              roleId = Convert.ToInt32(cookie["Role"]);

        return roleId;
    }


    public static string GetUserName()
    {
        ArrayList sections = new ArrayList();
        string user = "";
        HttpCookie cookie = HttpContext.Current.Request.Cookies["TEIAdmin1"];
        if (cookie != null)
            user = cookie["UserName"].ToString();

        return user;
    }
    public static ArrayList GetUserRoleAndSections()
    {
        ArrayList sections = new ArrayList();

        HttpCookie cookie = HttpContext.Current.Request.Cookies["TEIAdmin1"];
        if (cookie != null)
        {
            string[] arr = (cookie["Role"] + "," + cookie["Sections"]).Split(',');
            foreach (string s in arr)
                sections.Add(s);
        }

        return sections;
    }
}
