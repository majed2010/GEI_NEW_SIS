<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="gradingReportFilledPerformanceOld.aspx.cs" Inherits="gradingReportFilledPerformanceOld" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript">
function fnClientFunction(source, arguments)
{
  if (arguments.Value>0 || arguments.Value==<41) 
    arguments.IsValid=true; 
  else 
    arguments.IsValid=false;
}




//   function verify_text(control,name,maxValue) {
//   alert('hello');
////      if (control.value < 0) {
////       alert('the '+name+' must be more than '+minValue);
////      }
////      else if(control.value > maxValue) {
////       alert('the '+name+' must be less than '+maxValue);
////      }
//   }

    </script>

</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    تقرير درجات أعمال السنة لمادة
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="0">
                <asp:View ID="FormView" runat="server">
                    <h2>
                        تقرير الطلبة المسجلين في مادة</h2>
                    <div style="height: auto; overflow: auto;">
                      <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    الفصل الدراسي
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="semesters" runat="server" DataSourceID="SemesterDS" DataValueField="SemesterId"
                                        DataTextField="ArSemesterName" AppendDataBoundItems="True" Width="200px">
                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="SemesterDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.SemestersDAL">
                                    </asp:ObjectDataSource>
                                    <%--<asp:RequiredFieldValidator ID="semestersRequired" runat="server" ControlToValidate="semesters"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>AutoPostBack="true"--%>
                                </td>
                            </tr>
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    القسم
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="depts" runat="server" DataSourceID="deptsDS" DataValueField="DepartmentId"
                                        DataTextField="ArDepartmentName" AppendDataBoundItems="True" Width="200px" AutoPostBack="true"
                                        OnSelectedIndexChanged="depts_SelectedIndexChanged">
                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="deptsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.DepartmentsDAL">
                                    </asp:ObjectDataSource>
                                    <%--<asp:RequiredFieldValidator ID="departmentsRequired" runat="server" ControlToValidate="departments"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>--%>
                                </td>
                            </tr>
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    المادة
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="courses" runat="server" Width="200px" OnSelectedIndexChanged="courses_SelectedIndexChanged" AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                             
                               <tr>
                                <td class="label" style="color: blue; width: 141px;">المحاضرة
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="ddlDoctor" runat="server"
                                        AutoPostBack="true" >
                                        <%--OnSelectedIndexChanged="ddlDoctor_SelectedIndexChanged"--%>
                                    </asp:DropDownList>

                                    

                                </td>
                            </tr>
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:Button ID="btnGenerate" runat="server" OnClick="btnGenerate_Click" Text="التقرير" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div style="clear: both; padding-top: 20px">
                    </div>
                </asp:View>
                <asp:View ID="NoAccessView" runat="server">
                    <h2 id="noAccess">
                        غير مسموح لك دخول هذه الصفحة</h2>
                </asp:View>
            </asp:MultiView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="LoadingProgress" runat="server">
        <ProgressTemplate>
            <div id="progressFilter">
            </div>
            <div id="progressMessage">
                Processing... &nbsp;
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
