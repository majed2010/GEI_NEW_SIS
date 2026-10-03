<%@ Page Language="C#" MasterPageFile="layout.master" AutoEventWireup="true" CodeFile="locations.aspx.cs"
    Inherits="locations" Title=".:: البلاد - المدن - المناطق ::." %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    البلاد - المدن - المناطق
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:UpdatePanel ID="PagePanel" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="540px">
                        <tr>
                            <td>
                                <asp:RadioButtonList ID="LocationschkList" runat="server" OnSelectedIndexChanged="LocationschkList_SelectedIndexChanged"
                                    AutoPostBack="true" RepeatDirection="Horizontal" CssClass="form">
                                    <asp:ListItem Value="0" Text="بلد" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="مدينة"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="منطقة"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:FormView ID="LocationForm" runat="server" OnItemInserted="LocationForm_ItemInserted"
                                    OnItemInserting="LocationForm_ItemInserting" DataSourceID="FormDataSource" OnItemUpdated="LocationForm_ItemUpdated"
                                    DataKeyNames="LocationId" Width="100%" OnModeChanging="LocationForm_ModeChanging">
                                    <EditItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="6">
                                                    <h4>
                                                        تعديل البلدان</h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    الدولة / المدينة:
                                                </td>
                                                <td class="input">
                                                    <asp:Label ID="parentNameTxt" runat="server" Columns="25" Text='<%# Bind("ParentName") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم المكان بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArActName" runat="server" Columns="25" Text='<%# Bind("ArLocationName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ErrorMessage="*" ControlToValidate="txtArActName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم المكان بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtSize" runat="server" Columns="25" Text='<%# Bind("LocationName") %>'></asp:TextBox>
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
                                                <td colspan="4">
                                                    <h4>
                                                        إضافة موقع جديد</h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم المكان بالعربية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtArActName" runat="server" Columns="25" Text='<%# Bind("ArLocationName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="TitleRequired" runat="server" ErrorMessage="*" ControlToValidate="txtArActName"
                                                        ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    اسم المكان بالانجليزية
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtSize" runat="server" Columns="25" Text='<%# Bind("LocationName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="txtSizeRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtSize" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <asp:PlaceHolder ID="CountryHolder" runat="server" Visible="false">
                                                <tr>
                                                    <td class="label">
                                                        اسم البلد
                                                    </td>
                                                    <td class="input">
                                                        <asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true" DataTextField="ArLocationName"
                                                            DataValueField="LocationId">
                                                            <asp:ListItem Value="0">--- Select ---</asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*"
                                                            ControlToValidate="ddlCountry" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                            </asp:PlaceHolder>
                                            <asp:PlaceHolder ID="CityHolder" runat="server" Visible="false">
                                                <tr>
                                                    <td class="label">
                                                        اسم المدينة
                                                    </td>
                                                    <td class="input">
                                                        <asp:DropDownList ID="ddlCity" runat="server" AppendDataBoundItems="true" DataTextField="ArLocationName"
                                                            DataValueField="LocationId">
                                                            <asp:ListItem Value="0">--- Select ---</asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*"
                                                            ControlToValidate="ddlCity" ValidationGroup="grp1" InitialValue="0"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                            </asp:PlaceHolder>
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
                                <asp:ObjectDataSource ID="LocationsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LocationsDAL">
                                    <SelectParameters>
                                        <asp:Parameter Name="type" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
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
                    <asp:RadioButtonList ID="LocationsChoices" runat="server" AutoPostBack="true" RepeatDirection="Horizontal"
                        CssClass="form">
                        <asp:ListItem Value="1" Text="بلاد" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="2" Text="مدن"></asp:ListItem>
                        <asp:ListItem Value="3" Text="مناطق"></asp:ListItem>
                    </asp:RadioButtonList>
                    <table cellpadding="0" cellspacing="0" border="0" width="610px">
                        <tr>
                            <td colspan="3">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" Style="direction: ltr;
                                                padding-bottom: 20px" OnClick="btnAdd_Click">أضف جديد</asp:LinkButton><%----%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdLocations" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdLocations_RowDeleted" OnSelectedIndexChanged="grdLocations_SelectedIndexChanged"
                                    DataKeyNames="LocationId" OnDataBound="grdLocations_DataBound" DataSourceID="LocationObjectDataSource">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد مواقع مضافة</div>
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#" ItemStyle-Width="30px"></asp:BoundField>
                                        <asp:TemplateField HeaderText="اخفاء" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="CkHide" runat="server" Checked='<%# Eval("Hide") %>' />
                                                <asp:CheckBox ID="CKOld" runat="server" Checked='<%# Eval("Hide") %>' Visible="False" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ArLocationName" HeaderText="المكان" SortExpression="ArLocationName"
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
                            <td style="padding-right: 35px">
                                <asp:LinkButton CausesValidation="False" ID="btnUpdate" runat="server" ToolTip="Update Hide Values"
                                    OnClick="btnUpdate_Click">تحديث</asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                                    Visible="False">خطأ أثناء الحذف.</asp:Label>
                            </td>
                            <td align="left">
                                <asp:LinkButton ID="btnAdd1" runat="server" OnClick="btnAdd_Click">أضف جديد</asp:LinkButton>
                                <%----%>
                            </td>
                        </tr>
                    </table>
                    <asp:ObjectDataSource ID="FormDataSource" runat="server" DataObjectTypeName="TeiLib.Location"
                        InsertMethod="Insert" SelectMethod="GetById" TypeName="TeiLib.LocationsDAL" UpdateMethod="Update">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="grdLocations" Name="LocationId" PropertyName="SelectedValue"
                                Type="Int32" />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Year" Type="Object" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                    <asp:ObjectDataSource ID="LocationObjectDataSource" runat="server" DeleteMethod="Delete"
                        SelectMethod="GetByPage" SelectCountMethod="GetRowsCount" TypeName="TeiLib.LocationsDAL"
                        EnablePaging="true" OnDeleted="DataSourceDeleted">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="LocationsChoices" PropertyName="SelectedValue" Name="type"
                                Type="Int32" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:Parameter Name="LocationId" Type="Int32" />
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
                <img src="images/18-0.gif" border="0" align="middle" />
                <img src="images/18-0.gif" border="0" align="middle" />
                <img src="images/18-0.gif" border="0" align="middle" />
                <img src="images/18-0.gif" border="0" align="middle" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
