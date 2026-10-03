<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="viewEmployee.aspx.cs" Inherits="viewEmployee" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" Runat="Server">
بحث عن الموظفين
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" Runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
       <ContentTemplate>
       
                           <table cellpadding="2" cellspacing="2" border="0" width="300" class="form">
                        <tr>
                            <td class="label">
                               اسم الموظف
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txt_emp_name" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                               الاداره
                            </td>
                            <td class="input">
                                <telerik:RadComboBox ID="Dept_RCB" runat="server" MarkFirstMatch="true" 
                                Height="200px">
                                
                               
                                <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                               
                            </telerik:RadComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                المسمى الوظيفي
                            </td>
                            <td class="input">
                                 <telerik:RadComboBox ID="Job_RBC" runat="server" MarkFirstMatch="true" 
                                Height="200px">
                            
                                <CollapseAnimation Duration="200" Type="OutQuint" />
                            
                            </telerik:RadComboBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الموظفين المحذوفين
                            </td>
                            <td class="input" >
                                <asp:CheckBox ID="show_deleted_chk" runat="server" Checked = "false"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:LinkButton ID="btnSearch" runat="server" CssClass="linkbtn" Text="بحث" OnClick="btnSearch_Click"></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                    
    
       <asp:GridView ID="GridView1" runat="server" Width="100%" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" CssClass="GridViewStyle"  onrowcommand="GridView1_RowCommand" 
        onrowcreated="GridView1_RowCreated" CellPadding="4" ForeColor="#333333" GridLines="None">
           <RowStyle BackColor="#EFF3FB" />
           <Columns>
               <asp:TemplateField ShowHeader="False">
                   <ItemTemplate>
                       <asp:LinkButton ID="btn_Delete" runat="server" CausesValidation="False" 
                           CommandArgument='<%# bind("emp_id") %>' CommandName="rowDelete" Text="حذف" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>'></asp:LinkButton>
                   </ItemTemplate>
               </asp:TemplateField>
               <asp:BoundField DataField="Emp_Job_Title_Name_ara" HeaderText="المسمى الوظيفي" 
                   SortExpression="Emp_Job_Title_Name_ara" />
                    <asp:BoundField DataField="Dept_Name_ara" HeaderText="الاداره" 
                   SortExpression="Dept_Name_ara" />
                    <asp:BoundField DataField="emp_ara_name" HeaderText="اسم الموظف" 
                   SortExpression="emp_ara_name" />
                   <asp:BoundField DataField="Emp_Code" HeaderText="كود الموظف" 
                   SortExpression="Emp_Code" />
               <asp:TemplateField ShowHeader="False">
                   <ItemTemplate>
                       <asp:LinkButton ID="btn_Edit" runat="server" CausesValidation="False" 
                           CommandArgument='<%# bind("emp_id") %>' CommandName="rowEdit" Text="تعديل"></asp:LinkButton>
                   </ItemTemplate>
               </asp:TemplateField>
           </Columns>
           <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
           <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
           <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
           <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
           <EditRowStyle BackColor="#2461BF" />
           <AlternatingRowStyle BackColor="White" />
    </asp:GridView>

    <asp:LinkButton ID="btn_Add" runat="server" onclick="btn_Add_Click">اضافة موظف</asp:LinkButton>
          

           <asp:Label ID="No_Data_lbl" runat="server" Font-Bold="True" ForeColor="Red" 
               Text="لا يوجد بيانات" Visible="False"></asp:Label>
<telerik:RadWindowManager ID="RadWindowManager2" runat="server">
           <Windows>
           <telerik:RadWindow ID="RadWindow1" OnClientClose="ReloadForm" NavigateUrl="Delete_Emp.aspx"
                        Skin="Vista" VisibleOnPageLoad="false" OffsetElementID="offsetElement" runat="server"
                        Width="80%" Height="600px" ReloadOnShow="true" />
                    </Windows>    
                        </telerik:RadWindowManager>
</ContentTemplate>
</asp:UpdatePanel>
</asp:Content>

