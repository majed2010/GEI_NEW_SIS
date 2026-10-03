<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="Graduate_Student_Statment_ByStudentCode_MidReport.aspx.cs" Inherits="Graduate_Student_Statment_ByStudentCode_MidReport" %>

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
    تقرير نتيجة الطلبة</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <%--    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>--%>
    <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="0">
        <asp:View ID="FormView" runat="server">
            <div style="height: auto; overflow: auto;">
                <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                   
                    <tr>
                        <td class="label" style="color: blue; width: 141px;">
                            كود الطالب
                        </td>
                        <td class="input" style="width: 333px">
                            <asp:TextBox ID="txtStudentCode" runat="server" CssClass="input" ></asp:TextBox>
                            <asp:RequiredFieldValidator ID="departmentsRequired" runat="server" ControlToValidate="txtStudentCode"
                                ErrorMessage="*" ></asp:RequiredFieldValidator>
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
    <%--        </ContentTemplate>
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
    </asp:UpdateProgress>--%>
</asp:Content>
