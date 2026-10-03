<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="changeDept.aspx.cs"
    Inherits="changeDept" Title="..:: تغيير القسم ::.." %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="advisingPanel" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="0">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" align="right">
                        <tr>
                            <td class="label" style="color: blue">
                                كود الطالب
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtٍStudentCode" runat="server"></asp:TextBox>
                                <asp:HiddenField ID="studentId" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="deptId" runat="server"></asp:HiddenField>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:Panel ID="pnlDefaultButton" runat="server" DefaultButton="btnSearch">
                                    <asp:Button ID="btnSearch" runat="server" Text="بحث" OnClick="btnSearch_Click" CausesValidation="false">
                                    </asp:Button>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                الاسم
                            </td>
                            <td class="label">
                                <asp:Label ID="lblFullName" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                القسم
                            </td>
                            <td class="input">
                                <asp:Label ID="lblDept" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                المستوى
                            </td>
                            <td class="input">
                                <asp:Label ID="lblLevel" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <div style="padding-top: 10px; clear: both;">
                    </div>
                    <br />
                    <br />
                    <br />
                    <br />
                    <asp:PlaceHolder ID="addCoursesHolder" runat="server">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    القسم
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="departmentDDL" runat="server" DataSourceID="departmentDS" DataValueField="DepartmentId"
                                    DataTextField="ArDepartmentName" AppendDataBoundItems="True" Width="200px">
                                    <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="departmentDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.DepartmentsDAL">
                                </asp:ObjectDataSource>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="btnUpdate" runat="server" CssClass="linkbtn" Text="تعديل" OnClick="btnUpdate_Click"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </asp:PlaceHolder>
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
