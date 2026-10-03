<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="AssignCourses.aspx.cs"
    Inherits="AssignCourses" Title="::. تعيين المواد .::" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="Server">
  <style type="text/css">
        .PromptCSS
        {
            color:Snow;
            font-size:medium;
            font-style:normal;
            font-weight: normal;
            position:absolute;
            vertical-align:middle;
            align:center;
            background-color:#589DAC;
            font-family:Tahoma;
            border:solid 1px blue;
            height:28px;
            }
    </style>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="PageTitle" runat="Server">
    <h1>
        المواد &raquo; المجموعة:
        <asp:HyperLink ID="lnkCategory" runat="server" NavigateUrl="Categories.aspx" Style="background: none;"></asp:HyperLink></h1>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table cellpadding="0" cellspacing="0" border="0" width="380px">
                <tr>
                    <td colspan="2">
                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                            <tr>
                                <td colspan="2" class="formheader">
                                    تعيين مادة
                                </td>
                            </tr>
                            <tr>
                                <td class="label" style="width: 20%">
                                    اسم المادة:
                                </td>
                                <td class="input">
                                    <asp:TextBox ID="txtCourseName" runat="server"></asp:TextBox>
                                    <br />
                                    <br />
                                    <asp:Button ID="btnCourseSearch" runat="server" CssClass="button" Text="بحث" OnClick="btnSearch_Click2" />
                                </td>
                            </tr>
                            <tr>
                                <td class="label" style="width: 34%">
                                    المواد
                                </td>
                                <td class="input">
                                    <asp:DropDownList ID="ddlCourses" runat="server" AppendDataBoundItems="true" Width="242px">
                                        <asp:ListItem Text="اختر.." Value="-"></asp:ListItem>
                                    </asp:DropDownList>
                                        <cc1:ListSearchExtender ID="coursesListSearchExtender" runat="server" Enabled="True"
                                            PromptText="اكتب للبحث" PromptPosition="Top" PromptCssClass="PromptCSS" TargetControlID="ddlCourses">
                                        </cc1:ListSearchExtender>
                                    <asp:ObjectDataSource ID="CoursesNotInCategoryDS" runat="server" SelectMethod="Courses_NotInCategories"
                                        TypeName="TeiLib.CategoriesBL">
                                        <SelectParameters>
                                            <asp:QueryStringParameter QueryStringField="CategoryId" Name="categoryId" Type="Int32" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    <asp:RequiredFieldValidator ID="ddlCoursesRequired" runat="server" ControlToValidate="ddlCourses"
                                        ErrorMessage="*" ValidationGroup="grp1" InitialValue="-"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="button" colspan="2" align="center">
                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="حفــــظ" ValidationGroup="grp1"
                                        OnClick="btnSubmit_Click" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-top: 5px">
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td>
                                    <asp:Label ID="submitErr" runat="server" CssClass="error" EnableViewState="False"
                                        Visible="False">خطأ حدث ، لا يمكن تعيين مادة</asp:Label>
                                    <asp:Label ID="UserErr" runat="server" CssClass="error" EnableViewState="False" Visible="False">هذه المادة معينة مسبقا.</asp:Label>
                                    <asp:Label ID="updateErr" runat="server" CssClass="error" EnableViewState="False"
                                        Visible="False">خطأ حدث ، لا يمكن تحديث هذه المادة</asp:Label>
                                </td>
                                <td align="right">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" border="0" width="600px">
                <tr>
                    <td class="label" style="width: 20%">
                        اسم المادة:
                    </td>
                    <%--DataSourceID="CoursesNotInCategoryDS"
                                        DataTextField="NAME" DataValueField="COURSE_ID"--%>
                    <td class="input">
                        <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" CssClass="button" Text="بحــــث" OnClick="btnSearch_Click1" />
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <asp:GridView ID="CategoriesGrid" runat="server" CellPadding="1" CellSpacing="1"
                            CssClass="GridViewStyle" Width="100%" AutoGenerateColumns="False" GridLines="None"
                            AllowPaging="true" AllowSorting="True" DataKeyNames="Id" DataSourceID="CategoriesDS"
                            OnRowCommand="CategoriesGrid_RowCommand">
                            <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                            <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                            <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                            <PagerStyle CssClass="PagerStyle" />
                            <EmptyDataTemplate>
                                لا يوجد مواد معينة
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:BoundField DataField="Id" HeaderText="ID" Visible="false" />
                                <asp:BoundField DataField="ArCourseName" HeaderText="اسم المادة" SortExpression="ArCourseName" />
                                <asp:TemplateField HeaderText="حذف">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False"
                                            CommandArgument='<%# Bind("Id") %>' CommandName="deleteMethod" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' /></ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                            Visible="False">An error occurred, could not delete category.</asp:Label>
                    </td>
                    <td align="right">
                    </td>
                </tr>
            </table>
            <asp:ObjectDataSource ID="CategoriesDS" runat="server" TypeName="TeiLib.CategoriesBL"
                SelectMethod="Categories_GetCourses" OnSelected="CategoriesDS_Selected">
                <SelectParameters>
                    <asp:QueryStringParameter Name="categoryId" Type="Int32" QueryStringField="CategoryId" />
                    <asp:Parameter Name="categoryName" Type="String" Direction="Output" />
                    <asp:Parameter Name="searchCourseName" Type="String" Direction="Output" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
