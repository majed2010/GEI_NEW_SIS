<%@ Page Language="C#" MasterPageFile="layout.master" AutoEventWireup="true" CodeFile="Assign_Visitors_To_students.aspx.cs"
    Inherits="Assign_Visitors_To_students" Title=".:: تعيين زائر الى طالب ::." %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
     تعيين زائر الى طالب
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
           <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="0" >
                <asp:View ID="View_Grid" runat="server" >
           <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" align="right">
               
                <tr>
                    <td class="label" style="color: blue">
                        كود الطالب
                    </td>
                    <td class="input">
                        <asp:HiddenField ID="HiddenField1" runat="server" />
                        <asp:TextBox ID="txtٍStudentCode" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center" class="button">
                        <asp:Panel ID="pnlDefaultButton" runat="server" DefaultButton="btnSearch">
                            <asp:Button ID="btnSearch" runat="server" Text="بحث" OnClick="btnSearch_Click"></asp:Button>
                        </asp:Panel>
                    </td>
                </tr>
               
            </table>
           <div style="clear: both;">
            </div>
            <br />
            <br />
                    <table cellpadding="0" cellspacing="0" border="0" width="610px">
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grd_stu_rooms" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" EmptyDataText = "لا يوجد طلبه مضافه الى غرف" 
                                    onpageindexchanging="grd_stu_rooms_PageIndexChanging" 
                                    onrowcommand="grd_stu_rooms_RowCommand" 
                                    onrowupdating="grd_stu_rooms_RowUpdating" 
                                    onrowdeleting="grd_stu_rooms_RowDeleting">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <Columns>
                                        <%--<asp:HyperLinkField DataNavigateUrlFields="ProductId" DataNavigateUrlFormatString="productsGallery.aspx?ProductId={0}"
                                    HeaderText="Gallery" Text="Gallery" HeaderStyle-Width="70" />--%>
                                        <asp:BoundField DataField="StudentCode" HeaderText="كود الطالب" SortExpression="ArSchoolName"
                                            HeaderStyle-HorizontalAlign="Right" >
                                            <HeaderStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                         <asp:BoundField DataField="Student_name" HeaderText="اسم الطالب" SortExpression="Student_name"
                                            HeaderStyle-HorizontalAlign="Right" >
                                            <HeaderStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                         <asp:BoundField DataField="Visitor_Name" HeaderText="اسم الزائر"  SortExpression="Room_No"
                                            HeaderStyle-HorizontalAlign="Right" >
                                            <HeaderStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                         <asp:BoundField DataField="Visitor_Relation" HeaderText="صلة القرابة"  SortExpression="Room_No"
                                            HeaderStyle-HorizontalAlign="Right" >
                                            <HeaderStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        
                                        
                                        <asp:TemplateField HeaderText="تعديل">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="LinkButton1" runat="server" CommandArgument="<%# bind('Visitor_Student_Id') %>"
                                                CommandName="Update" >تعديل</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False"
                                                    CommandName="Delete" 
                                                    OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")" %>' 
                                                    CommandArgument="<%# bind('Visitor_Student_Id') %>" />
                                            </ItemTemplate>
                                            <ItemStyle Width="50px" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 7px">
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <asp:LinkButton ID="btnAdd1" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click">أضف طالب لغرفه</asp:LinkButton>
                                <%----%>
                            </td>
                        </tr>
                    </table>
                 </asp:View>
                 <asp:View ID  = "Insert_view" runat = "server" >
                         <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="2">
                                                    <h4>
                                                        اضافة زائر لطالب</h4>
                                                </td>
                                            </tr>
                                           <tr>
                                                <td class="label">
                                                    كود الطالب
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="TextBox1" runat="server" AutoPostBack = "true" 
                                                        ontextchanged="TextBox1_TextChanged"></asp:TextBox>
                                                 </td>
                                                 
                                            </tr>
                                           <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:Label ID="lbl_student_name" runat="server" Font-Bold="True" Font-Size="Medium"></asp:Label>
                                            </td>
                                           </tr>
                                            <tr>
                                                <td class="label">
                                                   اسم الزائر
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="ddr_visitors" runat="server" 
                                                       Width="150px">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                        ControlToValidate="ddr_visitors" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                   صلة القرابه
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txt_relation" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txt_relation" ValidationGroup="grp1" ></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                              
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="حفظ" CommandName="Update"
                                                        ValidationGroup="grp1" onclick="btnSubmit_Click" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        Text="إلغاء" CommandName="Cancel" onclick="btnCancel_Click" />
                                                </td>
                                            </tr>
                                        </table>
                 </asp:View>
                 </asp:MultiView>
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
