<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="Categories.aspx.cs"
    Inherits="Categories" Title="::.. المجموعات ..::" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    المجموعات
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="380px">
                        <tr>
                            <td align="right" colspan="2" style="height: 17px">
                                <asp:LinkButton ID="lnkBack" runat="server" CausesValidation="false" OnClick="lnkBack_Click">رجوع</asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:FormView ID="CategoryForm" runat="server" Width="100%" DataSourceID="CategoryFormDS"
                                    DataKeyNames="CategoryId" OnItemInserting="CategoryForm_ItemInserting" OnItemInserted="CategoryForm_ItemInserted"
                                    OnItemUpdated="CategoryForm_ItemUpdated" OnModeChanging="CategoryForm_ModeChanging"
                                    OnItemUpdating="CategoryForm_ItemUpdating">
                                    <EditItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="2" class="formheader">
                                                    تعديل المجموعة
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" width="40%">
                                                    اسم المجموعة
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtCategoryName" runat="server" Columns="25" Text='<%# Bind("CategoryName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="NameRequired" runat="server" ErrorMessage="*" ControlToValidate="txtCategoryName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" width="40%">
                                                    اسم المجموعة بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArCategoryName" runat="server" Columns="25" Text='<%# Bind("ArCategoryName") %>'></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اختياري
                                                </td>
                                                <td class="input">
                                                    <asp:RadioButtonList ID="radioListIsElective" runat="server" SelectedValue='<%# Bind("IsElective") %>'
                                                        TextAlign="Left" RepeatDirection="Vertical" >
                                                        <asp:ListItem Text="نعم" Value="True"></asp:ListItem>
                                                        <asp:ListItem Text=" لا" Value="False"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    نوع المجموعة
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="categoryTypeDDL" runat="server" DataSourceID="CategoryTypeDS"
                                                        DataTextField="CategoryTypeName" DataValueField="TypeId" SelectedValue='<%# Bind("CategoryTypeId") %>'
                                                        AppendDataBoundItems="true">
                                                        <asp:ListItem Text="اختر.." Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="categoryTypeDDLRequired" runat="server" ControlToValidate="categoryTypeDDL"
                                                        ErrorMessage="*" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="تعديل" CommandName="Update"
                                                        ValidationGroup="grp1" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        CommandName="Cancel" Text="إلغاء" />
                                                </td>
                                            </tr>
                                        </table>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="2" class="formheader">
                                                    إضافة مجموعة جديدة
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" width="40%">
                                                    اسم المجموعة
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtCategoryName" runat="server" Columns="25" Text='<%# Bind("CategoryName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="NameRequired" runat="server" ErrorMessage="*" ControlToValidate="txtCategoryName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" width="40%">
                                                    اسم المجموعة بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArCategoryName" runat="server" Columns="25" Text='<%# Bind("ArCategoryName") %>'></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اختياري
                                                </td>
                                                <td class="input">
                                                    <asp:RadioButtonList ID="radioListIsElective" runat="server" Columns="25" SelectedValue='<%# Bind("IsElective") %>'
                                                        TextAlign="Left" RepeatDirection="Vertical" >
                                                        <asp:ListItem Text="نعم" Value="True"></asp:ListItem>
                                                        <asp:ListItem Text="لا " Value="False" Selected="True"></asp:ListItem>
                                                    </asp:RadioButtonList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    نوع المجموعة
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="categoryTypeDDL" runat="server" DataSourceID="CategoryTypeDS"
                                                        DataTextField="CategoryTypeName" DataValueField="TypeId" SelectedValue='<%# Bind("CategoryTypeId") %>'
                                                        AppendDataBoundItems="true">
                                                        <asp:ListItem Text="اختر.." Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="categoryTypeDDLRequired" runat="server" ControlToValidate="categoryTypeDDL"
                                                        ErrorMessage="*" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="إضافة" CommandName="Insert"
                                                        ValidationGroup="grp1" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        CommandName="Cancel" Text="إلغاء" />
                                                </td>
                                            </tr>
                                        </table>
                                    </InsertItemTemplate>
                                </asp:FormView>
                                <asp:ObjectDataSource ID="CategoryFormDS" runat="server" DataObjectTypeName="TeiLib.Category"
                                    InsertMethod="Insert" SelectMethod="GetById" TypeName="TeiLib.CategoriesBL" UpdateMethod="Update">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="CategoriesGrid" Name="categoryId" PropertyName="SelectedValue"
                                            Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <asp:ObjectDataSource ID="CategoryTypeDS" runat="server" SelectMethod="GetAllCategoryTypes"
                                    TypeName="TeiLib.CategoriesDAL" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-top: 5px">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:Label ID="submitErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">خطأ حدث ، لا يمكن اضافة المجموعة.</asp:Label>
                                            <asp:Label ID="UserErr" runat="server" CssClass="error" EnableViewState="False" Visible="False">هذه المجموعة موجودة مسبقا</asp:Label>
                                            <asp:Label ID="updateErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">خطأ حدث ، لا يمكن تعديل المجموعة</asp:Label>
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
                    <table cellpadding="0" cellspacing="0" border="0" width="600px">
                        <tr>
                            <td class="label">
                                اسم المجموعة:
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtCategoryName" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                            </td>
                            <td class="input">
                                <asp:LinkButton ID="btnSearch" runat="server" Text="بحث" CssClass="linkbtn" OnClick="btnSearch_Click">
                                </asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click">إضافة مجموعة جديدة</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <asp:GridView ID="CategoriesGrid" runat="server" CellPadding="1" CellSpacing="1"
                                    CssClass="GridViewStyle" Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="true"
                                    AllowSorting="True" OnSelectedIndexChanged="CategoriesGrid_SelectedIndexChanged"
                                    DataKeyNames="CategoryId" OnDataBound="CategoriesGrid_DataBound" DataSourceID="CategoriesDS">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>
                                        لا يوجد مجموعات متاحة
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:BoundField DataField="CategoryId" HeaderText="ID" Visible="false" />
                                        <asp:BoundField DataField="CategoryName" HeaderText="اسم المجموعة" />
                                        <asp:BoundField DataField="CategoryTypeName" HeaderText="النوع" />
                                        <asp:TemplateField HeaderText="المواد">
                                            <ItemTemplate>
                                                <asp:HyperLink ID="lnkAddCourses" runat="server" NavigateUrl='<%# Eval("CategoryId", "AssignCourses.aspx?CategoryId={0}") %>'
                                                    Text="المواد"></asp:HyperLink>
                                            </ItemTemplate>
                                            <HeaderStyle Width="90px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="المتطلبات المسبقة">
                                            <ItemTemplate>
                                                <asp:HyperLink ID="lnkAddPrerequisites" runat="server" NavigateUrl='<%# Eval("CategoryId", "Prerequistes.aspx?CategoryId={0}") %>'
                                                    Text="المتطلبات المسبقة"></asp:HyperLink>
                                            </ItemTemplate>
                                            <HeaderStyle Width="90px" />
                                        </asp:TemplateField>
                                        <asp:ButtonField CommandName="Select" HeaderText="تعديل" Text="تعديل" />
                                        <asp:TemplateField HeaderText="حذف">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False"
                                                    CommandName="Delete" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' /></ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                                    Visible="False">خطـأ حدث، لا يمكن حذف المجموعة</asp:Label>
                            </td>
                            <td align="right">
                                <asp:LinkButton ID="btnAdd1" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click">إضافة مجموعة جديدة</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </asp:View>
                <asp:View ID="NoAccessView" runat="server">
                    <h2 id="noAccess">
                        لا يمكنك الدخول إلى هذه الصفحة ، ليست من اختصاصك</h2>
                </asp:View>
            </asp:MultiView>
            <asp:ObjectDataSource ID="CategoriesDS" runat="server" TypeName="TeiLib.CategoriesBL"
                EnablePaging="true" SelectMethod="GetByPage" SelectCountMethod="GetRowsCount"
                DeleteMethod="Delete">
                <SelectParameters>
                    <asp:Parameter Name="categoryName" Type="String" />
                </SelectParameters>
                <DeleteParameters>
                    <asp:Parameter Name="categoryId" Type="String" />
                </DeleteParameters>
            </asp:ObjectDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
