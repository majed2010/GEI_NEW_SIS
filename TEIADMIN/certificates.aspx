<%@ Page  Language="C#" MasterPageFile="layout.master" AutoEventWireup="true" CodeFile="certificates.aspx.cs" Inherits="certificates" Title=".:: الشهادات ::."%>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    الشهادات
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="PagePanel" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="540px">
                        <tr>
                            <td>
                                <asp:FormView ID="CertificateForm" runat="server" OnItemInserted="CertificateForm_ItemInserted" DataSourceID="FormDataSource"
                                    OnItemUpdated="CertificateForm_ItemUpdated" DataKeyNames="CertificateId" Width="100%" OnModeChanging="CertificateForm_ModeChanging">
                                    <EditItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="3">
                                                    <h4>
                                                        تعديل الشهادات</h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم الشهادة بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArActName" runat="server" Columns="25" Text='<%# Bind("ArCertificateName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ErrorMessage="*" ControlToValidate="txtArActName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم الشهادة بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtSize" runat="server" Columns="25" Text='<%# Bind("CertificateName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="txtSizeRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtSize" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="تعديل" CommandName="Update"
                                                        ValidationGroup="grp1" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        Text="إلغاء" CommandName="Cancel" />
                                                </td>
                                            </tr>
                                        </table>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="3">
                                                    <h4>
                                                        إضافة شهادة جديدة</h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم الشهادة بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArActName" runat="server" Columns="25" Text='<%# Bind("ArCertificateName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ErrorMessage="*" ControlToValidate="txtArActName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم الشهادة بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtSize" runat="server" Columns="25" Text='<%# Bind("CertificateName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="txtSizeRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtSize" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="إضافة" CommandName="Insert"
                                                        ValidationGroup="grp1" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        Text="إلغاء" CommandName="Cancel" />
                                                </td>
                                            </tr>
                                        </table>
                                    </InsertItemTemplate>
                                </asp:FormView>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 5px">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:Label ID="submitErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">خطأ أثناء الإضافة.</asp:Label>
                                            <asp:Label ID="TitleErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">This Title already exists.</asp:Label>
                                            <asp:Label ID="updateErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">خطأ أثناء التعديل</asp:Label>
                                        </td>
                                        <td align="right">
                                            <asp:LinkButton ID="lnkBack2" runat="server" CausesValidation="false" OnClick="lnkBack_Click">رجوع</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </asp:View>
                <asp:View ID="ListView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="610px">
                        <tr>
                            <td colspan="3">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" Style="direction: ltr;
                                                padding-bottom: 20px" OnClick="btnAdd_Click">أضف شهادة جديدة</asp:LinkButton><%----%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdCertificates" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdCertificates_RowDeleted" OnSelectedIndexChanged="grdCertificates_SelectedIndexChanged"
                                    DataKeyNames="CertificateId" OnDataBound="grdCertificates_DataBound" DataSourceID="CertificatesObjectDataSource">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد شهادات مضافة</div>
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#"></asp:BoundField>
                                        <asp:TemplateField HeaderText="اخفاء" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="CkHide" runat="server" Checked='<%# Eval("Hide") %>' />
                                                <asp:CheckBox ID="CKOld" runat="server" Checked='<%# Eval("Hide") %>' Visible="False" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ArCertificateName" HeaderText="اسم الشهادة" SortExpression="ArCertificateName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <%--<asp:HyperLinkField DataNavigateUrlFields="ProductId" DataNavigateUrlFormatString="productsGallery.aspx?ProductId={0}"
                                    HeaderText="Gallery" Text="Gallery" HeaderStyle-Width="70" />--%>
                                        <asp:ButtonField CommandName="Select" HeaderText="تعديل" Text="تعديل" HeaderStyle-Width="70px"
                                            ItemStyle-Width="50px" />
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False"
                                                    CommandName="Delete" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' />
                                            </ItemTemplate>
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
                            <td style="padding-right: 78px">
                                <asp:LinkButton CausesValidation="False" CssClass="linkbtn" ID="btnUpdate" runat="server"
                                    ToolTip="Update Hide Values" OnClick="btnUpdate_Click">تحديث</asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                                    Visible="False">خطأ أثناء الحذف.</asp:Label>
                            </td>
                            <td align="left">
                                <asp:LinkButton ID="btnAdd1" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click">أضف شهادة جديدة</asp:LinkButton>
                                <%----%>
                            </td>
                        </tr>
                    </table>
                    <asp:ObjectDataSource ID="FormDataSource" runat="server" DataObjectTypeName="TeiLib.Certificate"
                        InsertMethod="Insert" SelectMethod="GetById" TypeName="TeiLib.CertificatesDAL"
                        UpdateMethod="Update">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="grdCertificates" Name="CertificateId" PropertyName="SelectedValue"
                                Type="Int32" />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Certificate" Type="Object" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                    <asp:ObjectDataSource ID="CertificatesObjectDataSource" runat="server" DeleteMethod="Delete"
                        SelectMethod="GetByPage" SelectCountMethod="GetRowsCount" TypeName="TeiLib.CertificatesDAL"
                        EnablePaging="true" OnDeleted="DataSourceDeleted">
                        <DeleteParameters>
                            <asp:Parameter Name="CertificateId" Type="Int32" />
                        </DeleteParameters>
                    </asp:ObjectDataSource>
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

