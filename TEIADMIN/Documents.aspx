<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="Documents.aspx.cs" Inherits="Documents" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
    .style1
    {
        width: 100%;
    }
        .style3
        {
            width: 408px;
        }
        .style4
        {
            text-align: center;
        }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" Runat="Server">
   <asp:UpdatePanel ID="PagePanel" runat="server" > 
<ContentTemplate>

    <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
    
    <asp:View ID="FormView" runat="server">
        <table border="0" cellpadding="0" cellspacing="0" width="540px">
            <tr>
                <td >
                    <asp:FormView ID="DocumentForm" runat="server" 
                        DataSourceID="FormDataSource" 
                        oniteminserted="DocumentForm_ItemInserted" 
                        onitemupdated="DocumentForm_ItemUpdated" 
                        onmodechanging="DocumentForm_ModeChanging" Width="100%" 
                        DataKeyNames="DocumentId">
                        
                        
                        
                        <EditItemTemplate>
                            <table class="form" width="100%">
                                <tr>
                                    <td align="center" class="RowStyle" colspan="2">
                                        تعديل المستند</td>
                                </tr>
                                <tr>
                                    <td class="RowStyle">
                                        &nbsp;</td>
                                    <td class="RowStyle">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="RowStyle">
                                        <asp:Label ID="lblArname" runat="server" Text="اسم  المستند بالعربية"></asp:Label>
                                    </td>
                                    <td class="RowStyle">
                                        <asp:TextBox ID="txtArDocumentName" runat="server" Width="200px" 
                                            Text='<%# Bind("ArDocumentName") %>' ></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td class="RowStyle">
                                        <asp:Label ID="lblEnName" runat="server" Text="اسم المستند بالانجليزية"></asp:Label>
                                    </td>
                                    <td class="RowStyle">
                                        <asp:TextBox ID="txtEnDocumentName" runat="server" Width="200px" 
                                            Text='<%# Bind("EnDocumentName") %>'></asp:TextBox>
                                    </td>
                                </tr>
                                                              
                                <tr>
                                    <td class="RowStyle">
                                        &nbsp;</td>
                                    <td class="RowStyle">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="style4" colspan="2">
                                        <asp:Button ID="Button1" runat="server" CommandName="update" Text="تعديل" 
                                            Width="100px" />
                                        <asp:Button ID="Button2" runat="server" CommandName="Cancel" Text="الغاء" 
                                            Width="100px" />
                                    </td>
                                </tr>
                            </table>
                            <table class="accordion-content">
                                <tr>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                            </table>
                        </EditItemTemplate>
                        
                        
                        
                        <InsertItemTemplate>
                            <table class="form" width="100%">
                                <tr>
                                    <td align="center" class="RowStyle" colspan="2">
                                        ادخال المستند جديد</td>
                                </tr>
                                <tr>
                                    <td class="RowStyle">
                                        &nbsp;</td>
                                    <td class="RowStyle">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="RowStyle">
                                        <asp:Label ID="lblArname" runat="server" Text="اسم  المستند بالعربية"></asp:Label>
                                    </td>
                                    <td class="RowStyle">
                                        <asp:TextBox ID="txtArDocumentName" runat="server" 
                                            Text='<%# Bind("ArDocumentName") %>' Width="200px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="RowStyle">
                                        <asp:Label ID="lblEnName" runat="server" Text="اسم المستند بالانجليزية"></asp:Label>
                                    </td>
                                    <td class="RowStyle">
                                        <asp:TextBox ID="txtEnDocumentName" runat="server" 
                                            Text='<%# Bind("EnDocumentName") %>' Width="200px"></asp:TextBox>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td class="RowStyle">
                                        &nbsp;</td>
                                    <td class="RowStyle">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="style4" colspan="2">
                                        <asp:Button ID="btnsave" runat="server" CommandName="insert" Text="حفظ" 
                                            Width="100px" />
                                        <asp:Button ID="btncancel" runat="server" CommandName="Cancel" Text="الغاء" 
                                            Width="100px" />
                                    </td>
                                </tr>
                            </table>
                        </InsertItemTemplate>
                        
                        
                        
                    </asp:FormView>
                    <br />
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Label ID="ErrorSave" runat="server" Font-Bold="True" ForeColor="Red" 
                        Text="Error in Save" Visible="False"></asp:Label>
                    <asp:Label ID="ErrorUpdate" runat="server" Font-Bold="True" ForeColor="Red" 
                        Text="Error in Update" Visible="False"></asp:Label>
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="style3">
                    &nbsp;</td>
                <td>
                    <asp:LinkButton ID="btnBack" runat="server" onclick="btnBack_Click">رجوع</asp:LinkButton>
                </td>
            </tr>
        </table>
        <br />
    </asp:View>
    <asp:View ID="ListView" runat="server">
        <table class="style1">
            <tr>
                <td>
                    <asp:LinkButton ID="lbtnAdd" runat="server" onclick="lbtnAdd_Click">اضافة المستند جديد</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="DocumentGrid" runat="server" AllowPaging="True" 
                        AllowSorting="True" AutoGenerateColumns="False" CellPadding="1" CellSpacing="1" 
                        CssClass="GridViewStyle" DataKeyNames="DocumentId" 
                        DataSourceID="DocumentDataSource" GridLines="None" Width="100%" 
                        ondatabound="DocumentGrid_DataBound" onrowdeleted="DocumentGrid_RowDeleted" 
                        onselectedindexchanged="DocumentGrid_SelectedIndexChanged">
                        <HeaderStyle  CssClass="HeaderStyle"  HorizontalAlign="Right"/>
                        <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                        <AlternatingRowStyle CssClass="AltRowStyle"  HorizontalAlign="Right"/>
                        <PagerStyle CssClass="PagerStyle" />
                        <Columns>
                            <asp:BoundField DataField="RowId" HeaderText="رقم" SortExpression="RowId" />
                            <asp:BoundField DataField="ArDocumentName" HeaderText="اسم المستند" 
                                SortExpression="ArDocumentName"  HeaderStyle-HorizontalAlign="Right" ItemStyle-Width="200px" HeaderStyle-Width="170px"/>
                            <asp:BoundField DataField="EnDocumentName" HeaderText="اسم المستند بالانجليزية" 
                                SortExpression="EnDocumentName" HeaderStyle-HorizontalAlign="Right"  />
                            <asp:ButtonField CommandName="Select" HeaderText="تعديل" ShowHeader="True" 
                                Text="تعديل" HeaderStyle-Width="70px" ItemStyle-Width="50px" />
                            <asp:TemplateField HeaderText="حذف">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="false" CommandName="Delete" OnClientClick=<%#"return confirm (\"Are you sure you want to Delete this Document?\")" %>></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate >
                        <div class="form">لا يوجد بيانات</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="DeleteError" runat="server" Text="Error in Deleteing" 
                        Visible="False" ForeColor="Red"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
        <br />
        <br />
        <asp:ObjectDataSource ID="FormDataSource" runat="server" 
            DataObjectTypeName="TeiLib.DocumentsBo" InsertMethod="DocumentInsert" 
            SelectMethod="GetById" TypeName="TeiLib.DocumentsDal" 
            UpdateMethod="DocumentUpdate" onselecting="FormDataSource_Selecting" 
            OldValuesParameterFormatString="original_{0}">
            <SelectParameters>
                <asp:ControlParameter ControlID="DocumentGrid" Name="DocumentId" 
                    PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
        

        <asp:ObjectDataSource ID="DocumentDataSource" runat="server" 
            DeleteMethod="DocumentDelete" EnablePaging="True" 
            SelectCountMethod="GetRowsCount" SelectMethod="DocumentsGetByPage" 
            TypeName="TeiLib.DocumentsDal" OnDeleted="DataSourceDeleted">
            <DeleteParameters>
                <asp:Parameter Name="DocumentId" Type="Int32" />
            </DeleteParameters>
            </asp:ObjectDataSource>
            
        <br />
    </asp:View>
    </asp:MultiView>
    </ContentTemplate>
</asp:UpdatePanel>
    <asp:UpdateProgress ID="LoadingProgress" runat="server">
            <ProgressTemplate>
        <div ID="progressMessage">
            Processing... &nbsp;
            <img align="absmiddle" border="0" src="images/18-0.gif" />
            <img align="absmiddle" border="0" src="images/18-0.gif" />
            <img align="absmiddle" border="0" src="images/18-0.gif" />
            <img align="absmiddle" border="0" src="images/18-0.gif" />
        </div>
        </ProgressTemplate>
        </asp:UpdateProgress>
</asp:Content>

