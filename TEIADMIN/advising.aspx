<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="advising.aspx.cs" Inherits="advising" %>

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
                                <asp:HiddenField ID="departmentIdHdn" runat="server"></asp:HiddenField>
                                 <asp:HiddenField ID="hdnExpensesId" runat="server"></asp:HiddenField>
                                  <asp:HiddenField ID="hdnCompltedhours" runat="server"></asp:HiddenField>
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
                        <tr>
                            <td class="label" style="color: blue">
                                إجمالي المعدل التراكمي
                            </td>
                            <td class="input">
                                <asp:Label ID="lblGPA" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                الساعات المحققة
                            </td>
                            <td class="input">
                                <asp:Label ID="completedHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                الساعات المسجلة
                            </td>
                            <td class="input">
                                <asp:Label ID="registeredHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                الساعات المتبقية
                            </td>
                            <td class="input">
                                <asp:Label ID="restHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <div style="clear: both;">
                    </div>
                    <br />
                    <br />
                    <h1>
                        درجات الطالب
                    </h1>
                    <table cellpadding="0" cellspacing="0" border="0" width="500px">
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="GridView1" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowSorting="True"
                                    DataKeyNames="advisingId" DataSourceID="Adv1ObjectDataSource">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد درجات لهذا الطالب
                                        </div>
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="PagerStyle" />
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#" ItemStyle-Width="70px"></asp:BoundField>
                                        <asp:TemplateField HeaderText="المادة" ItemStyle-Width="150px">
                                            <ItemTemplate>
                                                <asp:Label ID="courseLbl" runat="server" Width="60px" Text='<%# Eval("ArCourseName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="الترم" ItemStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:Label ID="semesterName" runat="server" Text='<%# Eval("ArSemesterName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="advisingId" Visible="false" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:Label ID="advisingIdLbl" runat="server" Width="60px" Visible="false" Text='<%# Eval("AdvisingId") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                       
                                        <asp:TemplateField HeaderText="التقدير" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <asp:Label ID="gradeLbl" runat="server" Text='<%# Eval("Grade") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="النقاط" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <asp:Label ID="pointsLbl" runat="server" Text='<%# Eval("TotalPoints") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حالة الطالب" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <asp:DropDownList ID="attendDDL" runat="server" Width="80px" SelectedValue='<%# Eval("ExamAttendance") %>'
                                                    Enabled="false">
                                                    <asp:ListItem Text="اختر" Value="0">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="حضر" Value="1" Selected="True">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="غياب" Value="2">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="عذر" Value="3">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="اخلال" Value="4">
                                                    </asp:ListItem>
                                                </asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:ObjectDataSource ID="Adv1ObjectDataSource" runat="server" SelectMethod="GetByStudent"
                                    TypeName="TeiLib.StudentsAdvisingDAL" OnSelected="Adv1ObjectDataSource_Selected">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="studentId" Type="Int32" DefaultValue="0" ControlID="studentId" />
                                        <asp:Parameter Name="recordsCount" Type="Int32" Direction="Output" />
                                        <asp:Parameter Name="GPA" Type="Decimal" Direction="Output" />
                                        <asp:Parameter Name="LevelName" Type="String" Direction="Output" />
                                        <asp:Parameter Name="completedHours" Type="Int32" Direction="Output" />
                                        <asp:Parameter Name="registeredHours" Type="Int32" Direction="Output" />
                                        <asp:Parameter Name="restHours" Type="Int32" Direction="Output" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <br />
                                <div style="align: center">
                                    <asp:LinkButton ID="btnGenerateReport2" runat="server" CssClass="linkbtn" Text="(موقف الطالب)أعرض التقرير"
                                        OnClick="btnGenerateReport2_Click" CausesValidation="false"></asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                        <tr><td><asp:LinkButton ID="btnStudentSituationReport3" runat="server" CssClass="linkbtn" Text="( موقف الطالب)أعرض التقرير بدون تكرار" 
                                        OnClick="btnStudentSituationReport3_Click" CausesValidation="false"></asp:LinkButton></td></tr>
                    </table>
                    <div style="clear: both;">
                    </div>
                    <br />
                    <br />
                    <br />
                    <br />
                    <asp:PlaceHolder ID="addCoursesHolder" runat="server" Visible="false">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    الفصل الدراسي
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="semesters" runat="server" DataSourceID="SemesterDS" DataValueField="SemesterId"
                                        DataTextField="ArSemesterName" AppendDataBoundItems="True" Width="200px" AutoPostBack="true" 
                                         onselectedindexchanged="semesters_SelectedIndexChanged">
                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="SemesterDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.SemestersDAL">
                                    </asp:ObjectDataSource>
                                    <asp:RequiredFieldValidator ID="semestersRequired" runat="server" ControlToValidate="semesters"
                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                    <asp:HiddenField ID="hdn_yearId" runat="server" />
                                </td>
                            </tr>
                           
                           <tr>
                           <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="ADDAdvisingByBlock" runat="server" Visible="false" CssClass="linkbtn" Text="اضافة مواد اعدادي الفصل الثاني" OnClick="ADDAdvisingByBlock_Click"></asp:LinkButton>
                                </td>
                           </tr>
                           <%--<tr>
                           <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="AddCivilBlock" runat="server" Visible="false" CssClass="linkbtn" Text="اضافة مواد مدني المستوى الثاني" OnClick="AddCivilBlock_Click"></asp:LinkButton>
                                </td>
                           </tr>
                               <tr>
                           <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="AddCivil4Level" runat="server" Visible="false" CssClass="linkbtn" Text="اضافة مواد مدني المستوى الرابع " OnClick="AddCivil4Level_Click"></asp:LinkButton>
                                </td>
                           </tr>--%>
                           
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    المادة
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="courses" runat="server" DataSourceID="CoursesDS" DataValueField="CourseId" AutoPostBack="true"
                                        DataTextField="ArCourseName" AppendDataBoundItems="True" Width="200px" OnSelectedIndexChanged="courses_SelectedIndexChanged">
                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                    <ajaxToolkit:ListSearchExtender ID="coursesExtender" runat="server" TargetControlID="courses"
                                        PromptCssClass="ListSearchExtenderPrompt" QueryPattern="Contains" QueryTimeout="2000">
                                    </ajaxToolkit:ListSearchExtender>
                                    <asp:ObjectDataSource ID="CoursesDS" runat="server" SelectMethod="GetByDepartment"
                                        TypeName="TeiLib.CoursesDAL">
                                        <SelectParameters>
                                            <asp:ControlParameter Name="DepartmentId" DbType="Int32" ControlID="departmentIdHdn"
                                                PropertyName="Value" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    <asp:RequiredFieldValidator ID="CoursesRequired" runat="server" ControlToValidate="courses"
                                ErrorMessage="*" InitialValue="0" ForeColor="Red"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                             <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    اسم المحاضر
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="ddlDoctor" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="ddlDoctor_SelectedIndexChanged"><%--OnSelectedIndexChanged="ddlDoctor_SelectedIndexChanged"--%>
                                       
                                    </asp:DropDownList>
                                    <%--<asp:HiddenField ID="hdnDoctorCoursesId" runat="server" />--%>
                                    
                                    <asp:RequiredFieldValidator ID="DoctorsRequired" runat="server" ControlToValidate="ddlDoctor" InitialValue="0"
                                ErrorMessage="*" ></asp:RequiredFieldValidator>

                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" Text="إضافة" OnClick="btnAdd_Click"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </asp:PlaceHolder>
                    <table cellpadding="0" cellspacing="0" border="0" width="610px">
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdCourses" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdCourses_RowDeleted" OnSelectedIndexChanged="grdCourses_SelectedIndexChanged"
                                    DataKeyNames="advisingId" OnDataBound="grdCourses_DataBound" DataSourceID="AdvObjectDataSource" onrowcommand="grdCourses_RowCommand">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#"></asp:BoundField>
                                        <asp:BoundField DataField="ArCourseCode" HeaderText="كود المادة" SortExpression="ArCourseCode"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="ArCourseName" HeaderText="اسم المادة" SortExpression="ArCourseName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="CreditHours" HeaderText="الساعات المعتمدة" SortExpression="CreditHours"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="ArPreCourseName" HeaderText="المتطلب السابق" SortExpression="ArPreCourseName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:TemplateField HeaderText="مرات الامتحان" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <asp:Label ID="ExamTimesLbl" runat="server" Text='<%# Eval("ExamTimesCount") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False" CommandArgument='<%# Eval("AdvisingId") %>'
                                                   Visible='<%# CurrentUser.GetUserId() == "1" || CurrentUser.GetUserId() == "9" || CurrentUser.GetUserId() == "118" || CurrentUser.GetUserId() == "32" || CurrentUser.GetUserId() == "90" || CurrentUser.GetUserId() == "105" || CurrentUser.GetUserId() == "119" || CurrentUser.GetUserId() == "121" || CurrentUser.GetUserId() == "112" || CurrentUser.GetUserId() == "75" || CurrentUser.GetUserId() == "109"%>' CommandName="Delete" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:ObjectDataSource ID="AdvObjectDataSource" runat="server" DeleteMethod="Delete"
                                    SelectMethod="GetByPage" SelectCountMethod="GetRowsCount" TypeName="TeiLib.StudentsAdvisingDAL"
                                    EnablePaging="true" OnDeleted="DataSourceDeleted" OnSelected="AdvObjectDataSource_Selected">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="studentId" PropertyName="Value" Type="Int32" Name="studentId" />
                                        <asp:ControlParameter ControlID="semesters" PropertyName="SelectedValue" Type="Int32"
                                            Name="semesterId" />
                                        <asp:Parameter Name="TotalCredit" Type="Int32" Direction="Output" />
                                        <asp:Parameter Name="TotalContact" Type="Int32" Direction="Output" />
                                    </SelectParameters>
                                    <DeleteParameters>
                                        <asp:Parameter Name="advisingId" Type="Int32" />
                                          <asp:Parameter Name="UserName" Type="String" />
                                    </DeleteParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                    </table>
                    <asp:PlaceHolder ID="errorsHolder" runat="server" Visible="false">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td style="padding-right: 78px">
                                    إجمالي الساعات المعتمدة:
                                    <asp:Label ID="totalCredit" runat="server" Visible="false"></asp:Label>
                                </td>
                                <td align="center">
                                    <asp:Label ID="deleteErr" runat="server" ForeColor="Red" EnableViewState="False"
                                        Visible="False">خطأ أثناء الحذف.</asp:Label>
                                </td>
                                <td>
                                    إجمالي ساعات الاتصال:
                                    <asp:Label ID="contactHours" runat="server" Visible="false"></asp:Label>
                                </td>
                            </tr>
                        </table>
                          <table  width="100%" class="form">
                        <tr>
                        <td>
                         <asp:LinkButton ID="btnGenerateReport" runat="server" CssClass="linkbtn" Text="طباعةتقريرالتسجيل" Font-Bold="true" Font-Size="Medium"
                                OnClick="btnGenerateReport_Click" CausesValidation="false"></asp:LinkButton>
                        </td>
                        </tr>
                        <tr>
                        <td>
                        <asp:LinkButton ID="btnStudentPayment" runat="server" CssClass="linkbtn" Text="طباعةأذن الدفع بالبنك" Font-Bold="true" Font-Size="Medium"
                                OnClick="btnStudentPayment_Click" CausesValidation="false"></asp:LinkButton>
                        </td>
                        </tr>
                        <tr>
                        <td>
                         <asp:LinkButton ID="LinkButton1" runat="server" CssClass="linkbtn" Visible="true" Text="Expected GPA" Font-Bold="true" Font-Size="Medium"
                                OnClick="btnStudentExpectedGPAReport4_Click" CausesValidation="false"></asp:LinkButton>
                        </td>
                        </tr>
                        <tr>
                        <td></td>
                        </tr>
                        <tr>
                        
                        <td>
                        <asp:Label ID="lblads" runat="server" Text="ملحوظة هامة : الدفع بالبنك فقط" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                        </td>
                        </tr>
                        </table>
                    </asp:PlaceHolder>
                </asp:View>
                <asp:View ID="NoAccessView" runat="server">
                    <h2>
                        <asp:Label ID="Label2" CssClass="accordion-header" runat="server" Text=" عذرًا هذا الطالب محجوب! راجع"
                            Visible="false"></asp:Label>
                        <asp:Label ID="noRegisterlbl" CssClass="accordion-header" runat="server" Visible="false"
                            Text=" عذرا لا يمكنك التسجيل لهذا الطالب"></asp:Label>
                        <asp:Label ID="finance" CssClass="accordion-header" runat="server" Text=" الإدارة المالية"
                            Visible="false"></asp:Label>
                        <asp:Label ID="affairs" CssClass="accordion-header" runat="server" Text=" شئون الطـلاب إدارة التسجيل الخاصة بالقسم"
                            Visible="false"></asp:Label>
                        <asp:Label ID="AdvisingDepart" CssClass="accordion-header" runat="server" Text="  إدارة التسجيل الخاصة بالقسم"
                            Visible="false"></asp:Label>
                        <asp:Label ID="noAccessLbl" CssClass="accordion-header" runat="server" Text=" غير مسموح لك دخول هذه الصفحة"
                            Visible="false"></asp:Label>
                        <asp:LinkButton ID="returnBTN" runat="server" CssClass="linkbtn" Text="عودة" OnClick="returnBTN_Click"
                            Visible="false"></asp:LinkButton>
                    </h2>
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
