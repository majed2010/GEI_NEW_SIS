<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="StudentAdvising.aspx.cs" Inherits="StudentAdvising" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(document).bind("contextmenu", function (e) {
            e.preventDefault();
        });
        $(document).keydown(function (e) {
            if (e.which === 123) {
                return false;
            }
        });


    </script>
    <style type="text/css">
        .greenButton {
            background-color: #4CAF50; /* Green */
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
        }
    </style>
    <link href="js/sweetalert.css" rel="stylesheet" />
    <script src="js/sweetalert.min.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="advisingPanel" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="0">
                <asp:View ID="FormView" runat="server">
                                                 <a href="https://futureegypt.org/NewOffering/StudentsAffairs/StudentsoursQuery">الحجب_نظام جديد</a>

                    <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" align="right">
                        <tr>
                            
                            <td class="label" style="color: blue">كود الطالب
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtStudentCode" runat="server"></asp:TextBox>
                                <asp:HiddenField ID="hdnStudentCode" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="studentId" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="departmentIdHdn" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="hdnExpensesId" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="hdnCompltedhours" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="hdnSemesterId" runat="server"></asp:HiddenField>
                            </td>
                        </tr>
                        <tr>
                            <td class="button" colspan="2" align="center">
                                <asp:Button ID="btnSearch" runat="server" Text="بحث" OnClick="btnSearch_Click" CausesValidation="false" />

                            </td>

                        </tr>
                        <tr>
                            <td class="label" style="color: blue">الاسم
                            </td>
                            <td class="label">
                                <asp:Label ID="lblFullName" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">القسم
                            </td>
                            <td class="input">
                                <asp:Label ID="lblDept" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">المستوى
                            </td>
                            <td class="input">
                                <asp:Label ID="lblLevel" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">إجمالي المعدل التراكمي
                            </td>
                            <td class="input">
                                <asp:Label ID="lblGPA" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">الساعات المحققة
                            </td>
                            <td class="input">
                                <asp:Label ID="completedHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">الساعات المسجلة
                            </td>
                            <td class="input">
                                <asp:Label ID="registeredHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">الساعات المتبقية
                            </td>
                            <td class="input">
                                <asp:Label ID="restHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <div style="clear: both;">
                    </div>

                    <%--<h1>
                        درجات الطالب
                    </h1>--%>
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
                                                    <asp:ListItem Text="ناجح" Value="5">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="راسب" Value="6">
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
                                        OnClick="btnGenerateReport2_Click" Visible="true" CausesValidation="false"></asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:LinkButton ID="btnStudentSituationReport3" runat="server" CssClass="linkbtn" Text="( موقف الطالب)أعرض التقرير بدون تكرار"
                                    OnClick="btnStudentSituationReport3_Click" Visible="true" CausesValidation="false"></asp:LinkButton></td>
                        </tr>
                        <%--<tr>
                            <td>
                                <asp:Label ID="civinumbers" runat="server" Text="لتحميل الجدول الدراسي      " Visible="false" Font-Bold="true"></asp:Label>
                                <asp:HyperLink ID="CivilTables" NavigateUrl="http://www.gei.edu.eg/StudentPortal/CivilTable.pdf" runat="server">اضغط هنا</asp:HyperLink>
                                <asp:HyperLink ID="CEETables" NavigateUrl="http://www.gei.edu.eg/StudentPortal/CEETable.pdf" runat="server">اضغط هنا</asp:HyperLink>
                                <asp:HyperLink ID="ArchTables" NavigateUrl="http://www.gei.edu.eg/StudentPortal/ArchTable.pdf" runat="server">اضغط هنا</asp:HyperLink>
                                <asp:Label ID="archnumbers" runat="server" Text="لتحميل الجدول الدراسي      " Visible="false" Font-Bold="true"></asp:Label>
                                <asp:Label ID="ceenumbers" runat="server" Text="لتحميل الجدول الدراسي      " Visible="false" Font-Bold="true"></asp:Label>

                            </td>
                        </tr>--%>
                    </table>
                    <div style="clear: both;">
                    </div>
                    <br />
                    <br />

                    <asp:PlaceHolder ID="addCoursesHolder" runat="server" Visible="false">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">الفصل الدراسي
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="semesters" runat="server" DataValueField="SemesterId"
                                        DataTextField="ArSemesterName" AppendDataBoundItems="True" Width="200px" AutoPostBack="true"
                                        OnSelectedIndexChanged="semesters_SelectedIndexChanged">
                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                    <%-- <asp:ObjectDataSource ID="SemesterDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.SemestersDAL"></asp:ObjectDataSource>--%>
                                    <asp:RequiredFieldValidator ID="semestersRequired" runat="server" ControlToValidate="semesters"
                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                    <asp:HiddenField ID="hdn_yearId" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">المادة
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="courses" runat="server" DataValueField="CourseId" AutoPostBack="true"
                                        DataTextField="ArCourseName" Width="200px" AppendDataBoundItems="True" OnSelectedIndexChanged="courses_SelectedIndexChanged">
                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                    <ajaxToolkit:ListSearchExtender ID="coursesExtender" runat="server" TargetControlID="courses"
                                        PromptCssClass="ListSearchExtenderPrompt" QueryPattern="Contains" QueryTimeout="2000">
                                    </ajaxToolkit:ListSearchExtender>
                                    <asp:RequiredFieldValidator ID="CoursesRequired" runat="server" ControlToValidate="courses"
                                        ErrorMessage="*" InitialValue="0" ForeColor="Red"></asp:RequiredFieldValidator>
                                </td>
                            </tr>

                            <tr>
                                <td class="label" style="color: blue; width: 141px;">المحاضرة
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="ddlDoctor" runat="server"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlDoctor_SelectedIndexChanged">
                                        <%--OnSelectedIndexChanged="ddlDoctor_SelectedIndexChanged"--%>
                                    </asp:DropDownList>

                                    <asp:HiddenField ID="hdnParentId" runat="server" />
                                    <asp:RequiredFieldValidator ID="DoctorsRequired" runat="server" ControlToValidate="ddlDoctor" InitialValue="0"
                                        ErrorMessage="*"></asp:RequiredFieldValidator>

                                </td>
                            </tr>
                        </table>
                        <div style="clear: both;">
                        </div>
                        <br />
                        <br />


                        <asp:Repeater ID="parentmeSegments" runat="server" OnItemCommand="parentmeSegments_ItemCommand"
                            OnItemDataBound="parentmeSegments_OnItemDataBound">
                            <HeaderTemplate>
                                <h1 style="background-color: lightblue; font-weight: bold">المحاضرة
                                </h1>



                            </HeaderTemplate>
                            <ItemTemplate>
                                <div style="text-align: center">
                                    <asp:LinkButton ID="btnAdd" runat="server" CssClass="greenButton" Text='<%# "إضافة "+ DataBinder.Eval(Container, "DataItem.ArCourseName")+" - "+DataBinder.Eval(Container, "DataItem.SectionCode")  %>' CommandName="AddSection"
                                        CommandArgument='<%# DataBinder.Eval(Container, "DataItem.SectionId")%>'></asp:LinkButton>
                                </div>
                                <table cellpadding="2" cellspacing="2" border="0" align="right">
                                    <tr>
                                        <td class="label" style="color: blue;">الميعاد رقم <%# Container.ItemIndex + 1 %>
                                        </td>
                                        <td>
                                            <asp:HiddenField ID="hdnParentIndex" runat="server" Value='<%# Container.ItemIndex %>' />
                                        </td>
                                        <td>
                                            <asp:HiddenField ID="hdnHasChildren" runat="server" Value='<%# DataBinder.Eval(Container, "DataItem.HasChild")%>' />
                                        </td>
                                        <td></td>
                                        <td></td>

                                    </tr>
                                    <tr>
                                        <td></td>
                                    </tr>
                                    <tr style="font-weight: bold">
                                        <td class="label" style="color: blue;">اليوم
                                        </td>
                                        <td class="input">
                                            <%# DataBinder.Eval(Container, "DataItem.DayName")%>
                           
                                        </td>
                                        <td class="label" style="color: blue;">التوقيت
                                        </td>
                                        <td class="input">
                                            <%# DataBinder.Eval(Container, "DataItem.TimeFrom")%> - <%# DataBinder.Eval(Container, "DataItem.TimeTo")%>
                           
                                        </td>
                                        <td class="label" style="color: blue;">المحاضر

                                        </td>
                                        <td class="input">
                                            <%# DataBinder.Eval(Container, "DataItem.EmployeeName")%> 
                           
                                        </td>
                                        <td class="label" style="color: blue;">المكان

                                        </td>
                                        <td class="input">
                                            <%# DataBinder.Eval(Container, "DataItem.RoomFullName")%> 
                           
                                        </td>
                                    </tr>
                                </table>

                            </ItemTemplate>
                            <FooterTemplate>
                            </FooterTemplate>
                        </asp:Repeater>


                    </asp:PlaceHolder>
                    <br />
                    <br />
                    <asp:PlaceHolder ID="sectionPlaceHolder" runat="server" Visible="false">
                        <div style="clear: both;">
                        </div>
                        <h1 style="background-color: lightblue; font-weight: bold">السكاشن
                        </h1>

                        <asp:Repeater ID="childrenTitleRepeater" runat="server" OnItemDataBound="childrenRepeater_OnItemDataBound"
                            OnItemCommand="childrenTitleRepeater_ItemCommand">

                            <HeaderTemplate>
                            </HeaderTemplate>
                            <ItemTemplate>

                                <table cellpadding="2" border="0" align="right">
                                    <tr style="font-size: 18px; font-weight: bold">
                                        <td>
                                            <%# DataBinder.Eval(Container, "DataItem.SectionCode")%>
                                            <asp:HiddenField ID="hdnSectionId" runat="server" Value='<%# DataBinder.Eval(Container, "DataItem.SectionId")%>' />

                                        </td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <asp:Repeater ID="childrenRepeater" runat="server">
                                        <HeaderTemplate>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td class="label" style="color: blue;">الميعاد رقم <%# Container.ItemIndex + 1 %>
                                                </td>
                                            </tr>
                                            <tr style="font-weight: bold">
                                                <td class="label" style="color: blue;">اليوم
                                                </td>
                                                <td class="input">
                                                    <%# DataBinder.Eval(Container, "DataItem.DayName")%>
                           
                                                </td>
                                                <td class="label" style="color: blue;">التوقيت
                                                </td>
                                                <td class="input">
                                                    <%# DataBinder.Eval(Container, "DataItem.TimeFrom")%> - <%# DataBinder.Eval(Container, "DataItem.TimeTo")%>
                           
                                                </td>
                                                <td class="label" style="color: blue;">المحاضر

                                                </td>
                                                <td class="input">
                                                    <%# DataBinder.Eval(Container, "DataItem.EmployeeName")%> 
                           
                                                </td>
                                                <td class="label" style="color: blue;">المكان

                                                </td>
                                                <td class="input">
                                                    <%# DataBinder.Eval(Container, "DataItem.RoomFullName")%> 
                                                </td>
                                            </tr>
                                        </ItemTemplate>

                                    </asp:Repeater>
                                    <td colspan="2" align="center" class="button"></td>
                                </table>
                                <div style="text-align: center">
                                    <asp:LinkButton ID="btnAdd" runat="server" CssClass="greenButton" Text='<%# "إضافة "+DataBinder.Eval(Container, "DataItem.ArCourseName")+" - "+DataBinder.Eval(Container, "DataItem.SectionCode")  %>' CommandName="AddSection"
                                        CommandArgument='<%# DataBinder.Eval(Container, "DataItem.SectionId")%>'></asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>


                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="noChildrenHolder" runat="server" Visible="false">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">

                            <th style="background-color: bisque">لا يوجد سكاشن لهذه المجموعة اختر مجموعة اخرى
                            </th>
                        </table>
                    </asp:PlaceHolder>
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdCourses" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdCourses_RowDeleted" OnSelectedIndexChanged="grdCourses_SelectedIndexChanged"
                                    DataKeyNames="advisingId" OnDataBound="grdCourses_DataBound"
                                    DataSourceID="AdvObjectDataSource" OnRowCommand="grdCourses_RowCommand">
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
                                        <asp:BoundField DataField="SectionCode" HeaderText="السيكشن" SortExpression="SectionCode"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="MemberName" HeaderText="المحاضر" SortExpression="MemberName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="TimeSegment" HeaderText="التوقيت" SortExpression="TimeSegment"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="DayName" HeaderText="اليوم" SortExpression="DayName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="ClassName" HeaderText="القاعة" SortExpression="ClassName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:TemplateField HeaderText="مرات الامتحان" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <asp:Label ID="ExamTimesLbl" runat="server" Text='<%# Eval("ExamTimesCount") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="sectionLbl" runat="server" Value='<%# Eval("SectionId") %>'></asp:HiddenField>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False" CommandArgument='<%# Eval("AdvisingId") %>'
                                                    CommandName="Delete" Visible='<%# Eval("ParentId").ToString() == Eval("SectionId").ToString()%>' OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:ObjectDataSource ID="AdvObjectDataSource" runat="server" DeleteMethod="Delete"
                                    SelectMethod="GetByPage" SelectCountMethod="GetRowsCount" TypeName="TeiLib.StudentsAdvisingDAL"
                                    EnablePaging="true" OnSelected="AdvObjectDataSource_Selected">
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
                                <td style="padding-right: 78px">إجمالي الساعات المعتمدة:
                                    <asp:Label ID="totalCredit" runat="server" Visible="false"></asp:Label>
                                </td>
                                <td align="center">
                                    <asp:Label ID="deleteErr" runat="server" ForeColor="Red" EnableViewState="False"
                                        Visible="False"></asp:Label>
                                </td>
                                <td>إجمالي ساعات الاتصال:
                                    <asp:Label ID="contactHours" runat="server" Visible="false"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <table width="100%" class="form">
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
                        <asp:Label ID="Label2" CssClass="label" runat="server" Width="200px" Text=" عذرًا هذا الطالب محجوب! راجع"
                            Visible="false"></asp:Label>
                        <asp:Label ID="noRegisterlbl" CssClass="label" runat="server" Visible="false"
                            Text=" عذرا لا يمكنك التسجيل لهذا الطالب"></asp:Label>
                        <asp:Label ID="finance" CssClass="label" runat="server" Text=" الإدارة المالية"
                            Visible="false"></asp:Label>
                        <asp:Label ID="affairs" CssClass="label" runat="server" Text=" شئون الطـلاب إدارة التسجيل الخاصة بالقسم"
                            Visible="false"></asp:Label>
                        <asp:Label ID="AdvisingDepart" CssClass="label" runat="server" Width="200px" Text="  إدارة التسجيل الخاصة بالقسم"
                            Visible="false"></asp:Label>
                        <asp:Label ID="Label1" CssClass="label" runat="server" Text="الاستاذ هشام حنفي لعدم سداد المصروفات في الموعيد المقررة"
                            Visible="false"></asp:Label>
                        <asp:Label ID="noAccessLbl" CssClass="label" runat="server" Text=" غير مسموح لك دخول هذه الصفحة"
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
