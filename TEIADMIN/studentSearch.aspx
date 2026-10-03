<%@ Page Language="C#" MasterPageFile="layout.master" AutoEventWireup="true" CodeFile="studentSearch.aspx.cs"
    Inherits="studentSearch" Title=".::  بحث الطلاب ::." %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    الطلاب
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="PagePanel" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
                <asp:View ID="FormView" runat="server">
                </asp:View>
                <asp:View ID="ListView" runat="server">
                    <table cellpadding="2" cellspacing="2" border="0" width="300" class="form">
                        <tr>
                            <td class="label">
                                كود الطالب
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtٍStudentCode" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الاسم الاول
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الاسم الثاني
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtSecondName" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الاسم الثالث
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                العام الدراسي
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="years31" runat="server" DataSourceID="YearDS31" DataValueField="YearId"
                                    DataTextField="YearName" AppendDataBoundItems="True" Width="200px">
                                    <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="YearDS31" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                </asp:ObjectDataSource>
                            </td>
                        </tr>

                        <tr>
                            <td class="label">
                                الفصل الدراسي
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="semesters31" runat="server" DataSourceID="SemesterDS31" DataValueField="SemesterId"
                                    DataTextField="ArSemesterName" AppendDataBoundItems="True" Width="200px">
                                    <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="SemesterDS31" runat="server" SelectMethod="GetAll" TypeName="TeiLib.SemestersDAL">
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الشعبة
                            </td>
                            <td class="input">
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
                                <asp:LinkButton ID="btnSearch" runat="server" CssClass="linkbtn" Text="بحث" OnClick="btnSearch_Click"></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                    <table cellpadding="0" cellspacing="0" border="0" width="610px">
                        <tr>
                            <td colspan="3">
                            </td>
                        </tr>
                        <tr>
                            <%--OnRowCommand="grdStudents_RowCommand"--%>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdStudents" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdStudents_RowDeleted" OnSelectedIndexChanged="grdStudents_SelectedIndexChanged"
                                    DataKeyNames="StudentId" OnDataBound="grdStudents_DataBound" DataSourceID="StudentsDataSource">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد طلاب
                                        </div>
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#"></asp:BoundField>
                                        <asp:TemplateField HeaderText="كود الطالب" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="viewStudent" runat="server" Text='<%# Eval("StudentCode") %>'
                                                    CausesValidation="False" CommandName="ViewData" CommandArgument='<%# Eval("StudentId") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ArFullName" HeaderText="اسم الطالب" SortExpression="ArFullName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="ArDepartmentName" HeaderText="الشعبة" SortExpression="ArDepartmentName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="ArSemesterName" HeaderText="الفصل الدراسي" SortExpression="ArSemesterName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <%-- <asp:ButtonField CommandName="Select" HeaderText="تعديل" Text="تعديل" HeaderStyle-Width="70px"
                                            ItemStyle-Width="50px" />--%>
                                        <%--  <asp:TemplateField HeaderText="طباعة بيانات" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <a href='<%# "StudentInfo.aspx?iframe=true&width=100%&height=100%&StudentId="+Eval("StudentId")%>'
                                                    rel="prettyPhoto[iframes]" title='<%# Eval("ArFullName") %>'>طباعة بيانات</a>
                                            </ItemTemplate>
                                        </asp:TemplateField>--%>
                                        <%--   <asp:TemplateField HeaderText="حذف" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False"
                                                    Visible='<%# CurrentUser.GetUserId() == "1"%>' CommandName="Delete" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>--%>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 7px">
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-right: 78px">
                                <%--<asp:LinkButton CausesValidation="False" CssClass="linkbtn" ID="btnUpdate" runat="server"
                                    ToolTip="Update Hide Values" OnClick="btnUpdate_Click">تحديث</asp:LinkButton>--%>
                            </td>
                            <td align="center">
                                <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                                    Visible="False">خطأ أثناء الحذف.</asp:Label>
                            </td>
                            <td align="left">
                            </td>
                        </tr>
                    </table>
                    <asp:ObjectDataSource ID="StudentsDataSource" runat="server" DeleteMethod="Delete"
                        SelectMethod="GetByPage" SelectCountMethod="GetRowsCount" TypeName="TeiLib.StudentsDAL"
                        EnablePaging="true" OnDeleted="DataSourceDeleted" OnSelecting="StudentsDataSource_Selecting">
                        <SelectParameters>
                            <asp:Parameter Name="StudentCode" Type="String" />
                            <asp:Parameter Name="ArFirstName" Type="String" />
                            <asp:Parameter Name="ArMiddleName" Type="String" />
                            <asp:Parameter Name="ArLastName" Type="String" />
                            <asp:Parameter Name="SemesterId" Type="Int32" />
                              <asp:Parameter Name="YearId" Type="Int32" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:Parameter Name="StudentId" Type="Int32" />
                        </DeleteParameters>
                    </asp:ObjectDataSource>
                </asp:View>
                <asp:View ID="NoAccessView" runat="server">
                    <h2 id="noAccess">
                        غير مسموح لك دخول هذه الصفحة</h2>
                </asp:View>
            </asp:MultiView>
            <asp:ObjectDataSource ID="StudentsDS" runat="server" DataObjectTypeName="TeiLib.Student"
                InsertMethod="Insert" SelectMethod="GetById" UpdateMethod="Update" TypeName="TeiLib.StudentsDAL"
                OnInserted="StudentsDS_Inserted">
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdStudents" Name="studentId" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
                <InsertParameters>
                    <asp:Parameter Direction="Output" Name="StudentId" Type="Int32" />
                </InsertParameters>
            </asp:ObjectDataSource>
            <asp:Label ID="lblStudentId" runat="server" Text="0" Visible="false"></asp:Label>
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
