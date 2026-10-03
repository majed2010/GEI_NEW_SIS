<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="StudentProjectDetails.aspx.cs" Inherits="StudentProjectDetails" Title="..:: اضافة اسم مشروع الطالب ::.."%>

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
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtٍStudentCode"
                                        ErrorMessage="*" InitialValue=""></asp:RequiredFieldValidator>
                                <asp:HiddenField ID="studentId" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="departmentId" runat="server" />
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
                    <div style="clear:both">
                        <asp:PlaceHolder ID="addCoursesHolder" runat="server" Visible="false">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    اسم المشروع
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="DDLProject" runat="server"   Width="200px" AutoPostBack="true"
                                        AppendDataBoundItems="true" DataSourceID="DSProject" DataTextField="ProjectTitleName" DataValueField="ProjectTitleId">
                                         <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>

                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvProject" runat="server" ControlToValidate="DDLProject"
                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                    <asp:ObjectDataSource ID="DSProject" runat="server" SelectMethod="GetByDepId" TypeName="TeiLib.ProjectTitleDAL"  OnSelected="DSProject_Selected">
                                        <SelectParameters>
                                                <asp:ControlParameter ControlID="departmentId" PropertyName="Value" Type="Int32" Name="departmentId" />
                                                
                                            </SelectParameters>
                                    </asp:ObjectDataSource>
                                  
                                </td>
                            </tr>
                            
                             <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    الفصل الدراسي
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="DDLSemesters" runat="server"   Width="200px" AutoPostBack="true" 
                                        AppendDataBoundItems="true" DataSourceID="DSSemester" DataTextField="ArSemesterName" DataValueField="SemesterId">
                                         <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>

                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="DDLSemesters"
                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                    <asp:ObjectDataSource ID="DSSemester" runat="server" SelectMethod="GetAll" TypeName="TeiLib.SemestersDAL">
                                    </asp:ObjectDataSource>
                                
                                </td>
                            </tr>
                                <tr>
                                    <td class="label" style="color: blue; width: 141px;">
                                        المادة
                                    </td>
                                    <td class="input" style="width: 333px">
                                        <asp:DropDownList ID="courses" runat="server" DataSourceID="CoursesDS" DataValueField="CourseId"
                                            DataTextField="ArCourseName" AppendDataBoundItems="True" Width="200px">
                                            <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:ObjectDataSource ID="CoursesDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.StudentsAdvisingDAL"
                                            OnSelected="CoursesDS_Selected">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="studentId" PropertyName="Value" Type="Int32" Name="studentId" />
                                                <asp:ControlParameter ControlID="DDLSemesters" PropertyName="SelectedValue" Type="Int32"
                                                    Name="semesterId" />
                                            </SelectParameters>
                                            <DeleteParameters>
                                                <asp:Parameter Name="advisingId" Type="Int32" />
                                            </DeleteParameters>
                                        </asp:ObjectDataSource>
                                        <asp:RequiredFieldValidator ID="RFVCourse" runat="server" ControlToValidate="courses"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>

                            <tr>
                                <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" Text="إضافة" OnClick="btnAdd_Click"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </asp:PlaceHolder></div>
                    
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                   

                  <%--  <asp:GridView ID="BlockingGridView" runat="server" AllowPaging="True"  Visible="False"
                        AllowSorting="True"  DataSourceID="BlockedDataSource" AutoGenerateColumns="False" 
                        DataKeyNames="StudentProjectId" onrowcommand="BlockingGridView_RowCommand">
                        <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>لا يوجد طلاب محجوبين </EmptyDataTemplate>
                        <Columns>
                        <asp:BoundField  DataField="RowId" HeaderText="#" ItemStyle-Width="20px"/>
                        <asp:TemplateField HeaderText ="الاسم"  ItemStyle-Width="20px" >
                        <ItemTemplate>
                        <asp:Label ID="StudentCodelbl" runat="server" Width="60px" Text='<%# Eval("StudentName") %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText ="اسم المشروع"  ItemStyle-Width="250px" >
                        <ItemTemplate>
                        <asp:Label ID="Blocklbl" runat="server" Width="250px" Text='<%# Eval("ProjectTitle") %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText ="الفصل الدرسي"  ItemStyle-Width="250px" >
                        <ItemTemplate>
                        <asp:Label ID="Blocklbl" runat="server" Width="250px" Text='<%# Eval("SemesterName") %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="تعديل" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="editLink" runat="server" CommandArgument='<%# Eval("StudentProjectId") %>'
                                                    CommandName="rowEdit" CausesValidation="false">تعديل</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="deleteLink" runat="server" CommandArgument='<%# Eval("StudentProjectId") %>'
                                                    CommandName="rowDelete" CausesValidation="false">حذف</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="BlockedDataSource" runat="server" 
                        OldValuesParameterFormatString="original_{0}" SelectMethod="GetByPage"  SelectCountMethod="GetRowsCount" EnablePaging="true"
                        TypeName="TeiLib.StudentProjectDAL" DeleteMethod="Delete" 
                      >
                    
                        <DeleteParameters>
                            <asp:Parameter Name="StudentProjectId" Type="Int32" />
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:Parameter Name="startRowIndex" Type="Int32" />
                            <asp:Parameter Name="maximumRows" Type="Int32" />
                        </SelectParameters>
                    
                    </asp:ObjectDataSource>--%>
                    <br /> 
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