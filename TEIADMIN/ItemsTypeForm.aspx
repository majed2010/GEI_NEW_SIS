<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="ItemsTypeForm.aspx.cs" Inherits="ItemsTypeForm" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="BodyContent" runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">

        <ContentTemplate>

            <asp:MultiView ID="MultiView_ItemsType" runat="server" ActiveViewIndex="2">

                <asp:View ID="View_INSERT" runat="server">

                    <table class="form" width="100%">

                        <tr>
                            <td class="label">فئة البند
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtItemType" runat="server" Width="250px"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <td class="label">اسم الاستبيان
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="ddlSurveyTypes" runat="server" AppendDataBoundItems="True" DataSourceID="ObjectDataSource2" DataTextField="SurveyName" DataValueField="SurveyId" Width="250px">
                                    <asp:ListItem Selected="True" Enabled="true" Text="--- اختر ---" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" TypeName="TeiLib.SurveyTypesDAL"></asp:ObjectDataSource>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:Button ID="btnSave" runat="server" Text="حفظ" OnClick="btnSave_Click" />
                                <asp:Button ID="btnCancelSave" runat="server" Text="إلغاء" OnClick="btnCancelSave_Click" />
                            </td>
                        </tr>
                    </table>

                </asp:View>

                <asp:View ID="View_UPDATE" runat="server">

                    <table class="form" width="100%">
                        <tr>
                            <td class="label">فئة البند
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtItemTypeUpdate" runat="server" Width="250px"></asp:TextBox>
                                <asp:HiddenField ID="HFItemId" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td class="label">اسم الاستبيان
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="ddlSurveyTypesUpdate" runat="server"
                                    DataSourceID="ObjectDataSource2"
                                    DataTextField="SurveyName"
                                    DataValueField="SurveyId" Width="250px">
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

                    <table class="Style2">

                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <asp:LinkButton ID="btnNew" runat="server" OnClick="btnNew_Click">اضافة فئة بند جديدة</asp:LinkButton>
                            </td>
                        </tr>

                        <tr>
                            <td>

                                <asp:GridView ID="GridView_ItemsType" runat="server"
                                    DataSourceID="ObjectDataSource1"
                                    AutoGenerateColumns="False"
                                    OnRowCommand="GridView_ItemsType_RowCommand" Width="490px">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />

                                    <Columns>

                                        <asp:TemplateField HeaderText="فئة البند" ItemStyle-Width="250px">
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="اسم الاستبيان" ItemStyle-Width="250px">
                                            <ItemTemplate>
                                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("SurveyName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="تعديل" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="editLink" runat="server" CommandArgument='<%# Eval("ItemId") %>'
                                                    CommandName="rowEdit" CausesValidation="false">تعديل</asp:LinkButton>
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
                                    TypeName="TeiLib.ItemsTypeDAL"></asp:ObjectDataSource>
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

