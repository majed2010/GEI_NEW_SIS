<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="execuses.aspx.cs"
    Inherits="execuses" Title="..:: تعيين حالة الطالب ::.." %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="advisingPanel" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="stateId" runat="server" />
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
                    <div style="clear: both;">
                    </div>
                    <h1>
                        الحالات المسجلة
                    </h1>
                    <table cellpadding="0" cellspacing="0" border="0" width="500px">
                        <tr>
                            <td style="padding-top: 15px">
                                <asp:GridView ID="ExecusesGrid" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowSorting="True"
                                    DataKeyNames="Id" DataSourceID="ExecObjectDataSource" OnRowCommand="ExecusesGrid_RowCommand">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد حالات مسجلة لهذا الطالب
                                        </div>
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="PagerStyle" />
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#" ItemStyle-Width="70px"></asp:BoundField>
                                        <asp:TemplateField HeaderText="الحالة" ItemStyle-Width="150px">
                                            <ItemTemplate>
                                                <asp:Label ID="stateLbl" runat="server" Width="60px" Text='<%# Eval("StateName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="النص" ItemStyle-Width="150px">
                                            <ItemTemplate>
                                                <asp:Label ID="stateStatementLbl" runat="server" Width="60px" Text='<%# Eval("StateStatement") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="الترم" ItemStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:Label ID="semesterName" runat="server" Text='<%# Eval("SemesterName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="السنة" ItemStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:Label ID="yearName" runat="server" Text='<%# Eval("ArYearName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="المادة" ItemStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:Label ID="CoursName" runat="server" Text='<%# Eval("Course") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="advisingId" Visible="false" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:Label ID="IdLbl" runat="server" Width="60px" Visible="false" Text='<%# Eval("Id") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="تعديل" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="editLink" runat="server" CommandArgument='<%# Eval("Id") %>'
                                                    CommandName="rowEdit" CausesValidation="false">تعديل</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="deleteLink" runat="server" CommandArgument='<%# Eval("Id") %>'
                                                    CommandName="rowDelete" CausesValidation="false">حذف</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:ObjectDataSource ID="ExecObjectDataSource" runat="server" SelectMethod="GetExecusesOfStudent"
                                    TypeName="TeiLib.Execuses_WithdrawDAL">
                                    <SelectParameters>
                                        <asp:ControlParameter Name="studentId" Type="Int32" DefaultValue="0" ControlID="studentId" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                    </table>
                    <div style="padding-top: 10px; clear: both;">
                    </div>
                    <br />
                    <asp:PlaceHolder ID="addCoursesHolder" runat="server">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    الحالة
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="stateDDL" runat="server" DataSourceID="StateDS" DataValueField="StateId"
                                        DataTextField="StateName" AppendDataBoundItems="True" Width="200px" AutoPostBack="true"
                                        OnSelectedIndexChanged="stateDDL_SelectedIndexChanged">
                                        <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="StateDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.StatesDAL">
                                    </asp:ObjectDataSource>
                                    <asp:RequiredFieldValidator ID="stateDDLRequired" runat="server" ControlToValidate="stateDDL"
                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <asp:PlaceHolder ID="statmentHolder" runat="server" Visible="false">
                                <tr>
                                    <td class="label" style="color: blue">
                                        نص الايقاف / الاعتذار
                                    </td>
                                    <td class="input">
                                        <asp:TextBox ID="txtStatment" runat="server" TextMode="MultiLine"></asp:TextBox>
                                    </td>
                                </tr>
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="semesterHolder" runat="server" Visible="false">
                                <tr>
                                    <td class="label" style="color: blue; width: 141px;">
                                        الفصل الدراسي
                                    </td>
                                    <td class="input" style="width: 333px">
                                        <asp:DropDownList ID="semesters" runat="server" DataSourceID="SemesterDS" DataValueField="SemesterId"
                                            DataTextField="ArSemesterName" AppendDataBoundItems="True" Width="200px" AutoPostBack="true">
                                            <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:ObjectDataSource ID="SemesterDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.SemestersDAL">
                                        </asp:ObjectDataSource>
                                        <%--<asp:RequiredFieldValidator ID="semestersRequired" runat="server" ControlToValidate="semesters"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>--%>
                                    </td>
                                </tr>
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="courseHolder" runat="server" Visible="false">
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
                                                <asp:ControlParameter ControlID="semesters" PropertyName="SelectedValue" Type="Int32"
                                                    Name="semesterId" />
                                            </SelectParameters>
                                            <DeleteParameters>
                                                <asp:Parameter Name="advisingId" Type="Int32" />
                                            </DeleteParameters>
                                        </asp:ObjectDataSource>
                                        <%--<asp:RequiredFieldValidator ID="departmentsRequired" runat="server" ControlToValidate="departments"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>--%>
                                    </td>
                                </tr>
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="yearHolder" runat="server" Visible="false">
                                <tr>
                                    <td class="label">
                                        السنة الدراسية
                                    </td>
                                    <td class="input">
                                        <asp:DropDownList ID="ddlYear" runat="server" AppendDataBoundItems="true" DataTextField="YearName"
                                            DataValueField="YearId" DataSourceID="YearsDS">
                                            <asp:ListItem Value="0">--- Select ---</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:ObjectDataSource ID="YearsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                        </asp:ObjectDataSource>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                            ControlToValidate="ddlYear" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </asp:PlaceHolder>
                            <tr>
                                <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" Text="إضافة" OnClick="btnAdd_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="btnUpdate" runat="server" CssClass="linkbtn" Text="تعديل" Visible="false" OnClick="btnUpdate_Click"></asp:LinkButton>
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
