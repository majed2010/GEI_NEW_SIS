<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="FacultyMembersForm.aspx.cs" Inherits="FacultyMembersForm" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="BodyContent" runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">

        <ContentTemplate>

            <asp:MultiView ID="MultiView_FacultyMembers" runat="server" ActiveViewIndex="2">

                <asp:View ID="View_ISERT" runat="server">

                    <table class="form" width="100%">

                        <tr>
                            <td class="label">اسم العضو
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtMemberName" runat="server" Width="500px"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <td class="label">القسم
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="DDLDepartments" runat="server" Width="250px" AppendDataBoundItems="true"
                                    DataSourceID="ObjectDataSource3" DataTextField="ArDepartmentName"
                                    DataValueField="DepartmentId">
                                    <asp:ListItem Selected="True" Enabled="true" Text="--- اختر ---" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="ObjectDataSource3" runat="server"
                                    OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll"
                                    TypeName="TeiLib.DepartmentsDAL"></asp:ObjectDataSource>
                            </td>
                        </tr>

                        <tr>
                            <td class="label">المسمى الوظيفى
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="DDLMemberType" runat="server" Width="200px" AppendDataBoundItems="true"
                                    DataSourceID="ObjectDataSource2" DataTextField="MemberTypeName" DataValueField="MemberTypeId">
                                    <asp:ListItem Selected="True" Enabled="true" Text="--- اختر ---" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="ObjectDataSource2" runat="server"
                                    OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll"
                                    TypeName="TeiLib.MembersTypeDAL"></asp:ObjectDataSource>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:Button ID="btnAddMember" runat="server" Text="حفظ" OnClick="btnAddMember_Click" />
                                <asp:Button ID="btnCancelAdd" runat="server" Text="إلغاء" OnClick="btnCancelAdd_Click" />
                            </td>
                        </tr>

                    </table>

                </asp:View>

                <asp:View ID="View_UPDATE" runat="server">

                    <table class="form" width="100%">

                        <tr>
                            <td class="label">اسم العضو
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtMemberUpdate" runat="server" Width="300px"></asp:TextBox>
                                <asp:HiddenField ID="HFMemberId" runat="server" />
                            </td>
                        </tr>

                        <tr>
                            <td class="label">القسم
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="DDLDepartmentsUpdate" runat="server" Width="250px"
                                    DataSourceID="ObjectDataSource3" DataTextField="ArDepartmentName"
                                    DataValueField="DepartmentId">
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td class="label">المسمى الوظيفى
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="DDLMemberTypesUpdate" runat="server" Width="200px"
                                    DataSourceID="ObjectDataSource2" DataTextField="MemberTypeName" DataValueField="MemberTypeId">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:Button ID="btnUpdate" runat="server" Text="تعديل" OnClick="btnUpdate_Click" />
                                <asp:Button ID="btnCancelUpdate" runat="server" Text="إلغاء" OnClick="btnCancelUpdate_Click" />
                            </td>
                        </tr>
                    </table>

                </asp:View>

                <asp:View ID="View_SELECT" runat="server">

                    <table class="style2">

                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <asp:LinkButton ID="btnNew" runat="server" OnClick="btnNew_Click">اضافة عضو جديد</asp:LinkButton>
                            </td>
                            <td>&nbsp;</td>
                        </tr>



                        <tr>
                            <td colspan="2">

                                <asp:GridView ID="GridView_FacultyMembers" runat="server"
                                    DataSourceID="ObjectDataSource1"
                                    AutoGenerateColumns="False" AllowPaging="true"
                                    OnRowCommand="GridView_FacultyMembers_RowCommand">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <Columns>

                                        <asp:TemplateField HeaderText="اسم العضو" ItemStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:Label ID="MemberName" runat="server" Text='<%# Eval("MemberName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="القسم" ItemStyle-Width="150px">
                                            <ItemTemplate>
                                                <asp:Label ID="ArDepartmentName" runat="server" Text='<%# Eval("ArDepartmentName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="المسمى الوظيفى" ItemStyle-Width="150px">
                                            <ItemTemplate>
                                                <asp:Label ID="Name" runat="server" Text='<%# Eval("MemberTypeName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="تعديل">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="editLink" runat="server" CommandArgument='<%# Eval("MemberId") %>'
                                                    CommandName="rowEdit" CausesValidation="false">تعديل</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="حذف">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="deleteLink" runat="server" CommandArgument='<%# Eval("MemberId") %>' OnClientClick='<%# "return confirm(\"هل تريد تأكيد الحذف\")" %>'
                                                    CommandName="rowDelete" CausesValidation="false">حذف</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    </Columns>

                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد بيانات 
                                        </div>
                                    </EmptyDataTemplate>

                                </asp:GridView>

                            </td>
                        </tr>

                        <tr>
                            <td>
                                <asp:ObjectDataSource ID="ObjectDataSource1" runat="server"
                                    OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll"
                                    TypeName="TeiLib.FacultyMembersDAL"></asp:ObjectDataSource>
                            </td>
                        </tr>

                    </table>

                </asp:View>
                <asp:View ID="NoAccess" runat="server">
                <asp:Label ID="lblNoAccess" runat="server" Text="لا يمكنك الدخول للصفحة"  CssClass="label" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                </asp:View>
            </asp:MultiView>

        </ContentTemplate>

    </asp:UpdatePanel>

</asp:Content>
