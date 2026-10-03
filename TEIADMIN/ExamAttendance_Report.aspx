<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="ExamAttendance_Report.aspx.cs" Inherits="ExamAttendance_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" Runat="Server">
  <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
    <asp:View ID="PageView" runat="server">
   <%-- <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>--%>
            <table class="form" width="100%">
            <tr>
            <td>
            اختر المستوى
            </td>
            <td>
            <asp:DropDownList ID="drp_level" runat="server" Height="26px" Width="236px" 
                        AutoPostBack="True" 
                        onselectedindexchanged="drp_level_SelectedIndexChanged" AppendDataBoundItems="true"
                        DataSourceID="ObjectDataSource1" DataTextField="ArLevelName" 
                        DataValueField="LevelId">
                        <asp:ListItem Selected="True" Enabled="true" Value="0" Text="---اختر المستوى---"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
                        OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" 
                        TypeName="TeiLib.LevelsDAL"></asp:ObjectDataSource>
            </td>
            </tr>
              <tr>
            <td>
            اختر المادة
            </td>
            <td>
            <asp:DropDownList ID="ddlcourses" runat="server" AutoPostBack="true" Height="26px" Width="236px" OnSelectedIndexChanged="ddlcourses_SelectedIndexChanged" 
                        >
                    </asp:DropDownList>
            </td>
            </tr>
                <tr>
            <td>
            اختر الدكتور
            </td>
            <td>
            <asp:DropDownList ID="DDlMemebers" runat="server" Height="26px" Width="236px" 
                        >
                    </asp:DropDownList>
            </td>
            </tr>
            <tr>
            <td colspan="2" align="center">
            <asp:Button ID="Button1" runat="server" Text="اظهار التقرير " OnClick="Button1_Click"
                        CssClass="button" Font-Bold="True" Font-Size="Medium" />
            </td>
            </tr>
            </table>
            
        </ContentTemplate>
    </asp:UpdatePanel>
    </asp:View>
    <asp:View ID="NoAccessView" runat="server">
        <asp:Label ID="Label4" runat="server" Text="غير مصرح لك بدخول الصفحة " 
            Font-Size="Larger" ForeColor="Red"></asp:Label>
    </asp:View>
    </asp:MultiView>
    <asp:UpdateProgress ID="LoadingProgress" runat="server">
        <ProgressTemplate>
            <div id="progressFilter">
            </div>
            <div id="progressMessage">
                تحميل البيانات... &nbsp;
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

</asp:Content>

