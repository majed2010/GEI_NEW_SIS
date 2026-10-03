<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="StudentsInformationForCards.aspx.cs" Inherits="StudentsInformationForCards" %>

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
                                <asp:HiddenField ID="studentId" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="departmentIdHdn" runat="server"></asp:HiddenField>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:Panel ID="pnlDefaultButton" runat="server" DefaultButton="btnSearch">
                                    <asp:Button ID="btnSearch" runat="server" Text="بحث" OnClick="btnSearch_Click"></asp:Button>
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
                        <tr>
                            <td class="label" style="color: blue">
                                إجمالي المعدل التراكمي
                            </td>
                            <td class="input">
                                <asp:Label ID="lblGPA" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                الساعات المحققة
                            </td>
                            <td class="input">
                                <asp:Label ID="completedHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue">
                                الساعات المسجلة
                            </td>
                            <td class="input">
                                <asp:Label ID="registeredHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="label" style="color: blue; height: 28px;">
                                الساعات المتبقية
                            </td>
                            <td class="input" style="height: 28px">
                                <asp:Label ID="restHours" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
</asp:Content>

