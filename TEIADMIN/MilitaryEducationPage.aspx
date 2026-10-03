<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="MilitaryEducationPage.aspx.cs" Inherits="MilitaryEducationPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style1
        {
            height: 22px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" Runat="Server">
    <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
<asp:View ID="InsertUpdateView" runat="server">
<table width="100%" class="form">
<tr>
<td class="style1">
اسم الدورة
</td>
<td class="style1">
<asp:TextBox ID="txtbuildingName" runat="server" ></asp:TextBox>
    <asp:HiddenField ID="hdnBuildId" runat="server" />
</td>
</tr>
    <tr>
        <td align="center" colspan="2">
           <asp:Button ID="btnSave" runat="server" CssClass="button" Text="حفظ" 
                onclick="btnSave_Click"/>
                <asp:Button ID="btnUpdate" runat="server" CssClass="button" Text="تعديل" 
                onclick="btnUpdate_Click" Visible="false"/>
           <asp:Button ID="btnCancel" runat="server" CssClass="button" Text="الغاء" 
                onclick="btnCancel_Click"/></td>
        
    </tr>
  
</table>
</asp:View>

<asp:View ID="GridView" runat="server" >
<asp:LinkButton ID="btnAddNew" runat="server" Text="اضافة دورة جديد" 
        ForeColor="Red" onclick="btnAddNew_Click"></asp:LinkButton>
    <br />
    <asp:GridView runat="server" ID="BuildingGrid"  AllowPaging="True"
        DataKeyNames="MilitaryEducationId" DataSourceID="ObjectDataSource1" 
        AutoGenerateColumns="False" 
        onrowcommand="BuildingGrid_RowCommand" EnableModelValidation="True">
<HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                   
                                    <Columns>
                                   
                                  <asp:TemplateField HeaderText="#" ItemStyle-Width="50px">
                                      <ItemTemplate>
           <asp:Label ID="lblBuidId" runat="server" Text='<%#Eval("MilitaryEducationId") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    <asp:TemplateField HeaderText="اسم الدورة" ItemStyle-Width="150px">
                                      <ItemTemplate>
           <asp:Label ID="lblBuidName" runat="server" Text='<%#Eval("MilitaryEducationName") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                     <asp:TemplateField HeaderText="تعديل" ItemStyle-Width="50px">
                                      <ItemTemplate>
           <asp:LinkButton ID="btnEdit" runat="server" Text="تعديل" CausesValidation="False" CommandName="Edit" CommandArgument='<%#Bind("MilitaryEducationId") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="حذف" ItemStyle-Width="50px">
                                      <ItemTemplate>
           <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False" CommandName="Delete" CommandArgument='<%#Bind("MilitaryEducationId") %>'
            OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                     <EmptyDataTemplate>
                                        <div>
                                            لا يوجد دورات مضافة</div>
                                    </EmptyDataTemplate>
    </asp:GridView>
    <br />
    <br />
   
  
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetAll" TypeName="TeiLib.MilitaryEducationDAL" 
        DeleteMethod="Delete"  >
       
        
   
        <DeleteParameters>
            <asp:Parameter Name="MilitaryEducationId" Type="Int32" />
        </DeleteParameters>
       
        
   
    </asp:ObjectDataSource>
   
  
    <br />
</asp:View>
    

<asp:View ID="NoAcessView" runat="server">
<div>لا يوجد صلاحية لدخول الصفحة</div>
</asp:View>
</asp:MultiView>
</asp:Content>
