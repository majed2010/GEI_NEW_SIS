<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="ExamDataTimes.aspx.cs" Inherits="ExamDataTimes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" Runat="Server">
    <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" align="right">
                        <tr>
                            <td class="label" style="color: blue">
                                كود الطالب
                            </td>
                            <td class="input">
                             <asp:TextBox ID="txtStudentCode" runat="server"></asp:TextBox>
                                <asp:HiddenField ID="hdnStudentCode" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="studentId" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="departmentIdHdn" runat="server"></asp:HiddenField>
                                 <asp:HiddenField ID="hdnExpensesId" runat="server"></asp:HiddenField>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                الاسم
                            </td>
                            <td class="label">
                                <asp:Label ID="lblFullName" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                القسم
                            </td>
                            <td class="input">
                                <asp:Label ID="lblDept" runat="server"></asp:Label>
                            </td>
                        </tr>
                   <tr>
                   <td colspan="2" align="center">
                   <asp:Button ID="btnSearch" runat="server" Text="بحث" Width="100px" onclick="btnSearch_Click" />
                   </td>
                   </tr>
                    </table>
<table class="style2">
                
                <tr>
                <td >
                </td>
                </tr>
       
                <tr>
                    <td colspan="2">
                        <asp:HiddenField ID="hdnStudentId" runat="server" />
                        <asp:GridView ID="grvRequests" runat="server" 
                            AutoGenerateColumns="False" AllowPaging="True"   
                            DataSourceID="ObjectDataSource1"  >
                            
                            <HeaderStyle  CssClass="HeaderStyle" HorizontalAlign="Right"/>
                            <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                            <AlternatingRowStyle  CssClass="AltRowStyle" HorizontalAlign="Right"/>
                            <PagerStyle CssClass="PagerStyle"/>
                            <Columns>
                        <asp:BoundField HeaderText="اسم المادة" DataField="CourseName"  />
                        <asp:BoundField HeaderText="رقم الجلوس" DataField="SetNumber"  />
                        <asp:BoundField HeaderText="مكان الامتحان" DataField="ExamPlace"  />
                        <asp:BoundField HeaderText="اللجنة" DataField="board"  />
                        <asp:BoundField HeaderText="اليوم" DataField="ExamDay"  />
                        <asp:BoundField HeaderText="التاريخ" DataField="ExamDate"  DataFormatString="{0:dd/MM/yyyy}"/>
                        <asp:BoundField HeaderText="من" DataField="TimeFrom"  />
                        <asp:BoundField HeaderText="إلى" DataField="TimeTo"  />

                                  
                            </Columns>
                            <EmptyDataTemplate>
                            <div>
                          برجاء مراجعة شئون الطلاب
                            </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                        
                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
                             OldValuesParameterFormatString="original_{0}" 
                            SelectMethod="GetStudentExamDate_ByStudentCode" TypeName="TeiLib.StudentsDAL" 
                           >
                          
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hdnStudentId" Name="StudentId" 
                                    PropertyName="Value" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        
                    </td>
                </tr>
                <tr>
                <td>
                <asp:Button runat="server" ID="btnPrint" Text="طباعة جدول الامتحانات"   OnClientClick="javascript:window.print();"/>
                </td>
                </tr>
                
            </table>
</asp:Content>

