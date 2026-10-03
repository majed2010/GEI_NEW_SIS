<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="users.aspx.cs"
    Inherits="admin_users" Title="::.. Users ..::" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="PageTitle" runat="Server">
    المستخدمين
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">

    <script language="javascript">
        function validateSection(sender, args) {
            var role = document.getElementById('ctl00_BodyPlaceHolder_Userform_Sections');
            if (role.selectedIndex == 2 && args.Value == "")
                args.IsValid = false;
            else
                args.IsValid = true;
        }
    </script>

    <asp:UpdatePanel ID="PagePanel" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="380px">
                        <tr>
                            <td align="right" colspan="2" style="height: 17px">
                                <asp:LinkButton ID="lnkBack" runat="server" CausesValidation="false" OnClick="lnkBack_Click">Back To List</asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:FormView ID="Userform" runat="server" OnItemInserted="Userform_ItemInserted"
                                    DataSourceID="FormDataSource" OnItemUpdated="Userform_ItemUpdated" OnItemUpdating="Userform_ItemUpdating"
                                    DataKeyNames="UserId" OnItemInserting="Userform_ItemInserting" Width="100%" OnModeChanging="Userform_ModeChanging"
                                    OnDataBound="Userform_DataBound">
                                    <EditItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="2" class="formheader">
                                                    Edit User
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" width="22%">
                                                    First Name
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtFirstName" runat="server" Columns="25" Text='<%# Bind("FirstName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtFirstName" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    Last Name
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtLastName" runat="server" Columns="25" Text='<%# Bind("LastName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtLastName" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    Email
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtEmail" runat="server" Columns="25" Text='<%# Bind("Email") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="txtEmail"
                                                        ErrorMessage="*" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="EmailRegularExpression" runat="server" ControlToValidate="txtEmail"
                                                        ErrorMessage="Invalid Email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                                        ValidationGroup="grp1"></asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                             <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            القسم
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:DropDownList ID="depts" runat="server" DataSourceID="deptsDS" DataValueField="DepartmentId"
                                                DataTextField="ArDepartmentName" AppendDataBoundItems="True" Width="200px" AutoPostBack="true"
                                                SelectedValue='<%# Bind("DepartmentId") %>'>
                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:ObjectDataSource ID="deptsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.DepartmentsDAL">
                                            </asp:ObjectDataSource>
                                            <%--<asp:RequiredFieldValidator ID="departmentsRequired" runat="server" ControlToValidate="departments"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>--%>
                                        </td>
                                    </tr>
                                            <tr>
                                                <td class="label">
                                                    User Name
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtUserName" runat="server" Columns="25" Text='<%# Bind("UserName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtUserName" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    Password
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtPassword" runat="server" Columns="25" TextMode="Password"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    RoleId
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="Role" runat="server" SelectedValue='<%# Bind("RoleId") %>'>
                                                        <asp:ListItem Value="0">-- Choose Role --</asp:ListItem>
                                                        <asp:ListItem Value="1">Administrator</asp:ListItem>
                                                        <asp:ListItem Value="2">ُData Entry</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:CompareValidator ID="RoleRequired" runat="server" ControlToValidate="Role" Operator="NotEqual"
                                                        Type="Integer" ValueToCompare="0" SetFocusOnError="true" Text="*" ValidationGroup="grp1"></asp:CompareValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    Sections
                                                </td>
                                                <td class="input">
                                                    <asp:ListBox ID="Sections" runat="server" DataSourceID="SectionsDS" SelectionMode="Multiple"
                                                        DataTextField="aSectionName" DataValueField="SectionId" Rows="5" Width="250px">
                                                    </asp:ListBox>
                                                    <asp:CustomValidator ID="SectionRequired" runat="server" Display="Dynamic" ControlToValidate="Sections"
                                                        Text="Select at least 1 section" ClientValidationFunction="validateSection" SetFocusOnError="true"
                                                        ValidateEmptyText="true" ValidationGroup="grp1"></asp:CustomValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="Update" CommandName="Update"
                                                        CommandArgument='<%# Bind("Password") %>' ValidationGroup="grp1" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        CommandName="Cancel" Text="Cancel" />
                                                </td>
                                            </tr>
                                        </table>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="2" class="formheader">
                                                    Add New User
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" width="22%">
                                                    First Name
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtFirstName" runat="server" Columns="25" Text='<%# Bind("FirstName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtFirstName" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    Last Name
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtLastName" runat="server" Columns="25" Text='<%# Bind("LastName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtLastName" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    Email
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtEmail" runat="server" Columns="25" Text='<%# Bind("Email") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="txtEmail"
                                                        ErrorMessage="*" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="EmailRegularExpression" runat="server" ControlToValidate="txtEmail"
                                                        ErrorMessage="Invalid Email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                                        ValidationGroup="grp1"></asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
 <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            القسم
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:DropDownList ID="depts" runat="server" DataSourceID="deptsDS" DataValueField="DepartmentId"
                                                DataTextField="ArDepartmentName" AppendDataBoundItems="True" Width="200px" AutoPostBack="true"
                                                SelectedValue='<%# Bind("DepartmentId") %>'>
                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:ObjectDataSource ID="deptsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.DepartmentsDAL">
                                            </asp:ObjectDataSource>
                                            <%--<asp:RequiredFieldValidator ID="departmentsRequired" runat="server" ControlToValidate="departments"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>--%>
                                        </td>
                                    </tr>
                                            <tr>
                                                <td class="label">
                                                    User Name
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtUserName" runat="server" Columns="25" Text='<%# Bind("UserName") %>'></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtUserName" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    Password
                                                </td>
                                                <td class="input">
                                                    <asp:TextBox ID="txtPassword" runat="server" Columns="25" Text='<%# Bind("Password") %>'
                                                        TextMode="Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ErrorMessage="*"
                                                        ControlToValidate="txtPassword" ValidationGroup="grp1"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    RoleId
                                                </td>
                                                <td class="input">
                                                    <asp:DropDownList ID="Role" runat="server" SelectedValue='<%# Bind("RoleId") %>'>
                                                        <asp:ListItem Value="0">-- Choose Role --</asp:ListItem>
                                                        <asp:ListItem Value="1">Administrator</asp:ListItem>
                                                        <asp:ListItem Value="2">ُData Entry</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:CompareValidator ID="RoleRequired" runat="server" ControlToValidate="Role" Operator="NotEqual"
                                                        Type="Integer" ValueToCompare="0" SetFocusOnError="true" Text="*" ValidationGroup="grp1"></asp:CompareValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label">
                                                    Sections
                                                </td>
                                                <td class="input">
                                                    <asp:ListBox ID="Sections" runat="server" DataSourceID="SectionsDS" SelectionMode="Multiple"
                                                        DataTextField="SectionName" DataValueField="SectionId" Rows="5" Width="120px">
                                                    </asp:ListBox>
                                                    <asp:CustomValidator ID="SectionRequired" runat="server" Display="Dynamic" ControlToValidate="Sections"
                                                        Text="Select at least 1 section" ClientValidationFunction="validateSection" SetFocusOnError="true"
                                                        ValidateEmptyText="true" ValidationGroup="grp1"></asp:CustomValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="Submit" CommandName="Insert"
                                                        ValidationGroup="grp1" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        CommandName="Cancel" Text="Cancel" />
                                                </td>
                                            </tr>
                                        </table>
                                    </InsertItemTemplate>
                                </asp:FormView>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-top: 5px">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:Label ID="submitErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">An error occurred, could not submit user.</asp:Label>
                                            <asp:Label ID="UserErr" runat="server" CssClass="error" EnableViewState="False" Visible="False">This user name already exists.</asp:Label>
                                            <asp:Label ID="EmailErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">This email already exists.</asp:Label>
                                            <asp:Label ID="updateErr" runat="server" CssClass="error" EnableViewState="False"
                                                Visible="False">An error occurred, could not update user.</asp:Label>
                                        </td>
                                        <td align="right">
                                            <asp:LinkButton ID="lnkBack2" runat="server" CausesValidation="false" OnClick="lnkBack_Click">Back To List</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <asp:ObjectDataSource ID="FormDataSource" runat="server" DataObjectTypeName="TeiLib.User"
                        DeleteMethod="Delete" InsertMethod="Insert" SelectMethod="GetById" TypeName="TeiLib.UsersDAL"
                        UpdateMethod="Update">
                        <DeleteParameters>
                            <asp:Parameter Name="UserId" Type="Int32" />
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:ControlParameter ControlID="grdUsers" Name="UserId" PropertyName="SelectedValue"
                                Type="Int32" />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:Parameter Name="usr" Type="Object" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                </asp:View>
                <asp:View ID="ListView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="600px">
                        <tr>
                            <td colspan="3">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="btnAdd" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click">Add New User</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <asp:GridView ID="grdUsers" runat="server" CellPadding="1" CellSpacing="1" CssClass="grid"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdUsers_RowDeleted" OnSelectedIndexChanged="grdUsers_SelectedIndexChanged"
                                    DataKeyNames="UserId" OnDataBound="grdUsers_DataBound" DataSourceID="UsersDataSource">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#">
                                            <HeaderStyle CssClass="rank" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Hide">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="CkHide" runat="server" Checked='<%# Eval("Hide") %>' />
                                                <asp:CheckBox ID="CKOld" runat="server" Checked='<%# Eval("Hide") %>' Visible="False" />
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="hidecol" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName" />
                                        <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName" />
                                        <asp:BoundField DataField="ArDepartmentName" HeaderText="Department Name" SortExpression="ArDepartmentName" />
                                        <asp:TemplateField HeaderText="Role">
                                            <ItemTemplate>
                                                <asp:Label ID="Role" runat="server" Text='<%# Eval("RoleId").ToString() == "1" ? "Administrator" : "Data Entry"%>'></asp:Label>
                                                <asp:Label ID="UserName" runat="server" Text='<%# Eval("UserName") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:ButtonField CommandName="Select" HeaderText="Edit" Text="Edit" />
                                        <asp:TemplateField HeaderText="Delete">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="Delete" CausesValidation="False"
                                                    CommandName="Delete" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 33px">
                                <asp:LinkButton CausesValidation="False" CssClass="linkbtn" ID="btnUpdate" runat="server"
                                    ToolTip="Update Hide Values" OnClick="btnUpdate_Click">Update</asp:LinkButton>
                            </td>
                            <td align="center">
                                <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                                    Visible="False">An error occurred, could not delete user.</asp:Label>
                            </td>
                            <td align="right">
                                <asp:LinkButton ID="btnAdd1" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click">Add New User</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                    <asp:SqlDataSource ID="SectionsDS" runat="server" ConnectionString="<%$ ConnectionStrings:db_connection %>"
                        SelectCommand="UsersSections_GetList" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                    <asp:ObjectDataSource ID="UsersDataSource" runat="server" DeleteMethod="Delete" EnablePaging="True"
                        SelectMethod="GetByPage" TypeName="TeiLib.UsersDAL" StartRowIndexParameterName="StartIndex"
                        MaximumRowsParameterName="MaximumRows" SelectCountMethod="GetRowsCount" SortParameterName="SortColumn"
                        OnDeleted="DataSourceDeleted">
                        <DeleteParameters>
                            <asp:Parameter Name="UserId" Type="Int32" />
                        </DeleteParameters>
                    </asp:ObjectDataSource>
                </asp:View>
                <asp:View ID="NoAccessView" runat="server">
                    <h2 id="noAccess">
                        You are not permitted to access this page</h2>
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
