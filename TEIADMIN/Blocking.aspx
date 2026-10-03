<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="Blocking.aspx.cs" Inherits="Blocking" Title="..:: حجب نتيجة الطالب ::.."%>

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
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtٍStudentCode"
                                        ErrorMessage="*" InitialValue=""></asp:RequiredFieldValidator>
                                <asp:HiddenField ID="studentId" runat="server"></asp:HiddenField>
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
                    <asp:PlaceHolder ID="addCoursesHolder" runat="server" Visible="false">
                        <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                            <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    سبب الحجب
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="BlockStudents" runat="server"   Width="200px" AutoPostBack="true" AppendDataBoundItems="true" DataSourceID="BlockingTypesDataSource" DataTextField="ArBlockingTypeName" DataValueField="BlockingTypeId">
                                         <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>

                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="stateDDLRequired" runat="server" ControlToValidate="BlockStudents"
                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                    <%--<asp:ObjectDataSource ID="StateDS" runat="serr" SelectMethod="GetAll" TypeName="TeiLib.StatesDAL">
                                    </asp:ObjectDataSource>--%>
                                    <%--<asp:RequiredFieldValidator ID="stateDDLRequired" runat="server" ControlToValidate="stateDDL"
                                        ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>--%>
                                </td>
                            </tr>
                            
                            <tr>
                                <td colspan="2" align="center" class="button">
                                    <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" Text="إضافة" OnClick="btnAdd_Click"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </asp:PlaceHolder>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <asp:ObjectDataSource ID="BlockingTypesDataSource" runat="server" 
                        OldValuesParameterFormatString="{0}" SelectMethod="GetAll" 
                        TypeName="TeiLib.BlockingTypesDAL"></asp:ObjectDataSource>
                   

                    <asp:GridView ID="BlockingGridView" runat="server" AllowPaging="True"  Visible="false"
                        AllowSorting="True"  DataSourceID="BlockedDataSource" 
                        EnableModelValidation="True" AutoGenerateColumns="False" 
                        DataKeyNames="StudentCode" onrowcommand="BlockingGridView_RowCommand">
                        <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>لا يوجد طلاب محجوبين </EmptyDataTemplate>
                        <Columns>
                        <asp:BoundField  DataField="RowId" HeaderText="#" ItemStyle-Width="20px"/>
                        <asp:TemplateField HeaderText ="الكود"  ItemStyle-Width="20px" >
                        <ItemTemplate>
                        <asp:Label ID="StudentCodelbl" runat="server" Width="60px" Text='<%# Eval("StudentCode") %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText ="سبب الحجب"  ItemStyle-Width="250px" >
                        <ItemTemplate>
                        <asp:Label ID="Blocklbl" runat="server" Width="250px" Text='<%# Eval("ArBlockingTypeName") %>'></asp:Label>
                        </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="تعديل" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="editLink" runat="server" CommandArgument='<%# Eval("StudentCode") %>'
                                                    CommandName="rowEdit" CausesValidation="false">تعديل</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="deleteLink" runat="server" CommandArgument='<%# Eval("StudentCode") %>'
                                                    CommandName="rowDelete" CausesValidation="false">حذف</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:ObjectDataSource ID="BlockedDataSource" runat="server" 
                        DataObjectTypeName="TeiLib.Block" DeleteMethod="Delete" 
                        OldValuesParameterFormatString="{0}" SelectMethod="GetBlockingOfStudent" 
                        TypeName="TeiLib.BlockedDAL" UpdateMethod="Update" 
                        ondeleted="DataSourceDeleted">
                        <DeleteParameters>
                            <asp:Parameter Name="StudentCode" Type="String" />
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:ControlParameter ControlID="txtٍStudentCode" Name="StudentCode" 
                                PropertyName="Text" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <br /> 
                  
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