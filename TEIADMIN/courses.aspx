<%@ Page Title=".:: المواد ::." Language="C#" MasterPageFile="~/layout.master"
    AutoEventWireup="true" CodeFile="courses.aspx.cs" Inherits="levels" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    المواد
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <%--<asp:UpdatePanel ID="PagePanel" runat="server">
        <ContentTemplate>--%>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="540px">
                        <tr>
                            <td>
                                <asp:FormView ID="CoursesForm" runat="server" OnItemInserted="CoursesForm_ItemInserted"
                                    DataSourceID="FormDataSource" OnItemUpdated="CoursesForm_ItemUpdated" DataKeyNames="CourseId"
                                    Width="100%" OnModeChanging="CoursesForm_ModeChanging">
                                    <EditItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="2">
                                                    <h4>
                                                        تعديل المواد
                                                    </h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم المادة بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArActName" runat="server" Columns="25" Text='<%# Bind("ArCourseName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ErrorMessage="*" ControlToValidate="txtArActName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم المادة بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtSize" runat="server" Columns="25" Text='<%# Bind("CourseName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="txtSizeRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtSize" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    كود المادة بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtCreditHoursFrom" runat="server" Columns="25" Text='<%# Bind("CourseCode") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtCreditHoursFrom" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    كود المادة بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtCreditHoursTo" runat="server" Columns="25" Text='<%# Bind("ArCourseCode") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtCreditHoursTo" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    الساعات المعتمدة
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="creditHours" runat="server" Columns="25" Text='<%# Bind("CreditHours") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                        ControlToValidate="creditHours" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    ساعات الاتصال
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="contactHours" runat="server" Columns="25" Text='<%# Bind("ContactHours") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*"
                                                        ControlToValidate="contactHours" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    درجة أعمال السنة
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="performanceTotal" runat="server" Columns="25" Text='<%# Bind("YearPerformancelTotal") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                                        ControlToValidate="performanceTotal" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    درجة العملي
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="labTotal" runat="server" Columns="25" Text='<%# Bind("LabTotal") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*"
                                                        ControlToValidate="labTotal" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    درجة الامتحان التحريري
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="finalExam" runat="server" Columns="25" Text='<%# Bind("FinalExamTotal") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="*"
                                                        ControlToValidate="finalExam" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" valign="top">
                                                    المستوى
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="levels" runat="server" DataSourceID="LevelsDS"
                                                        DataValueField="LevelId" DataTextField="ArLevelName" AppendDataBoundItems="True"
                                                        Width="200px" SelectedValue='<%# Bind("LevelId") %>'>
                                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource ID="LevelsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LevelsDAL">
                                                    </asp:ObjectDataSource>
                                                    <asp:RequiredFieldValidator ID="departments1Required" runat="server" ControlToValidate="levels"
                                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" valign="top">
                                                    المتطلب السابق
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="prerequesite" runat="server" DataSourceID="CourseDS"
                                                        DataValueField="CourseId" DataTextField="ArCourseName" AppendDataBoundItems="True"
                                                        Width="200px" SelectedValue='<%# Bind("PreCourseId") %>'>
                                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource ID="CourseDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.CoursesDAL">
                                                    </asp:ObjectDataSource>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="prerequesite"
                                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                             <tr>
                                                <td class="label">
                                                    عدد الساعات (متطلب سابق)
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtPreEHRS" runat="server" Columns="25" Text='<%# Bind("PreEHRS") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtPreEHRS" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                             <tr>
                                                <td class="label">
                                                   نوع المادة
                                                </td>
                                                <td>
                                                    <asp:RadioButtonList ID="radCourseType" runat="server" 
                                                        SelectedValue='<%# Bind("CourseType") %>' style="text-align: right">
                                                    <asp:ListItem Text="اجباري" Value="True"></asp:ListItem>
                                                    <asp:ListItem Text="اختياري" Value="False"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="تعديل" CommandName="Update"
                                                        ValidationGroup="grp1" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        Text="إلغاء" CommandName="Cancel" />
                                                </td>
                                            </tr>
                                        </table>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="2">
                                                    <h4>
                                                        إضافة مادة جديد</h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم المادة بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArActName" runat="server" Columns="25" Text='<%# Bind("ArCourseName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ErrorMessage="*" ControlToValidate="txtArActName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم المادة بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtSize" runat="server" Columns="25" Text='<%# Bind("CourseName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="txtSizeRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtSize" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    كود المادة بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtCreditHoursFrom" runat="server" Columns="25" Text='<%# Bind("CourseCode") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtCreditHoursFrom" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    كود المادة بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtCreditHoursTo" runat="server" Columns="25" Text='<%# Bind("ArCourseCode") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtCreditHoursTo" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                           <tr>
                                                <td class="label">
                                                    الساعات المعتمدة
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="creditHours" runat="server" Columns="25" Text='<%# Bind("CreditHours") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                        ControlToValidate="creditHours" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    ساعات الاتصال
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="contactHours" runat="server" Columns="25" Text='<%# Bind("ContactHours") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*"
                                                        ControlToValidate="contactHours" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    درجة أعمال السنة
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="performanceTotal" runat="server" Columns="25" Text='<%# Bind("YearPerformancelTotal") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*"
                                                        ControlToValidate="performanceTotal" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    درجة العملي
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="labTotal" runat="server" Columns="25" Text='<%# Bind("LabTotal") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="*"
                                                        ControlToValidate="labTotal" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    درجة الامتحان التحريري
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="finalExam" runat="server" Columns="25" Text='<%# Bind("FinalExamTotal") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="*"
                                                        ControlToValidate="finalExam" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" valign="top">
                                                    المستوى
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="levels" runat="server" DataSourceID="LevelsDS"
                                                        DataValueField="LevelId" DataTextField="ArLevelName" AppendDataBoundItems="True"
                                                        Width="200px" SelectedValue='<%# Bind("LevelId") %>'>
                                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource ID="LevelsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LevelsDAL">
                                                    </asp:ObjectDataSource>
                                                    <asp:RequiredFieldValidator ID="departments1Required" runat="server" ControlToValidate="levels"
                                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" valign="top">
                                                    المتطلب السابق
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="prerequesite" runat="server" DataSourceID="CourseDS"
                                                        DataValueField="CourseId" DataTextField="ArCourseName" AppendDataBoundItems="True"
                                                        Width="200px" SelectedValue='<%# Bind("PreCourseId") %>'>
                                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource ID="CourseDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.CoursesDAL">
                                                    </asp:ObjectDataSource>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="prerequesite"
                                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                             <tr>
                                                <td class="label">
                                                    عدد الساعات (متطلب سابق)
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtPreEHRS" runat="server" Columns="25" Text='<%# Bind("PreEHRS") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtPreEHRS" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                             <tr>
                                                <td class="label">
                                                   نوع المادة
                                                </td>
                                                <td >
                                                    <asp:RadioButtonList ID="radCourseType" runat="server" 
                                                        SelectedValue='<%# Bind("CourseType") %>' style="text-align: right" 
                                                        Width="107px">
                                                    <asp:ListItem Text="اجباري" Value="True" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Text="اختياري" Value="False"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="إضافة" CommandName="Insert"
                                                        ValidationGroup="grp1" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        Text="إلغاء" CommandName="Cancel" />
                                                </td>
                                            </tr>
                                        </table>
                                    </InsertItemTemplate>
                                </asp:FormView>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 5px">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:Label ID="submitErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">خطأ أثناء الإضافة.</asp:Label>
                                            <asp:Label ID="TitleErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">This Title already exists.</asp:Label>
                                            <asp:Label ID="updateErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">خطأ أثناء التعديل</asp:Label>
                                        </td>
                                        <td align="right">
                                            <asp:LinkButton ID="lnkBack2" runat="server" CausesValidation="false" OnClick="lnkBack_Click">رجوع</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </asp:View>
                <asp:View ID="ListView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="610px">
                        <tr>
                            <td colspan="3">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" Style="direction: ltr;
                                                padding-bottom: 20px" OnClick="btnAdd_Click">أضف مادة جديدة</asp:LinkButton><%----%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdCourses" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdCourses_RowDeleted" OnSelectedIndexChanged="grdCourses_SelectedIndexChanged"
                                    DataKeyNames="CourseId" OnDataBound="grdCourses_DataBound" DataSourceID="CourseObjectDataSource">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد مواد مضافة</div>
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#"></asp:BoundField>
                                        <asp:TemplateField HeaderText="اخفاء" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="CkHide" runat="server" Checked='<%# Eval("Hide") %>' />
                                                <asp:CheckBox ID="CKOld" runat="server" Checked='<%# Eval("Hide") %>' Visible="False" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ArCourseName" HeaderText="اسم المادة" SortExpression="ArCourseName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="ArCourseCode" HeaderText="القسم" SortExpression="ArCourseCode"
                                            HeaderStyle-HorizontalAlign="Right" />
                                             <asp:BoundField DataField="ArPreCourseName" HeaderText="المتطلب السابق" SortExpression="ArPreCourseName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:ButtonField CommandName="Select" HeaderText="تعديل" Text="تعديل" HeaderStyle-Width="70px"
                                            ItemStyle-Width="50px" />
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False"
                                                    CommandName="Delete" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
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
                                <asp:LinkButton CausesValidation="False" CssClass="linkbtn" ID="btnUpdate" runat="server"
                                    ToolTip="Update Hide Values" OnClick="btnUpdate_Click">تحديث</asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                                    Visible="False">خطأ أثناء الحذف.</asp:Label>
                            </td>
                            <td align="left">
                                <asp:LinkButton ID="btnAdd1" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click">أضف مادة جديدة</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                    <asp:ObjectDataSource ID="FormDataSource" runat="server" DataObjectTypeName="TeiLib.Course"
                        InsertMethod="Insert" SelectMethod="GetById" TypeName="TeiLib.CoursesDAL" UpdateMethod="Update">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="grdCourses" Name="CourseId" PropertyName="SelectedValue"
                                Type="Int32" />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Course" Type="Object" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                    <asp:ObjectDataSource ID="CourseObjectDataSource" runat="server" DeleteMethod="Delete"
                        SelectMethod="GetByPage" SelectCountMethod="GetRowsCount" TypeName="TeiLib.CoursesDAL"
                        EnablePaging="true" OnDeleted="DataSourceDeleted">
                        <DeleteParameters>
                            <asp:Parameter Name="CourseId" Type="Int32" />
                        </DeleteParameters>
                    </asp:ObjectDataSource>
                </asp:View>
                  <asp:View ID="NoAccessView" runat="server">
                    <h2 id="noAccess">
                        غير مسموح لك دخول هذه الصفحة</h2>
                </asp:View>
            </asp:MultiView>
      <%--  </ContentTemplate>
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
