<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="SurveyItemsForm.aspx.cs" Inherits="SurveyItemsForm" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="BodyContent" runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">

        <ContentTemplate>

            <asp:MultiView ID="MultiView_SurveyItems" runat="server" ActiveViewIndex="2">

                <asp:View ID="View_INSERT" runat="server">

                    <table class="form" width="100%">

                        <tr>
                            <td class="label">نص البند
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtItem" runat="server" Width="300px"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <td class="label">فئة البند
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="DDLItemTypes" runat="server" Width="250px" AppendDataBoundItems="true"
                                    DataSourceID="ObjectDataSource2" DataTextField="ItemName"
                                    DataValueField="ItemId">
                                    <asp:ListItem Selected="True" Enabled="true" Text="--- اختر ---" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="ObjectDataSource2" runat="server"
                                    OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll"
                                    TypeName="TeiLib.ItemsTypeDAL"></asp:ObjectDataSource>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:Button ID="btnAddItem" runat="server" Text="حفظ" OnClick="btnAddItem_Click" />
                                <asp:Button ID="btnCancelAdd" runat="server" Text="إلغاء" OnClick="btnCancelAdd_Click" />
                            </td>
                        </tr>
                    </table>

                </asp:View>

                <asp:View ID="View_Update" runat="server">

                    <table class="form" width="100%">
                        <tr>
                            <td class="label">نص البند
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtItemUpdate" runat="server" Width="300px"></asp:TextBox>
                                <asp:HiddenField ID="HFItemId" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="label">فئة البند
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="DDLItemTypesUpdate" runat="server" Width="250px"
                                    DataSourceID="ObjectDataSource2" DataTextField="ItemName"
                                    DataValueField="ItemId">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:Button ID="btnUpdate" runat="server" Text="تعديل" OnClick="btnUpdate_Click" />
                                <asp:Button ID="btnCancel" runat="server" Text="إلغاء" OnClick="btnCancel_Click" />
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
                                <asp:LinkButton ID="btnNew" runat="server" OnClick="btnNew_Click">اضافة بند جديد</asp:LinkButton>
                            </td>
                            <td>&nbsp;</td>
                        </tr>

                        <tr>
                            <td>

                                <asp:GridView ID="GridView_SurveyItems" runat="server"
                                    AutoGenerateColumns="False" AllowPaging="true"
                                    OnRowCommand="GridView_SurveyItems_RowCommand" DataSourceID="ObjectDataSource1">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />

                                    <Columns>
                                        <asp:TemplateField HeaderText="نص اليند" ItemStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("SurveyItemText") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="فئة البند" ItemStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="تعديل" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="editLink" runat="server" CommandArgument='<%# Eval("SurveyItemId") %>'
                                                    CommandName="rowEdit" CausesValidation="false">تعديل</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="deleteLink" runat="server" CommandArgument='<%# Eval("SurveyItemId") %>' OnClientClick='<%# "return confirm(\"هل تريد تأكيد الحذف\")" %>'
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
                                <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" TypeName="TeiLib.SurveyItemsDAL"></asp:ObjectDataSource>
                            </td>
                        </tr>

                    </table>

                </asp:View>
                 </asp:View>
                       <asp:View ID="NoAccess" runat="server">
                <asp:Label ID="lblNoAccess" runat="server" Text="لا يمكنك الدخول للصفحة"  CssClass="label" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                </asp:View>
            </asp:MultiView>

        </ContentTemplate>

    </asp:UpdatePanel>

</asp:Content>
