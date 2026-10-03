<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="StudentsSurveyGeneralResult.aspx.cs" Inherits="StudentsSurveyGeneralResult" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" runat="Server">

   <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server">

        <ContentTemplate>--%>

            <asp:MultiView ID="MultiView_SurveyResult" runat="server" ActiveViewIndex="0">

                <asp:View ID="View_CourseList" runat="server">

                    <table class="form" width="100%">
                        <tr>
                            <td class="input">
                                <asp:DropDownList ID="ddlCourses" runat="server" Width="200px"  AppendDataBoundItems="true"
                                
                                DataSourceID="ObjectDataSource2" DataTextField="ArCourseName" DataValueField="CourseId" AutoPostBack="True" OnSelectedIndexChanged="ddlCourses_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Enabled="true" Text="---اختر---" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" TypeName="TeiLib.CoursesDAL"></asp:ObjectDataSource>
                            </td>
                        </tr>
                    </table>

                </asp:View>

                <asp:View ID="View_Result" runat="server">
                <table style="height: 189px; width: 950px; background-color: #99CCFF;"  >

                <tr>
                    <td class="label" style="width: 100px">
                    <asp:Label ID="lblYearNAme" runat="server" Text="السنة الدراسية : " ></asp:Label> </td>
                    <td class="label">
                    <asp:Label ID="lblYear" runat="server" ></asp:Label>
                    </td>
                
                    <td class="label" style="width: 80px">
                     <asp:Label ID="Label7" runat="server" Text="الفصل الدراسى : " CssClass="label"></asp:Label></td>
                     <td class="label" style="width: 180px">
                      <asp:Label ID="lblClass" runat="server"   ></asp:Label>
                    </td>
                  
                 
                    <td class="label" style="width: 80px">
                     </td>
                     <td class="label" style="width: 120px">
                         <asp:Label ID="lblBranch" runat="server"  CssClass="label"></asp:Label>
                    </td>
                   
                </tr>
             
                        
                <tr>
                    <td class="label">
                    
                    </td>
                     <td class="label">
                     
                    </td>
                    
                
                    <td class="label" style="width: 140px">
                     </td>
                    <td class="label" style="width: 180px">
                   
                    </td>
                
                </tr>
                
                 <tr>
                    <td class="label">
                   
                    </td>
                     <td class="label">
                     
                    </td>
                    
                
                    <td class="label" style="width: 140px">
                    <asp:Label ID="Label11" runat="server" Text="عدد الطلاب الذين قاموا بعمل الاستبيان : "></asp:Label> </td>
                    <td class="label" style="width: 180px">
                          <asp:Label ID="lblCountSurvey" runat="server" Text="" CssClass="lbl"></asp:Label>
                    </td>
                
                </tr>

            </table>


                    <table class="form" width="100%">

                        <tr>
                            <td colspan="8">
                                <asp:GridView ID="GridView_FacultyMembersItems" runat="server"
                                    AutoGenerateColumns="False"
                                    DataSourceID="ObjectDataSource1" Width="730px" OnRowDataBound="GridView_FacultyMembersItems_RowDataBound" ShowFooter="True">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="center" Font-Size="12px" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="center" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="center" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <FooterStyle Height="30px" HorizontalAlign="center" VerticalAlign="Middle" />
                                    <Columns>

                                        <asp:TemplateField HeaderText="أعضاء هيئة التدريس" ItemStyle-Width="400px">
                                            <ItemTemplate>
                                                <asp:Label ID="lblItemText" runat="server" Text='<%# Eval("SurveyItemText") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Right" Width="400px" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="ممتاز">
                                            <ItemTemplate>
                                                <asp:Label ID="lblExcellent" runat="server" Text='<%# Eval("Excellent") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="جيد جدا">
                                            <ItemTemplate>
                                                <asp:Label ID="lblVeryGood" runat="server" Text='<%# Eval("VeryGood") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="جيد">
                                            <ItemTemplate>
                                                <asp:Label ID="lblGood" runat="server" Text='<%# Eval("Good") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="مقبول">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAcceptable" runat="server" Text='<%# Eval("Acceptable") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="ضعيف">
                                            <ItemTemplate>
                                                <asp:Label ID="lblWeak" runat="server" Text='<%# Eval("Weak") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="CalculateSurveyItemsGeneral" TypeName="TeiLib.StudentsSurveyDAL">
                                    <SelectParameters>
                                        
                                        <asp:Parameter DefaultValue="41" Name="SemesterId" Type="Int32" />
                                        <asp:Parameter DefaultValue="6" Name="SurveyItemType" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>

                            </td>

                        </tr>
                        
                        <tr>
                            <td class="label" colspan="1">
                                <asp:Label ID="Label1" runat="server" Text="متوسط تقييم الأستبيان" Visible="true"></asp:Label>
                            </td>
                            <td class="label">
                                <asp:Label ID="lblMemberAVG" runat="server" Text="" Visible="true"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td class="label" colspan="1">
                                <asp:Label ID="Label2" runat="server" Text="تقدير  الأستبيان" Visible="true"></asp:Label>
                            </td>
                            <td class="label">
                                <asp:Label ID="lblMemberGradeName" runat="server" Text="" Visible="true"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="8">
                          
                            </td>

                        </tr>

                        

                        <tr>
                            <td colspan="8">
                          
                            </td>

                        </tr>

                        
                        <tr>
                        <td align="center" class="button" colspan="2">
                        <asp:Button ID="btnDone" runat="server" Text="تم" onclick="btnDone_Click" />
                        
                        </td>
                        </tr>
                    </table>

                </asp:View>
                <asp:View ID="NoAccess" runat="server">
                <asp:Label ID="lblNoAccess" runat="server" Text="لا يمكنك الدخول للصفحة"  CssClass="label" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                </asp:View>
            </asp:MultiView>

<%--        </ContentTemplate>

    </asp:UpdatePanel>--%>

</asp:Content>

