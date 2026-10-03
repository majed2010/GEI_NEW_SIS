<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="AssignMembersToCoursesForm.aspx.cs" Inherits="AssignMembersToCoursesForm" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:content id="Content3" contentplaceholderid="PageTitle" runat="Server">
</asp:content>

<asp:content id="Content1" contentplaceholderid="BodyContent" runat="Server">

   <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server">

    <ContentTemplate>--%>
    
        <asp:MultiView ID="MultiView_AssignMemberToCource" runat="server" ActiveViewIndex="2">
        
            <asp:View ID="View_INSERT" runat="server">

                <table class="form" width="100%">
                    <tr>
                        <td class="label">
                            الاسم
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="DDLMemberNames" runat="server" Width="300px" AppendDataBoundItems="true"
                                DataSourceID="ObjectDataSource6" DataTextField="MemberName" 
                                DataValueField="MemberId">
                                <asp:ListItem Selected="True" Enabled="true" Text="--- اختر ---" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="ObjectDataSource6" runat="server" 
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" 
                                TypeName="TeiLib.FacultyMembersDAL"></asp:ObjectDataSource>
                        </td>
                    </tr>

                    <tr>
                        <td class="label">
                            القسم
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="DDLDepartments" runat="server" Width="250px" AppendDataBoundItems="true"
                                DataSourceID="ObjectDataSource3" DataTextField="ArDepartmentName" AutoPostBack="true"
                                DataValueField="DepartmentId">
                                <asp:ListItem Selected="True" Enabled="true" Text="--- اختر ---" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" 
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" 
                                TypeName="TeiLib.DepartmentsDAL"></asp:ObjectDataSource>
                        </td>
                    </tr>

                    <tr>
                        <td class="label">
                            المادة
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="DDLCourses" runat="server" Width="200px" AppendDataBoundItems="true"
                                DataSourceID="ObjectDataSource4" DataTextField="ArCourseName" 
                                DataValueField="CourseId">
                                <asp:ListItem Selected="True" Enabled="true" Text="--- اختر ---" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="ObjectDataSource4" runat="server" 
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetByDeptId" 
                                TypeName="TeiLib.CoursesDAL">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="DDLDepartments" Name="departmentId" 
                                        PropertyName="SelectedValue" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="label">
                            الفصل الدراسى
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="DDLSemesters" runat="server" Width="200px" AppendDataBoundItems="true"
                                DataSourceID="ObjectDataSource5" DataTextField="ArSemesterName" 
                                DataValueField="SemesterId">
                                <asp:ListItem Selected="True" Enabled="true" Text="--- اختر ---" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="ObjectDataSource5" runat="server" 
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" 
                                TypeName="TeiLib.SemestersDAL"></asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                      <td class="label">
                            عدد المجموعة
                        </td>
                        <td class="input">
                    <asp:TextBox ID="txtgroupnumber" runat="server" Width="200px"></asp:TextBox>
                    </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center" class="button">
                            <asp:Button ID="btnAddMember" runat="server" Text="حفظ" onclick="btnAddMember_Click" />
                            <asp:Button ID="btnCancelAdd" runat="server" Text="إلغاء" onclick="btnCancelAdd_Click" />
                        </td>
                    </tr>

                </table>

            </asp:View>

            <asp:View ID="View_UPDATE" runat="server">

                <table class="form" width="100%">

                    <tr>
                        <td class="label">
                            الاسم
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="DDLMemberNamesUpdate" runat="server" Width="300px" 
                                DataSourceID="ObjectDataSource6" DataTextField="MemberName" 
                                DataValueField="MemberId">
                            </asp:DropDownList>
                            <asp:HiddenField ID="HFAssignId" runat="server"/>
                        </td>
                    </tr>

                    <tr>
                        <td class="label">
                            القسم
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="DDLDepartmentsUpdate" runat="server" Width="250px" 
                                DataSourceID="ObjectDataSource3" DataTextField="ArDepartmentName" 
                                DataValueField="DepartmentId">
                            </asp:DropDownList>
                        </td>
                    </tr>

                    <tr>
                        <td class="label">
                            المادة
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="DDLCoursesUpdate" runat="server" Width="200px" 
                                DataSourceID="UpDsCourses" DataTextField="ArCourseName" 
                                DataValueField="CourseId">
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="UpDsCourses" runat="server" 
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" 
                                TypeName="TeiLib.CoursesDAL"></asp:ObjectDataSource>
                        </td>
                    </tr>

                    <tr>
                        <td class="label">
                            الفصل الدراسى
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="DDLSemestersUpdate" runat="server" Width="200px" 
                                DataSourceID="ObjectDataSource5" DataTextField="ArSemesterName" 
                                DataValueField="SemesterId">         
                            </asp:DropDownList>

                        </td>
                    </tr>
                        <tr>
                      <td class="label">
                            عدد المجموعة
                        </td>
                        <td class="input">
                    <asp:TextBox ID="txtgroupnumberupdate" runat="server" Width="200px"></asp:TextBox>
                    </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center" class="button">
                            <asp:Button ID="btnUpdate" runat="server" Text="تعديل" onclick="btnUpdate_Click"/>
                            <asp:Button ID="btnCancel" runat="server" Text="إلغاء" onclick="btnCancel_Click"/>
                        </td>
                    </tr>
                </table>
            </asp:View>

            <asp:View ID="View_SELECT" runat="server">
                
                <table class="style2">
                
                    <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <asp:LinkButton ID="btnNew" runat="server" onclick="btnAddMemberToList_Click"  >اضافة عضو جديد</asp:LinkButton>
                    </td>
                    <td>
                        &nbsp;</td>
                </tr>

                    <tr>

                        <td colspan="2">
                        
                            <asp:GridView ID="GridView_AssignMemberToCourse" runat="server"
                                AutoGenerateColumns="False" AllowPaging="True" 
                                onrowcommand="GridView_AssignMemberToCourse_RowCommand" 
                                DataSourceID="ObjectDataSource2" EnableModelValidation="True">
                                <HeaderStyle  CssClass="HeaderStyle" HorizontalAlign="Right"/>
                                <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                <AlternatingRowStyle  CssClass="AltRowStyle" HorizontalAlign="Right"/>
                                <PagerStyle CssClass="PagerStyle"/>
                                <Columns>
                                    
                                    <asp:TemplateField HeaderText="اسم العضو" ItemStyle-Width="200px">
                                        <ItemTemplate>                                 
                                            <asp:Label ID="MemberName" runat="server" Text='<%# Eval("MemberName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="المادة" ItemStyle-Width="150px">
                                        <ItemTemplate>                                 
                                            <asp:Label ID="ArCourseName" runat="server" Text='<%# Eval("ArCourseName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="الفصل الدراسى" ItemStyle-Width="150px">
                                        <ItemTemplate>                                 
                                            <asp:Label ID="ArSemesterName" runat="server" Text='<%# Eval("ArSemesterName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="القسم" ItemStyle-Width="150px">
                                        <ItemTemplate>                                 
                                            <asp:Label ID="ArDepartmentName" runat="server" Text='<%# Eval("ArDepartmentName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                      <asp:TemplateField HeaderText="العدد" ItemStyle-Width="150px">
                                        <ItemTemplate>                                 
                                            <asp:Label ID="GroupMaximum" runat="server" Text='<%# Eval("GroupMaximum") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="تعديل" ItemStyle-Width="70px">      
                                        <ItemTemplate>             
                                            <asp:LinkButton ID="editLink" runat="server" CommandArgument='<%# Eval("AssignID") %>'
                                                CommandName="rowEdit" CausesValidation="false">تعديل</asp:LinkButton>             
                                        </ItemTemplate>       
                                    </asp:TemplateField>

                                    <%--<asp:TemplateField HeaderText="حذف" ItemStyle-Width="70px">      
                                        <ItemTemplate>             
                                            <asp:LinkButton ID="deleteLink" runat="server" CommandArgument='<%# Eval("ID") %>' OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>'
                                                CommandName="DeleteRow" CausesValidation="false">حذف</asp:LinkButton>             
                                        </ItemTemplate>       
                                    </asp:TemplateField>--%>

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
                            <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" 
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" 
                                TypeName="TeiLib.AssignMemberToCourseDAL"></asp:ObjectDataSource>   
                        </td>
                    </tr>
                
                </table>

            </asp:View>
         <asp:View ID="NoAccess" runat="server">
                <asp:Label ID="lblNoAccess" runat="server" Text="لا يمكنك الدخول للصفحة"  CssClass="label" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                </asp:View>
        </asp:MultiView>
    
  <%--  </ContentTemplate>

</asp:UpdatePanel>--%>

</asp:content>

