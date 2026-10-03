<%@ Page Language="C#" MasterPageFile="layout.master" AutoEventWireup="true" CodeFile="semesters.aspx.cs"
    Inherits="semesters" Title=".:: الفصول الدراسية ::." %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    الفصول الدراسية
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="PagePanel" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="540px">
                        <tr>
                            <td>
                                <asp:FormView ID="SemesterForm" runat="server" OnItemInserted="SemesterForm_ItemInserted"
                                    DataSourceID="FormDataSource" OnItemUpdated="SemesterForm_ItemUpdated" DataKeyNames="SemesterId"
                                    Width="100%" OnModeChanging="SemesterForm_ModeChanging" 
                                    oniteminserting="SemesterForm_ItemInserting" 
                                    onitemupdating="SemesterForm_ItemUpdating">
                                    <EditItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="3">
                                                    <h4>
                                                        تعديل الفصول الدراسية</h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    الفصل الدراسي بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArActName" runat="server" Columns="25" Text='<%# Bind("SemesterName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ErrorMessage="*" ControlToValidate="txtArActName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    الفصل الدراسي بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="TextBox1" runat="server" Columns="25" Text='<%# Bind("ArSemesterName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtArActName" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    السنة الدراسية
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="ddlYear" runat="server" AppendDataBoundItems="true" DataTextField="YearName"
                                                        DataValueField="YearId" DataSourceID="YearsDS" SelectedValue='<%# Bind("YearId") %>'>
                                                        <asp:ListItem Value="0">--- Select ---</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                        ControlToValidate="ddlYear" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    تاريخ البداية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtStartDate" runat="server" Columns="12" Text='<%# Eval("StartDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                    <asp:ImageButton runat="server" ID="txtStartDateImage" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                        AlternateText="Select Date" Width="16px" Height="16px"/>
                                                    <ajaxToolkit:CalendarExtender ID="txtStartDateCalendarExtender" runat="server" CssClass="Calendar"
                                                        Format="dd/MM/yyyy" TargetControlID="txtStartDate" PopupButtonID="txtStartDateImage"
                                                        Enabled="True" />
                                                    <asp:RequiredFieldValidator ID="txtStartDateRequired" runat="server" ControlToValidate="txtStartDate"
                                                        Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="txtStartDateValidator" runat="server" ControlToValidate="txtStartDate"
                                                        ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                        SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    تاريخ النهاية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtEndDate" runat="server" Columns="12" Text='<%# Eval("EndDate","{0:dd/MM/yyyy}")%>'></asp:TextBox>
                                                    <asp:ImageButton runat="server" ID="txtEndDateImg" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                        AlternateText="Select Date" Width="16px" Height="16px"/>
                                                    <ajaxToolkit:CalendarExtender ID="Calendar" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                                        TargetControlID="txtEndDate" PopupButtonID="txtEndDateImg" Enabled="True" />
                                                    <asp:RequiredFieldValidator ID="txtEndDateRequired" runat="server" ControlToValidate="txtEndDate"
                                                        Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="txtEndDateValidator" runat="server" ControlToValidate="txtEndDate"
                                                        ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                        SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    نوع الترم
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="ddlSemesterType" runat="server" AppendDataBoundItems="true"
                                                        DataTextField="ArTypeName" DataValueField="Id" DataSourceID="SemesterTypesDS"
                                                        SelectedValue='<%# Bind("SemesterType") %>'>
                                                        <asp:ListItem Value="0">--- Select ---</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                        ControlToValidate="ddlSemesterType" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
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
                                                <td colspan="3">
                                                    <h4>
                                                        إضافة سنة دراسية جديدة</h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    الفصل الدراسي بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArActName" runat="server" Columns="25" Text='<%# Bind("SemesterName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ErrorMessage="*" ControlToValidate="txtArActName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    الفصل الدراسي بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="TextBox1" runat="server" Columns="25" Text='<%# Bind("ArSemesterName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtArActName" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    السنة الدراسية
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="ddlYear" runat="server" AppendDataBoundItems="true" DataTextField="YearName"
                                                        DataValueField="YearId" DataSourceID="YearsDS" SelectedValue='<%# Bind("YearId") %>'>
                                                        <asp:ListItem Value="0">--- Select ---</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                        ControlToValidate="ddlYear" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    تاريخ البداية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtStartDate" runat="server" Columns="12" Text='<%# Eval("StartDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                    <asp:ImageButton runat="server" ID="txtStartDateImage" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                        AlternateText="Select Date" Width="16px" Height="16px"/>
                                                    <ajaxToolkit:CalendarExtender ID="txtStartDateCalendarExtender" runat="server" CssClass="Calendar"
                                                        Format="dd/MM/yyyy" TargetControlID="txtStartDate" PopupButtonID="txtStartDateImage"
                                                        Enabled="True" />
                                                    <asp:RequiredFieldValidator ID="txtStartDateRequired" runat="server" ControlToValidate="txtStartDate"
                                                        Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="txtStartDateValidator" runat="server" ControlToValidate="txtStartDate"
                                                        ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                        SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    تاريخ النهاية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtEndDate" runat="server" Columns="12" Text='<%# Eval("EndDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                    <asp:ImageButton runat="server" ID="txtEndDateImg" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                        AlternateText="Select Date" Width="16px" Height="16px"/>
                                                    <ajaxToolkit:CalendarExtender ID="Calendar" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                                        TargetControlID="txtEndDate" PopupButtonID="txtEndDateImg" Enabled="True" />
                                                    <asp:RequiredFieldValidator ID="txtEndDateRequired" runat="server" ControlToValidate="txtEndDate"
                                                        Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="txtEndDateValidator" runat="server" ControlToValidate="txtEndDate"
                                                        ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                        SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    نوع الترم
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="ddlSemesterType" runat="server" AppendDataBoundItems="true"
                                                        DataTextField="ArTypeName" DataValueField="Id" DataSourceID="SemesterTypesDS"
                                                        SelectedValue='<%# Bind("SemesterType") %>'>
                                                        <asp:ListItem Value="0">--- Select ---</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*"
                                                        ControlToValidate="ddlSemesterType" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
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
                                <asp:ObjectDataSource ID="YearsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                </asp:ObjectDataSource>
                                <asp:ObjectDataSource ID="SemesterTypesDS" runat="server" SelectMethod="GetAllTypes"
                                    TypeName="TeiLib.YearsDAL"></asp:ObjectDataSource>
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
                                                padding-bottom: 20px" OnClick="btnAdd_Click">أضف سنة دراسية جديدة</asp:LinkButton><%----%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdSemester" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdSemester_RowDeleted" OnSelectedIndexChanged="grdSemester_SelectedIndexChanged"
                                    DataKeyNames="SemesterId" OnDataBound="grdSemester_DataBound" DataSourceID="SemesterObjectDataSource">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد فصول دراسية مضافة</div>
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#"></asp:BoundField>
                                        <asp:TemplateField HeaderText="اخفاء" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="CkHide" runat="server" Checked='<%# Eval("Hide") %>' />
                                                <asp:CheckBox ID="CKOld" runat="server" Checked='<%# Eval("Hide") %>' Visible="False" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ArSemesterName" HeaderText="الفصل الدراسي" SortExpression="ArSemesterName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <%--<asp:HyperLinkField DataNavigateUrlFields="ProductId" DataNavigateUrlFormatString="productsGallery.aspx?ProductId={0}"
                                    HeaderText="Gallery" Text="Gallery" HeaderStyle-Width="70" />--%>
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
                            <td style="padding-right: 50px">
                                <asp:LinkButton CausesValidation="False" CssClass="linkbtn" ID="btnUpdate" runat="server"
                                    ToolTip="Update Hide Values" OnClick="btnUpdate_Click">تحديث</asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                                    Visible="False">خطأ أثناء الحذف.</asp:Label>
                            </td>
                            <td align="left">
                                <asp:LinkButton ID="btnAdd1" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click">أضف سنة دراسية جديدة</asp:LinkButton>
                                <%----%>
                            </td>
                        </tr>
                    </table>
                    <asp:ObjectDataSource ID="FormDataSource" runat="server" DataObjectTypeName="TeiLib.Semester"
                        InsertMethod="Insert" SelectMethod="GetById" TypeName="TeiLib.SemestersDAL" UpdateMethod="Update">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="grdSemester" Name="SemesterId" PropertyName="SelectedValue"
                                Type="Int32" />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Year" Type="Object" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                    <asp:ObjectDataSource ID="SemesterObjectDataSource" runat="server" DeleteMethod="Delete"
                        SelectMethod="GetByPage" SelectCountMethod="GetRowsCount" TypeName="TeiLib.SemestersDAL"
                        EnablePaging="true" OnDeleted="DataSourceDeleted">
                        <DeleteParameters>
                            <asp:Parameter Name="SemesterId" Type="Int32" />
                        </DeleteParameters>
                    </asp:ObjectDataSource>
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
                <img src="images/18-0.gif" border="0" align="middle" />
                <img src="images/18-0.gif" border="0" align="middle" />
                <img src="images/18-0.gif" border="0" align="middle" />
                <img src="images/18-0.gif" border="0" align="middle" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
