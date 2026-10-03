<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="StudentsMilitary.aspx.cs"
    Inherits="StudentsMilitary" Title="..:: التربية العسكرية ::.." %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="advisingPanel" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="0">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" align="right">
                        <tr>
                            <td class="label" style="color: blue">
                                كود الطالب
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtٍStudentCode" runat="server"></asp:TextBox>
                                <asp:HiddenField ID="studentId" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="deptId" runat="server"></asp:HiddenField>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:Panel ID="pnlDefaultButton" runat="server" DefaultButton="btnSearch">
                                    <asp:Button ID="btnSearch" runat="server" Text="بحث" OnClick="btnSearch_Click" CausesValidation="false">
                                    </asp:Button>
                                </asp:Panel>
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
                            <td class="label" style="color: blue">
                                المستوى
                            </td>
                            <td class="input">
                                <asp:Label ID="lblLevel" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <div style="padding-top: 10px; clear: both;">
                    </div>
                    <br />
                    <br />
                    <br />
                    <br />
                    <asp:PlaceHolder ID="addCoursesHolder" runat="server">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    الدورة
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="MilitaryDDL" runat="server" DataSourceID="MilitaryDS" DataValueField="MilitaryEducationId"
                                    DataTextField="MilitaryEducationName" AppendDataBoundItems="True" Width="200px">
                                    <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfdMilitaryDDL" runat="server" ErrorMessage="*" ForeColor="Red" ControlToValidate="MilitaryDDL"></asp:RequiredFieldValidator>
                                <asp:ObjectDataSource ID="MilitaryDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.MilitaryEducationDAL">
                                </asp:ObjectDataSource>
                                </td>
                            </tr>
                             <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    العام الدراسي
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="YearDDL" runat="server" DataSourceID="YearDS" DataValueField="YearId"
                                    DataTextField="YearName" AppendDataBoundItems="True" Width="200px" >
                                  
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="YearDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                </asp:ObjectDataSource>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="btnUpdate" runat="server" CssClass="linkbtn" Text="حفظ" OnClick="btnUpdate_Click"></asp:LinkButton>
                                </td>
                            </tr>
                            <tr>
                            <td colspan="2">
                             <asp:GridView ID="MilitaryGridView" runat="server" AllowPaging="True"  Visible="false"
                        AllowSorting="True"  DataSourceID="MilitaryDataSource" 
                        EnableModelValidation="True" AutoGenerateColumns="False" 
                        DataKeyNames="Id" onrowcommand="MilitaryGridView_RowCommand">
                        <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>لا يوجد طلاب محجوبين </EmptyDataTemplate>
                        <Columns>
                        <asp:BoundField  DataField="RowId" HeaderText="#" ItemStyle-Width="20px"/>
                        <asp:TemplateField HeaderText ="الكود"  ItemStyle-Width="100px" >
                        <ItemTemplate>
                        <asp:Label ID="StudentCodelbl" runat="server" Width="100px" Text='<%# Eval("StudentCode") %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText ="اسم الدورة"  ItemStyle-Width="250px" >
                        <ItemTemplate>
                        <asp:Label ID="lblMilitaryEdu" runat="server" Width="250px" Text='<%# Eval("MilitaryEducationName") %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText ="العام الدراسي"  ItemStyle-Width="250px" >
                        <ItemTemplate>
                        <asp:Label ID="lblYear" runat="server" Width="250px" Text='<%# Eval("YearName") %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="ناجح او راسب" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                       <asp:LinkButton ID="btnActive" runat="server" Text='<%# Eval("Finished").ToString() == "True" ? "ناجح" : "راسب"  %>'
                                                            CausesValidation="False"
                                                                CommandName="ActiveCourse" CommandArgument='<%# Eval("Id") %>' />     
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="deleteLink" runat="server" CommandArgument='<%# Eval("Id") %>'
                                                    CommandName="rowDelete" CausesValidation="false">حذف</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="MilitaryDataSource" runat="server" 
                        OldValuesParameterFormatString="{0}" SelectMethod="GetMilitaryOfStudent" DeleteMethod="Delete"
                        TypeName="TeiLib.StudentsMilitaryEducationDAL" >
                         <DeleteParameters>
                            <asp:Parameter Name="MilitaryEducationId" Type="Int32" />
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:ControlParameter ControlID="txtٍStudentCode" Name="StudentCode" 
                                PropertyName="Text" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                            </td>
                            </tr>
                      </table>
                    </asp:PlaceHolder>
                 
                   
                 
                   
                      
                    
                </asp:View>
                <asp:View ID="NoAccessView" runat="server">
                    <h2 id="noAccess">
                        غير مسموح لك دخول هذه الصفحة</h2>
                </asp:View>
            </asp:MultiView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="LoadingProgress" runat="server">
        <ProgressTemplate>
            <div id="progressFilter">
            </div>
            <div id="progressMessage">
                Processing... &nbsp;
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
