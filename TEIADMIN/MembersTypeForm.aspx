<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="MembersTypeForm.aspx.cs" Inherits="MembersTypeForm" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageTitle" Runat="Server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="BodyContent" Runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">

    <ContentTemplate>
    
        <asp:MultiView ID="MultiView_MembersType" runat="server" ActiveViewIndex="2">

            <asp:View ID="View_INSERT" runat="server">

                <table class="form" width="100%">

                    <tr>
                        <td class="label" style="width: 95px">
                            المسمى الوظيفى
                        </td>
                        <td class="input">
                            <asp:TextBox ID="txtMemberType" runat="server" Width="220px"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2" align="center" class="button">
                            <asp:Button ID="btnSave" runat="server" Text="حفظ" onclick="btnSave_Click" />
                            <asp:Button ID="btnCancelSave" runat="server" Text="إلغاء" onclick="btnCancelSave_Click"/>
                        </td>
                    </tr>

                </table>

            </asp:View>

            <asp:View ID="View_UPDATE" runat="server">

                <table class="form" width="100%">
                    <tr>
                        <td class="label" style="width: 95px">
                            المسمى الوظيفى
                        </td>
                        <td class="input">
                            <asp:TextBox ID="txtMemberTypeUpdate" runat="server" Width="220px"></asp:TextBox>
                            <asp:HiddenField ID="HFMemberTypeId" runat="server"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center" class="button">
                            <asp:Button ID="btnUpdate" runat="server" Text="تعديل" onclick="btnUpdate_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="إلغاء" onclick="btnCancel_Click" />
                        </td>
                    </tr>
                </table>

            </asp:View>

            <asp:View ID="View_SELECT" runat="server">
                
                <table class="Style2">
                
                    <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>

                    <tr>
                        <td>
                            <asp:LinkButton ID="btnNew" runat="server" onclick="btnNew_Click">اضافة مسمى وظيفى جديد</asp:LinkButton>
                        </td>
                    </tr>

                    <tr>
                        <td>
                        
                            <asp:GridView ID="GridView_MembersType" runat="server" 
                                DataSourceID="ObjectDataSource1" 
                                AutoGenerateColumns="False" 
                                onrowcommand="GridView_MembersType_RowCommand">
                                <HeaderStyle  CssClass="HeaderStyle" HorizontalAlign="Right"/>
                                <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                <AlternatingRowStyle  CssClass="AltRowStyle" HorizontalAlign="Right"/>
                                <PagerStyle CssClass="PagerStyle"/>

                                <Columns>
                                    <asp:TemplateField HeaderText="المسمى الوظيفى" ItemStyle-Width="250px">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("MemberTypeName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="تعديل" ItemStyle-Width="50px">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="editLink" runat="server" CommandArgument='<%# Eval("MemberTypeId") %>'
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
                                TypeName="TeiLib.MembersTypeDAL"></asp:ObjectDataSource>
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

