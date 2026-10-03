<%@ Page Language="C#" MasterPageFile="layout1.master" AutoEventWireup="true" CodeFile="Insert_students.aspx.cs"
    Inherits="Insert_students" Title=".:: الطلاب ::." %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    ادخال بيانات الطلاب 
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
<%--<asp:UpdatePanel ID="PagePanel" runat="server" ChildrenAsTriggers="true" UpdateMode="Always">
        <ContentTemplate>--%>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="1">
                <asp:View ID="FormView" runat="server">
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                        <tr>
                            <td>
                                <asp:FormView ID="StudentsForm" runat="server" OnItemInserted="StudentsForm_ItemInserted"
                                    OnItemInserting="StudentsForm_ItemInserting" OnItemUpdated="StudentsForm_ItemUpdated"
                                    OnItemUpdating="StudentsForm_ItemUpdating" OnModeChanging="StudentsForm_ModeChanging"
                                    DataKeyNames="StudentId" Width="100%" DataSourceID="StudentsDS" EnableViewState="false" >
                                    <InsertItemTemplate>
                                        <table cellpadding="0" cellspacing="3px" border="0" width="100%" class="form">
                                            <tr>
                                                <td colspan="3">
                                                    <h4>
                                                        إدخال بيانات الطالب
                                                    </h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="margin" rowspan="5">
                                                </td>
                                                <td colspan="3" style="padding-top: 20px;">
                                                    <ajaxToolkit:TabContainer ID="Tabs" runat="server" CssClass="linkedin linkedin-blue"
                                                        Width="100%" ActiveTabIndex="0">
                                                        <ajaxToolkit:TabPanel ID="mainTab" runat="server" HeaderText="البيانات الاساسية">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الاسم الاول (باللغة العربية)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arStudentFirstName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="arStudentFirstName1Required1" runat="server" ControlToValidate="arStudentFirstName1" ForeColor="Red" 
                                                                            ErrorMessage="*" InitialValue=""></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            الاسم الثاني (باللغة العربية)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arStudentSecondName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="arStudentSecondName1Required" runat="server" ControlToValidate="arStudentSecondName1" ForeColor="Red"
                                                                           ErrorMessage="*" InitialValue=""></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            الاسم الاخير (باللغة العربية)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arStudentLastName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="arStudentLastName1Required" runat="server" ControlToValidate="arStudentLastName1" InitialValue="" ForeColor="Red"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 22%">
                                                                           FirstName
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentFirstName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentFirstName1Required" runat="server" ControlToValidate="studentFirstName1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 22%">
                                                                            MiddleName
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentMiddleName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentMiddleName1Required" runat="server" ControlToValidate="studentMiddleName1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 22%">
                                                                            LastName
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentLastName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentLastName1Required" runat="server" ControlToValidate="studentLastName1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجنس
                                                                        </td>
                                                                        <td>
                                                                            <asp:RadioButtonList ID="gender1" runat="server" RepeatDirection="Horizontal">
                                                                                <asp:ListItem Text="ذكر" Value="true" Selected="True"></asp:ListItem>
                                                                                <asp:ListItem Text="انثى" Value="false"></asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            الديانة
                                                                        </td>
                                                                        <td>
                                                                            <asp:RadioButtonList ID="religion1" runat="server" RepeatDirection="Horizontal">
                                                                                <asp:ListItem Text="مسلم" Value="1" Selected="True"></asp:ListItem>
                                                                                <asp:ListItem Text="مسيحي" Value="2"></asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجنسية
                                                                        </td>
                                                                        <td>
                                                                            <asp:DropDownList ID="nationality1" runat="server" DataSourceID="NationalitiesDataSource1"
                                                                                DataValueField="NationalityId" DataTextField="ArNationalityName" AppendDataBoundItems="True"
                                                                                Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:RequiredFieldValidator ID="nationality1Required" runat="server" ControlToValidate="nationality1"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                            <asp:ObjectDataSource ID="NationalitiesDataSource1" runat="server" SelectMethod="GetAll"
                                                                                TypeName="TeiLib.NationalitiesDAL"></asp:ObjectDataSource>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الميلاد (dd-mm-yyyy)
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="birthdate1" runat="server" Columns="12"></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="birthdateImg1" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="Calendar" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                                                                TargetControlID="birthdate1" PopupButtonID="birthdateImg1" Enabled="True" />
                                                                            <asp:RequiredFieldValidator ID="DateRequired" runat="server" ControlToValidate="birthdate1"
                                                                                Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                                                            <asp:RegularExpressionValidator ID="DateValidator" runat="server" ControlToValidate="birthdate1"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            مكان الميلاد 
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="birthPlace1" runat="server" DataSourceID="CountriesCitiesDataSource1"
                                                                                DataValueField="LocationId" DataTextField="ArLocationName" AppendDataBoundItems="True"
                                                                                Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="CountriesCitiesDataSource1" runat="server" SelectMethod="GetAll"
                                                                                TypeName="TeiLib.LocationsDAL">
                                                                                <SelectParameters>
                                                                                    <asp:Parameter Name="type" DefaultValue="4" Type="Int32" />
                                                                                </SelectParameters>
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="birthPlace1Required" runat="server" ControlToValidate="birthPlace1"
                                                                                ErrorMessage="*" InitialValue="0" ></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الرقم القومي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="nationalId1" runat="server" Columns="60" MaxLength="14" placeholder="الرقم القومي مكون من 14 رقم"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="rfvNationalId" runat="server" ControlToValidate="nationalId1"
                                                                                ErrorMessage="*" ></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الاصدار
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="ReleaseDate1" runat="server" Columns="12"></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="ReleaseDateImg1" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="ReleaseDate1" PopupButtonID="ReleaseDateImg1"
                                                                                Enabled="True" />
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ReleaseDate1"
                                                                                Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="ReleaseDate1"
                                                                                 ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            جهة الاصدار
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="NationalZone1" runat="server" DataSourceID="AreasDataSource1"
                                                                                DataValueField="LocationId" DataTextField="ArLocationName" AppendDataBoundItems="True">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                              <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="NationalZone1"
                                                                                ErrorMessage="*" InitialValue="0" ></asp:RequiredFieldValidator>
                                                                            <asp:ObjectDataSource ID="AreasDataSource1" runat="server" SelectMethod="GetAll"
                                                                                TypeName="TeiLib.LocationsDAL">
                                                                                <SelectParameters>
                                                                                    <asp:Parameter Name="type" DefaultValue="5" Type="Int32" />
                                                                                </SelectParameters>
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            جواز السفر
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="passportNo1" runat="server" Columns="60"></asp:TextBox>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الاصدار
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="PaassportRelDate1" runat="server" Columns="12"></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="PassRelImage1" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="PaassportRelDate1" PopupButtonID="PassRelImage1"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="PaassportRelDate1"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True" >تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="padding-top: 7px">
                                                                            تاريخ الانتهاء
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="PassExpirDate1" runat="server" Columns="12"></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="ExpirDatepassImage1" CausesValidation="False"
                                                                                ImageUrl="images/calendar.gif" AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender3" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="PassExpirDate1" PopupButtonID="ExpirDatepassImage1"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="PassExpirDate1"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True" >تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <%--<tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            بيانات التسجيل
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            العام الدراسي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="years1" runat="server" DataSourceID="YearDs1" DataValueField="YearId" 
                                                                                DataTextField="YearName" AppendDataBoundItems="True" Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="YearDs1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="years1Required" runat="server" ControlToValidate="years1"
                                                                                ErrorMessage="*" InitialValue="0" ></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            القسم المطلوب
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="departments1" runat="server" DataSourceID="DepartmentsDS1"
                                                                                DataValueField="DepartmentId" DataTextField="ArDepartmentName" AppendDataBoundItems="True"
                                                                                Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="DepartmentsDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.DepartmentsDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="departments1Required" runat="server" ControlToValidate="departments1"
                                                                                ErrorMessage="*" InitialValue="0" ></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>--%>
                                                                    <tr>

                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                      
                                                                        </td>
                                                                        <td>
                                                                        <asp:Button ID="Next" Text="Next" runat="server" CausesValidation="false" Width="100px" OnClick="Next_Click"  />
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="certificateTab" runat="server" HeaderText="البيانات الدراسية">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            المؤهل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="certificate1" runat="server" DataSourceID="CertificateDS1"
                                                                                DataValueField="CertificateId" DataTextField="ArCertificateName" AppendDataBoundItems="True"
                                                                                Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="CertificateDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.CertificatesDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="certificate1Required" runat="server" ControlToValidate="certificate1"
                                                                              ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            بلدالحصول عليه
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="certitificateLocation1" runat="server" DataSourceID="CountryDS1"
                                                                                DataValueField="LocationId" DataTextField="ArLocationName" AppendDataBoundItems="True"
                                                                                Width="150px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="CountryDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LocationsDAL">
                                                                                <SelectParameters>
                                                                                    <asp:Parameter Name="type" DefaultValue="1" Type="Int32" />
                                                                                </SelectParameters>
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="certitificateLocation1Required" runat="server" ControlToValidate="certitificateLocation1"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            سنة الحصول عليها
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="certificateYear1" runat="server" DataSourceID="YearsDS1" DataValueField="YearId"
                                                                                DataTextField="YearName" AppendDataBoundItems="True" Width="150px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="YearsDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="certificateYear1Required" runat="server" ControlToValidate="certificateYear1"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم الجلوس
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="certificateٍٍٍSeatNo1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="certificateٍٍٍSeatNo1Required" runat="server" ControlToValidate="certificateٍٍٍSeatNo1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            المجموع الكلي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="certificateTotalResult1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="certificateTotalResult1Required" runat="server" ControlToValidate="certificateTotalResult1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            النسبة المئوية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="certificateResultPercentage1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="certificateResultPercentage1Required" runat="server"
                                                                                ControlToValidate="certificateResultPercentage1" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                   <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            بيانات المدرسة
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اسم المدراسة
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="SchoolName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="SchoolName1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            الأدارة التعليمية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="educationalPlace1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                                                                ControlToValidate="educationalPlace1" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            اللغات التي يجيدها
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اختراللغةالأولى
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="firstLanguage1" runat="server" DataSourceID="LanguagesDS1"
                                                                                DataValueField="LanguageId" DataTextField="ArLanguageName" AppendDataBoundItems="True"
                                                                                Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="LanguagesDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LanguagesDAL">
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اختر اللغة الثانية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="secondLanguage1" runat="server" DataSourceID="LanguagesDS1"
                                                                                DataValueField="LanguageId" DataTextField="ArLanguageName" AppendDataBoundItems="True"
                                                                                Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                           <asp:Button ID="Next1" Text="Next" runat="server" CausesValidation="false"  Width="100px" OnClick="Next1_Click"  />
                                                                        </td>
                                                                        <td>
                                                                           <asp:Button ID="Previous0" Text="Previous" runat="server"  Width="100px" OnClick="Previous0_Click"  CausesValidation="false"/>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="contactTab" runat="server" HeaderText="بيانات الاتصال">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            العنوان(باللغة العربية)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arAddress1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="arAddress1Required" runat="server" ControlToValidate="arAddress1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%" align="center">
                                                                            Address
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="address1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="address1Required" runat="server" ControlToValidate="address1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            المنطقة - البلد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="addressLocation1" runat="server" DataSourceID="AreaDS1" DataValueField="LocationId"
                                                                                DataTextField="ArLocationName" AppendDataBoundItems="True" Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <ajaxToolkit:ListSearchExtender ID="ListSearchExtender1" runat="server" TargetControlID="addressLocation1"
                                                                                PromptCssClass="ListSearchExtenderPrompt" QueryPattern="Contains" QueryTimeout="2000">
                                                                            </ajaxToolkit:ListSearchExtender>
                                                                            <asp:ObjectDataSource ID="AreaDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LocationsDAL">
                                                                                <SelectParameters>
                                                                                    <asp:Parameter Name="type" DefaultValue="5" Type="Int32" />
                                                                                </SelectParameters>
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="addressLocation1Required" runat="server" ControlToValidate="addressLocation1"
                                                                                ErrorMessage="*" InitialValue="0">
                                                                            </asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" valign="top">
                                                                            البريد الاليكتروني للمعهد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="txtEmailinstitute1" runat="server" Enabled="false" Columns="60"></asp:TextBox>
                                                                           <%-- <asp:RequiredFieldValidator ID="rfEmailinstitute1" runat="server" ControlToValidate="txtEmailinstitute1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم التليفون
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentPhone1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentPhone1Required" runat="server" ControlToValidate="studentPhone1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentMobile1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentMobile1Required" runat="server" ControlToValidate="studentMobile1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            البريد الاليكتروني الشخصي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentEmail1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentEmail1Required" runat="server" ControlToValidate="studentEmail1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم الموبايل الثاني
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="txtMobile21" runat="server" Columns="60"></asp:TextBox>
                                                                           <%-- <asp:RequiredFieldValidator ID="rfMobile21" runat="server" ControlToValidate="txtMobile21"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            حساب الفيس بوك
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentFacebook1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            حساب تويتر
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentTwitter1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        <asp:Button ID="Next2" Text="Next" runat="server" CausesValidation="false"  Width="100px" OnClick="Next2_Click"  />
                                                                        </td>
                                                                        <td>
                                                                        <asp:Button ID="Previous1" Text="Previous" runat="server"  Width="100px" OnClick="Previous1_Click"  CausesValidation="false"/>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="familyTab" runat="server" HeaderText="بيانات العائلة">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            اسم الأب (باللغة العربية)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arFatherName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="studentEmail1"
                                                                        ErrorMessage="*" ></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            Father Name
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="fatherName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            وظيفة الأب
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arFatherJob1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            Father Position
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="fatherJob1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="fahterMobile1" runat="server" Columns="60"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="fahterMobile1Required" runat="server" ControlToValidate="fahterMobile1"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            البريد الاليكتروني
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="fatherEmail1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اسم الام (باللغة العربية)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arMotherName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            Mother Name
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="motherName1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            وظيفة الام (باللغة العربية)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arMotherJob1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            Mother Position
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="motherJob1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="motherMobile1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                          <asp:Button ID="Next3" Text="Next" runat="server" CausesValidation="false" Width="100px" OnClick="Next3_Click"  />
                                                                        </td>
                                                                        <td>
                                                                          <asp:Button ID="Previous2" Text="Previous" runat="server"  Width="100px" OnClick="Previous2_Click"  CausesValidation="false"/>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="activityTab" runat="server" HeaderText="الانشطة والهوايات">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            النشاط
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="activity1" runat="server" DataSourceID="ActivitiesDS1" DataValueField="ActivityId"
                                                                                DataTextField="ArActivityName" AppendDataBoundItems="True" Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="ActivitiesDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.ActivitiesDAL">
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            مكان النشاط
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="activityPlace1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            البطولة الحاصل عليها
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:TextBox ID="activityChamp1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ الحصول عليها
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="activityChampDate1" runat="server" Columns="12"></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="champDate1" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender4" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="activityChampDate1" PopupButtonID="champDate1"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="activityChampDate1"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            الهوايات
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            الهواية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="hoppy1" runat="server" DataSourceID="HoppiesDS1" DataValueField="HoppyId"
                                                                                DataTextField="ArHoppyName" AppendDataBoundItems="True" Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="HoppiesDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.HoppiesDAL">
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            مكان الهواية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="hoppyPlace1" runat="server" Columns="60"></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    
                                                                    
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            كيفية التعرف علي المعهد
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            التعرف علي المعهد عن طريق
                                                                        </td>
                                                                        <td class="input" colspan="2">
                                                                            <asp:DropDownList ID="InstituteStatment1" runat="server" DataSourceID="ObjectDataSource1" DataValueField="InstituteStatmentId"
                                                                                DataTextField="InstituteStatment" AppendDataBoundItems="True" Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                             <asp:RequiredFieldValidator ID="rfInstituteStatment" runat="server" ControlToValidate="InstituteStatment1" InitialValue="0"
                                                                              ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                                                            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.InstituteStatmentsDAL">
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                    
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                           <asp:Button ID="Previous3" Text="Previous" runat="server"  Width="100px" OnClick="Previous3_Click"  CausesValidation="false"/>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="armyTab" runat="server" HeaderText="التجنيد" Visible="false">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            حالة التجنيد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="armyStatus1" runat="server" DataSourceID="ArmyDS1" DataValueField="ArmyId"
                                                                                DataTextField="ArArmyStatusName" AppendDataBoundItems="True" Width="200px">
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="ArmyDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.ArmyStatusDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="armyStatus1Required" runat="server" ControlToValidate="armyStatus1"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            الرقم الثلاثي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="thiroidNo1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم التأجيل
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:TextBox ID="exemptedNo1" runat="server" Columns="60"></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ التأجيل
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="exemptedDate1" runat="server" Columns="12"></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="exemptedDateButton1" CausesValidation="False"
                                                                                ImageUrl="images/calendar.gif" AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender8" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="exemptedDate1" PopupButtonID="exemptedDateButton1"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator8" runat="server" ControlToValidate="exemptedDate1"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            منطوق القرار
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="operativeDecision1" runat="server" Columns="30" TextMode="MultiLine"></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="acceptanceTab" runat="server" HeaderText="القبول" Visible="false">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            حالة القبول
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="ddlAcceptance1" runat="server" DataSourceID="AcceptanceDS1"
                                                                                DataValueField="AcceptanceId" DataTextField="ArAcceptanceName" AppendDataBoundItems="True"
                                                                                Width="200px" SelectedValue='<%# Bind("AcceptanceId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="AcceptanceDS1" runat="server" SelectMethod="GetAll" TypeName="TeiLib.AcceptanceTypeDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="ddlAcceptanceRequired1" runat="server" ControlToValidate="ddlAcceptance1"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ القبول
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="txtAcceptanceDate1" runat="server" Columns="12" Text='<%# Bind("AcceptanceDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="acceptanceDateImage1" CausesValidation="False"
                                                                                ImageUrl="images/calendar.gif" AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="acceptanceCalender1" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="txtAcceptanceDate1" PopupButtonID="acceptanceDateImage1"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="txtAcceptanceDateValidator1" runat="server" ControlToValidate="txtAcceptanceDate1"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم القبول
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:TextBox ID="txtAcceptanceNumber1" runat="server" Columns="60" Text='<%# Bind("AcceptanceNumber") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ التحويل
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="txtTransferDate1" runat="server" Columns="12" Text='<%# Bind("TransferDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="transferDateImage1" CausesValidation="False"
                                                                                ImageUrl="images/calendar.gif" AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="transferDateCalendar1" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="txtTransferDate1" PopupButtonID="transferDateImage1"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator11" runat="server"
                                                                                ControlToValidate="txtTransferDate1" ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجهة المحول منها
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="txtTransferFrom1" runat="server" Columns="30" Text='<%# Bind("TransferFrom") %>'></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                    </ajaxToolkit:TabContainer>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" style="width: 20%">
                                                    صورة الطالب
                                                </td>
                                                <td class="input">
                                                    <asp:FileUpload ID="studentImage1" runat="server" Width="240px" />
                                                    <%--<asp:RequiredFieldValidator ID="studentImage1Required" runat="server" ControlToValidate="studentImage1"
                                                        SetFocusOnError="True">*</asp:RequiredFieldValidator>--%>
                                                    <asp:Label ID="Size" runat="server" Font-Size="Smaller" Text="Dimention: 202 * 174"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 10px">
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                            <td>  </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit1" runat="server" CssClass="button" Text="إضافة" CommandName="Insert" />
                                                    <asp:Button ID="btnCancel1" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        Text="إلغاء" CommandName="Cancel" />
                                                </td>
                                            </tr>
                                        </table>
                                    </InsertItemTemplate>
                                    <EditItemTemplate>
                                        <table cellpadding="0" cellspacing="3px" border="0" width="800px" class="form">
                                            <tr>
                                                <td colspan="3">
                                                    <h4>
                                                        تعديل بيانات الطالب
                                                    </h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="margin" rowspan="5">
                                                </td>
                                                <td colspan="2" style="padding-top: 20px;">
                                                    <ajaxToolkit:TabContainer ID="Tabs" runat="server" CssClass="linkedin linkedin-blue"
                                                        Width="100%">
                                                        <ajaxToolkit:TabPanel ID="mainTab" runat="server" HeaderText="البيانات الاساسية">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الاسم الاول (ع)
                                                                            <asp:TextBox ID="codeText" runat="server" Columns="60" Text='<%# Bind("StudentCode") %>'
                                                                                Visible="false"></asp:TextBox>
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arStudentFirstName" runat="server" Columns="60" Text='<%# Bind("ArFirstName") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="arStudentFirstNameRequired" runat="server" ControlToValidate="arStudentFirstName"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            الاسم الثاني (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arStudentSecondName" runat="server" Columns="60" Text='<%# Bind("ArMiddleName") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="arStudentSecondNameRequired" runat="server" ControlToValidate="arStudentSecondName"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            الاسم الاخير (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arStudentLastName" runat="server" Columns="60" Text='<%# Bind("ArLastName") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="arStudentLastNameRequired" runat="server" ControlToValidate="arStudentLastName"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 22%">
                                                                            الاسم الاول (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentFirstName" runat="server" Columns="60" Text='<%# Bind("FirstName") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentFirstNameRequired" runat="server" ControlToValidate="studentFirstName"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 22%">
                                                                            الاسم الثاني(En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentMiddleName" runat="server" Columns="60" Text='<%# Bind("MiddleName") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentMiddleNameRequired" runat="server" ControlToValidate="studentMiddleName"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 22%">
                                                                            الاسم الاخير(En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentLastName" runat="server" Columns="60" Text='<%# Bind("LastName") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentLastNameRequired" runat="server" ControlToValidate="studentLastName"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجنس
                                                                        </td>
                                                                        <td>
                                                                            <asp:RadioButtonList ID="gender" runat="server" RepeatDirection="Horizontal" SelectedValue='<%# Bind("Gender") %>'>
                                                                                <asp:ListItem Text="ذكر" Value="True"></asp:ListItem>
                                                                                <asp:ListItem Text="انثى" Value="False"></asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            الديانة
                                                                        </td>
                                                                        <td>
                                                                            <asp:RadioButtonList ID="religion" runat="server" RepeatDirection="Horizontal" SelectedValue='<%# Bind("Religion") %>'>
                                                                                <asp:ListItem Text="مسلم" Value="1"></asp:ListItem>
                                                                                <asp:ListItem Text="مسيحي" Value="2"></asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجنسية
                                                                        </td>
                                                                        <td>
                                                                            <asp:DropDownList ID="nationality" runat="server" DataSourceID="NationalitiesDataSource10"
                                                                                DataValueField="NationalityId" DataTextField="ArNationalityName" AppendDataBoundItems="True"
                                                                                Width="200px" SelectedValue='<%# Bind("NationalityId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="NationalitiesDataSource10" runat="server" SelectMethod="GetAll"
                                                                                TypeName="TeiLib.NationalitiesDAL"></asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="nationalityRequired" runat="server" ControlToValidate="nationality"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الميلاد
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="birthdate" runat="server" Columns="12" Text='<%# Bind("DateOfBirth","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="birthdateImg" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="Calendar2" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                                                                TargetControlID="birthdate" PopupButtonID="birthdateImg" Enabled="True" />
                                                                            <asp:RequiredFieldValidator ID="DateRequired2" runat="server" ControlToValidate="birthdate"
                                                                                Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                                                            <asp:RegularExpressionValidator ID="DateValidator2" runat="server" ControlToValidate="birthdate"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            مكان الميلاد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="birthPlace" runat="server" DataSourceID="CountriesCitiesDataSource"
                                                                                DataValueField="LocationId" DataTextField="ArLocationName" AppendDataBoundItems="True"
                                                                                Width="200px" SelectedValue='<%# Bind("BirthPlaceId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="CountriesCitiesDataSource" runat="server" SelectMethod="GetAll"
                                                                                TypeName="TeiLib.LocationsDAL">
                                                                                <SelectParameters>
                                                                                    <asp:Parameter Name="type" DefaultValue="4" Type="Int32" />
                                                                                </SelectParameters>
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="birthPlaceRequired" runat="server" ControlToValidate="birthPlace"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الرقم القومي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="nationalId" runat="server" Columns="60" Text='<%# Bind("NationalId") %>'></asp:TextBox>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الاصدار
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="ReleaseDate" runat="server" Columns="12" Text='<%# Bind("NationalIdReleaseDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="ReleaseDateImg" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender5" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="ReleaseDate" PopupButtonID="ReleaseDateImg"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="ReleaseDate"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            جهة الاصدار
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="NationalZone" runat="server" DataSourceID="AreasDataSource"
                                                                                DataValueField="LocationId" DataTextField="ArLocationName" AppendDataBoundItems="True"
                                                                                SelectedValue='<%# Bind("NationalIdReleaseZone") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <ajaxToolkit:ListSearchExtender ID="LSE" runat="server" TargetControlID="NationalZone"
                                                                                PromptCssClass="ListSearchExtenderPrompt" QueryPattern="Contains" QueryTimeout="2000">
                                                                            </ajaxToolkit:ListSearchExtender>
                                                                            <asp:ObjectDataSource ID="AreasDataSource" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LocationsDAL">
                                                                                <SelectParameters>
                                                                                    <asp:Parameter Name="type" DefaultValue="5" Type="Int32" />
                                                                                </SelectParameters>
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            جواز السفر
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="passportNo" runat="server" Columns="60" Text='<%# Bind("PassportId") %>'></asp:TextBox>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الاصدار
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="PaassportRelDate" runat="server" Columns="12" Text='<%# Bind("PassportReleaseDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="PassRelImage" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender6" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="PaassportRelDate" PopupButtonID="PassRelImage"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" ControlToValidate="PaassportRelDate"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-top: 7px">
                                                                            تاريخ الانتهاء
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="PassExpirDate" runat="server" Columns="12" Text='<%# Bind("PassportExpirationDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="ExpirDatepassImage" CausesValidation="False"
                                                                                ImageUrl="images/calendar.gif" AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender9" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="PassExpirDate" PopupButtonID="ExpirDatepassImage"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator9" runat="server" ControlToValidate="PassExpirDate"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            بيانات التسجيل
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            العام الدراسي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="years" runat="server" DataSourceID="SemesterDS" DataValueField="YearId"
                                                                                DataTextField="YearName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("YearId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="YearDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="yearsRequired" runat="server" ControlToValidate="years"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            القسم المطلوب
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="departments" runat="server" DataSourceID="DepartmentsDS" DataValueField="DepartmentId"
                                                                                DataTextField="ArDepartmentName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("DepartmentId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="DepartmentsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.DepartmentsDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="departmentsRequired" runat="server" ControlToValidate="departments"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="certificateTab" runat="server" HeaderText="البيانات الدراسية">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            المؤهل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="certificate" runat="server" DataSourceID="CertificateDS" DataValueField="CertificateId"
                                                                                DataTextField="ArCertificateName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("CertificateId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="CertificateDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.CertificatesDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="certificateRequired" runat="server" ControlToValidate="certificate"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            بلد الحصول عليه
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="certitificateLocation" runat="server" DataSourceID="CountryDS"
                                                                                DataValueField="LocationId" DataTextField="ArLocationName" AppendDataBoundItems="True"
                                                                                Width="150px" SelectedValue='<%# Bind("CertificateCountry") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="CountryDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LocationsDAL">
                                                                                <SelectParameters>
                                                                                    <asp:Parameter Name="type" DefaultValue="1" Type="Int32" />
                                                                                </SelectParameters>
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="certitificateLocationRequired" runat="server" ControlToValidate="certitificateLocation"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            سنة الحصول عليها
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="certificateYear" runat="server" DataSourceID="YearsDS" DataValueField="YearId"
                                                                                DataTextField="YearName" AppendDataBoundItems="True" Width="150px" SelectedValue='<%# Bind("CertificateYearId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="YearsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="certificateYearRequired" runat="server" ControlToValidate="certificateYear"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم الجلوس
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="certificateٍٍٍSeatNo" runat="server" Columns="60" Text='<%# Bind("CertificateSeatNo") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="certificateٍٍٍSeatNoRequired" runat="server" ControlToValidate="certificateٍٍٍSeatNo"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            المجموع الكلي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="certificateTotalResult" runat="server" Columns="60" Text='<%# Bind("CertificateTotalResult") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="certificateTotalResultRequired" runat="server" ControlToValidate="certificateTotalResult"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            النسبة المئوية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="certificateResultPercentage" runat="server" Columns="60" Text='<%# Bind("CertificateResultPercentage") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                            <asp:RequiredFieldValidator ID="certificateResultPercentageRequired" runat="server"
                                                                                ControlToValidate="certificateResultPercentage" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            بيانات المدرسة
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اختر المدرسة
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="school" runat="server" DataSourceID="SchoolsDS" DataValueField="SchoolId"
                                                                                DataTextField="SchoolName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("SchoolId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="SchoolsDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.SchoolsDAL">
                                                                                <%-- <SelectParameters>
                                                                <asp:Parameter Name="type" DefaultValue="1" Type="Int32" />
                                                            </SelectParameters>--%>
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            اللغات التي يجيدها
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اختر اللغة الأولى
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="firstLanguage" runat="server" DataSourceID="LanguagesDS" DataValueField="LanguageId"
                                                                                DataTextField="ArLanguageName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("FirstLanguageId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="LanguagesDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LanguagesDAL">
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اختر اللغة الثانية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="secondLanguage" runat="server" DataSourceID="LanguagesDS" DataValueField="LanguageId"
                                                                                DataTextField="ArLanguageName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("SecondLanguageId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="contactTab" runat="server" HeaderText="بيانات الاتصال">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            العنوان(ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arAddress" runat="server" Columns="60" Text='<%# Bind("ArStudentAddress") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="arAddressRequired" runat="server" ControlToValidate="arAddress"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            العنوان(En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="address" runat="server" Columns="60" Text='<%# Bind("StudentAddress") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="addressRequired" runat="server" ControlToValidate="address"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            المنطقة - البلد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="addressLocation" runat="server" DataSourceID="AreaDS" DataValueField="LocationId"
                                                                                DataTextField="ArLocationName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("StudentAddressLocationId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <ajaxToolkit:ListSearchExtender ID="ListSearchExtender5" runat="server" TargetControlID="addressLocation"
                                                                                PromptCssClass="ListSearchExtenderPrompt" QueryPattern="Contains" QueryTimeout="2000">
                                                                            </ajaxToolkit:ListSearchExtender>
                                                                            <asp:ObjectDataSource ID="AreaDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.LocationsDAL">
                                                                                <SelectParameters>
                                                                                    <asp:Parameter Name="type" DefaultValue="5" Type="Int32" />
                                                                                </SelectParameters>
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="addressLocationRequired" runat="server" ControlToValidate="addressLocation"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم التليفون
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentPhone" runat="server" Columns="60" Text='<%# Bind("StudentPhone") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentPhoneRequired" runat="server" ControlToValidate="studentPhone"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentMobile" runat="server" Columns="60" Text='<%# Bind("StudentMobile") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentMobileRequired" runat="server" ControlToValidate="studentMobile"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            البريد الاليكتروني
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentEmail" runat="server" Columns="60" Text='<%# Bind("StudentEmail") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="studentEmailRequired" runat="server" ControlToValidate="studentEmail"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            حساب الفيس بوك
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentFacebook" runat="server" Columns="60" Text='<%# Bind("StudentFacebook") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            حساب تويتر
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="studentTwitter" runat="server" Columns="60" Text='<%# Bind("StudentTwitter") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="familyTab" runat="server" HeaderText="بيانات العائلة">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            اسم الأب (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arFatherName" runat="server" Columns="60" Text='<%# Bind("ArFatherName") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnTitleRequired1" runat="server" ControlToValidate="txtEnTitle1"
                                                                                ErrorMessage="Please enter english title" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            اسم الاب (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="fatherName" runat="server" Columns="60" Text='<%# Bind("FatherName") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            وظيفة الأب
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arFatherJob" runat="server" Columns="60" Text='<%# Bind("ArFatherJob") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            وظيفة الأب (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="fatherJob" runat="server" Columns="60" Text='<%# Bind("FatherJob") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="fahterMobile" runat="server" Columns="60" Text='<%# Bind("FatherMobile") %>'></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="fahterMobileRequired" runat="server" ControlToValidate="fahterMobile"
                                                                                ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            البريد الاليكتروني
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="fatherEmail" runat="server" Columns="60" Text='<%# Bind("FatherEmail") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اسم الام (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arMotherName" runat="server" Columns="60" Text='<%# Bind("ArMotherName") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            اسم الام (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="motherName" runat="server" Columns="60" Text='<%# Bind("MotherName") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            وظيفة الام (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="arMotherJob" runat="server" Columns="60" Text='<%# Bind("ArMotherJob") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            وظيفة الام (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="motherJob" runat="server" Columns="60" Text='<%# Bind("MotherJob") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="motherMobile" runat="server" Columns="60" Text='<%# Bind("MotherMobile") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="activityTab" runat="server" HeaderText="الانشطة والهوايات">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            النشاط
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="activity" runat="server" DataSourceID="ActivitiesDS" DataValueField="ActivityId"
                                                                                DataTextField="ArActivityName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("ActivityId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="ActivitiesDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.ActivitiesDAL">
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            مكان النشاط
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="activityPlace" runat="server" Columns="60" Text='<%# Bind("ActivityPlace") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            البطولة الحاصل عليها
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:TextBox ID="activityChamp" runat="server" Columns="60" Text='<%# Bind("ActivityChampionship") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ الحصول عليها
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="activityChampDate" runat="server" Columns="12" Text='<%# Bind("ActivityChampionshipDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="champDate" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender7" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="activityChampDate" PopupButtonID="champDate"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" ControlToValidate="activityChampDate"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            الهوايات
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            الهواية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="hoppy" runat="server" DataSourceID="HoppiesDS" DataValueField="HoppyId"
                                                                                DataTextField="ArHoppyName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("HoppyId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="HoppiesDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.HoppiesDAL">
                                                                            </asp:ObjectDataSource>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            مكان الهواية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="hoppyPlace" runat="server" Columns="60" Text='<%# Bind("HoppyPlace") %>'></asp:TextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="armyTab" runat="server" HeaderText="التجنيد">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            حالة التجنيد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="armyStatus" runat="server" DataSourceID="ArmyDS" DataValueField="ArmyId"
                                                                                DataTextField="ArArmyStatusName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("ArmyId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="ArmyDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.ArmyStatusDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="armyStatusRequired" runat="server" ControlToValidate="armyStatus"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            الرقم الثلاثي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="thiroidNo" runat="server" Columns="60" Text='<%# Bind("ThirdNumber") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم التأجيل
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:TextBox ID="exemptedNo" runat="server" Columns="60" Text='<%# Bind("ExemptedNumber") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ التأجيل
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="exemptedDate" runat="server" Columns="12" Text='<%# Bind("ExemptedDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="exemptedDateButton" CausesValidation="False"
                                                                                ImageUrl="images/calendar.gif" AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender10" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="exemptedDate" PopupButtonID="exemptedDateButton"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server"
                                                                                ControlToValidate="exemptedDate" ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            منطوق القرار
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="operativeDecision" runat="server" Columns="30" TextMode="MultiLine"
                                                                                Text='<%# Bind("OperativeDecision") %>'></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="acceptanceTab" runat="server" HeaderText="القبول">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            حالة القبول
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:DropDownList ID="ddlAcceptance" runat="server" DataSourceID="AcceptanceDS" DataValueField="AcceptanceId"
                                                                                DataTextField="ArAcceptanceName" AppendDataBoundItems="True" Width="200px" SelectedValue='<%# Bind("AcceptanceId") %>'>
                                                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                                                            </asp:DropDownList>
                                                                            <asp:ObjectDataSource ID="AcceptanceDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.AcceptanceTypeDAL">
                                                                            </asp:ObjectDataSource>
                                                                            <asp:RequiredFieldValidator ID="ddlAcceptanceRequired" runat="server" ControlToValidate="ddlAcceptance"
                                                                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                        <td style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ القبول
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="txtAcceptanceDate" runat="server" Columns="12" Text='<%# Bind("AcceptanceDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="acceptanceDateImage" CausesValidation="False"
                                                                                ImageUrl="images/calendar.gif" AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="acceptanceCalender" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="txtAcceptanceDate" PopupButtonID="acceptanceDateImage"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="txtAcceptanceDateValidator" runat="server" ControlToValidate="txtAcceptanceDate"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم القبول
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:TextBox ID="txtAcceptanceNumber" runat="server" Columns="60" Text='<%# Bind("AcceptanceNumber") %>'></asp:TextBox>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ التحويل
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:TextBox ID="txtTransferDate" runat="server" Columns="12" Text='<%# Bind("TransferDate","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="transferDateImage" CausesValidation="False" ImageUrl="images/calendar.gif"
                                                                                AlternateText="Select Date" />
                                                                            <ajaxToolkit:CalendarExtender ID="transferDateCalendar" runat="server" CssClass="Calendar"
                                                                                Format="dd/MM/yyyy" TargetControlID="txtTransferDate" PopupButtonID="transferDateImage"
                                                                                Enabled="True" />
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator" runat="server" ControlToValidate="txtTransferDate"
                                                                                ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                                                                SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجهة المحول منها
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:TextBox ID="txtTransferFrom" runat="server" Columns="30" Text='<%# Bind("TransferFrom") %>'></asp:TextBox>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                    </ajaxToolkit:TabContainer>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="label" style="width: 20%">
                                                    صورة الطالب
                                                </td>
                                                <td class="input">
                                                    <asp:FileUpload ID="studentImage" runat="server" Width="240px" />
                                                    <asp:Label ID="lblPhoto" runat="server" Text='<%# Bind("Image") %>' Visible="false"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 10px">
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="button" colspan="2" align="center">
                                                    <asp:Button ID="btnSubmit" runat="server" CssClass="button" Text="تعديل" CommandName="Update" />
                                                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="rghtbtn"
                                                        Text="إلغاء" CommandName="Cancel" />
                                                </td>
                                            </tr>
                                        </table>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <table cellpadding="0" cellspacing="3px" border="0" width="800px" class="form">
                                            <tr>
                                                <td colspan="3">
                                                    <h4>
                                                        عرض بيانات الطالب
                                                    </h4>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="margin" rowspan="5">
                                                </td>
                                                <td colspan="2" style="padding-top: 20px;">
                                                    <ajaxToolkit:TabContainer ID="Tabs" runat="server" CssClass="linkedin linkedin-blue"
                                                        Width="100%" ActiveTabIndex="0">
                                                        <ajaxToolkit:TabPanel ID="mainTab" runat="server" HeaderText="البيانات الاساسية">
                                                            <ContentTemplate>
                                                                <div style="width: 100%; float: left">
                                                                    <div align="left">
                                                                        <img id="studentImage12" src='<%# "~/Students/Images/" + Eval("Image") %>' runat="server" />
                                                                        &nbsp;</div>
                                                                </div>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            كود الطالب
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentCode" runat="server" Columns="60" Text='<%# Bind("StudentCode") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الاسم الاول (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="arStudentFirstName0" runat="server" Columns="60" Text='<%# Bind("ArFirstName") %>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            الاسم الثاني (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="arStudentSecondName0" runat="server" Columns="60" Text='<%# Bind("ArMiddleName") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            الاسم الاخير (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="arStudentLastName0" runat="server" Columns="60" Text='<%# Bind("ArLastName") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 22%">
                                                                            الاسم الاول (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentFirstName0" runat="server" Columns="60" Text='<%# Bind("FirstName") %>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 22%">
                                                                            الاسم الثاني(En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentMiddleName0" runat="server" Columns="60" Text='<%# Bind("MiddleName") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 22%">
                                                                            الاسم الاخير(En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentLastName0" runat="server" Columns="60" Text='<%# Bind("LastName") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجنس
                                                                        </td>
                                                                        <td>
                                                                            <asp:RadioButtonList ID="gender0" runat="server" RepeatDirection="Horizontal" Enabled="False"
                                                                                SelectedValue='<%# Bind("Gender") %>'>
                                                                                <asp:ListItem Text="ذكر" Value="True"></asp:ListItem>
                                                                                <asp:ListItem Text="انثى" Value="False"></asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            الديانة
                                                                        </td>
                                                                        <td>
                                                                            <asp:RadioButtonList ID="religion0" runat="server" RepeatDirection="Horizontal" Enabled="False"
                                                                                SelectedValue='<%# Bind("Religion") %>'>
                                                                                <asp:ListItem Text="مسلم" Value="1" Selected="True"></asp:ListItem>
                                                                                <asp:ListItem Text="مسيحي" Value="2"></asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجنسية
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="nationality0" runat="server" Columns="12" 
                                                                                Text='<%# Bind("Nationality") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الميلاد
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:Label ID="birthdate0" runat="server" Columns="12" 
                                                                                Text='<%# Bind("DateOfBirth", "{0:dd/MM/yyyy}") %>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            مكان الميلاد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="birthPlace0" runat="server" Text='<%# Bind("ArPlaceOfBirth") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الرقم القومي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="nationalId0" runat="server" Columns="60" Text='<%# Bind("NationalId") %>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الاصدار
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:Label ID="ReleaseDate0" runat="server" 
                                                                                Text='<%# Bind("NationalIdReleaseDate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            جهة الاصدار
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="NationalZone0" runat="server" Text='<%# Bind("NationalIdReleaseZoneText") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            جواز السفر
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="passportNo0" runat="server" Columns="60" Text='<%# Bind("PassportId") %>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            تاريخ الاصدار
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:Label ID="PaassportRelDate0" runat="server" 
                                                                                Text='<%# Bind("PassportReleaseDate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="padding-top: 7px">
                                                                            تاريخ الانتهاء
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:Label ID="PassExpirDate0" runat="server" 
                                                                                Text='<%# Bind("PassportExpirationDate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            صورة الطالب
                                                                        </td>
                                                                        <td class="input">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            بيانات التسجيل
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            العام الدراسي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="year0" runat="server" Text='<%# Bind("ArYearName") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            القسم المطلوب
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="departments0" runat="server" Text='<%# Bind("ArDepartmentName") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="certificateTab" runat="server" HeaderText="البيانات الدراسية">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            المؤهل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="certificate0" runat="server" Text='<%# Bind("ArCertificateName")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            بلد الحصول عليه
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="certitificateLocation0" runat="server" Text='<%# Bind("ArCertificateLocation")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            سنة الحصول عليها
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="certificateYear0" runat="server" Text='<%# Bind("CertificateYear")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم الجلوس
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="certificateٍٍٍSeatNo0" runat="server" Columns="60" Text='<%# Bind("CertificateSeatNo")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            المجموع الكلي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="certificateTotalResult0" runat="server" Text='<%# Bind("CertificateTotalResult")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            النسبة المئوية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="certificateResultPercentage0" runat="server" Text='<%# Bind("CertificateResultPercentage")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            بيانات المدرسة
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            المدرسة
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="school0" runat="server" Text='<%# Bind("ArSchoolName")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            اللغات التي يجيدها
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اختر اللغة الأولى
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="firstLanguage0" runat="server" Text='<%# Bind("ArFirstLanguageName")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اختر اللغة الثانية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="secondLanguage0" runat="server" Text='<%# Bind("ArSecondLanguageName")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="contactTab" runat="server" HeaderText="بيانات الاتصال">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            العنوان(ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="arAddress0" runat="server" Text='<%# Bind("ArStudentAddress")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            العنوان(En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="address0" runat="server" Text='<%# Bind("StudentAddress")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            المنطقة - البلد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="addressLocation0" runat="server" Text='<%# Bind("StudentAddressLocation")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم التليفون
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentPhone0" runat="server" Text='<%# Bind("StudentPhone")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentMobile0" runat="server" Text='<%# Bind("StudentMobile")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            البريد الاليكتروني
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentEmail0" runat="server" Text='<%# Bind("StudentEmail")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            حساب الفيس بوك
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentFacebook0" runat="server" Text='<%# Bind("StudentFacebook")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            حساب تويتر
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="studentTwitter0" runat="server" Text='<%# Bind("StudentTwitter")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="familyTab" runat="server" HeaderText="بيانات العائلة">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            اسم الأب (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="arFatherName0" runat="server" Text='<%# Bind("ArFatherName")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            اسم الاب (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="fatherName0" runat="server" Text='<%# Bind("FatherName")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            وظيفة الأب
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="arFatherJob0" runat="server" Text='<%# Bind("ArFatherJob")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            وظيفة الأب (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="fatherJob0" runat="server" Text='<%# Bind("FatherJob")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="fahterMobile0" runat="server" Text='<%# Bind("FatherMobile")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            البريد الاليكتروني
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="fatherEmail0" runat="server" Text='<%# Bind("FatherEmail")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            اسم الام (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="arMotherName0" runat="server" Text='<%# Bind("ArMotherName")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            اسم الام (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="motherName0" runat="server" Text='<%# Bind("MotherName")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            وظيفة الام (ع)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="arMotherJob0" runat="server" Text='<%# Bind("ArMotherJob")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%">
                                                                            وظيفة الام (En)
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="motherJob0" runat="server" Text='<%# Bind("MotherJob")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            رقم الموبايل
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="motherMobile0" runat="server" Text='<%# Bind("MotherMobile")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="activityTab" runat="server" HeaderText="الانشطة والهوايات">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            النشاط
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="activity0" runat="server" Text='<%# Bind("ArActivityName")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            مكان النشاط
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="activityPlace0" runat="server" Text='<%# Bind("ActivityPlace")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            البطولة الحاصل عليها
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:Label ID="activityChamp0" runat="server" Text='<%# Bind("ActivityChampionship")%>'></asp:Label>
                                                                        </td>
                                                                        <td class="label" style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ الحصول عليها
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:Label ID="activityChampDate0" runat="server" Text='<%# Bind("ActivityChampionshipDate", "{0:dd/MM/yyyy}")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <th class="HeaderStyle" style="padding-top: 7px; padding-bottom: 7px">
                                                                            الهوايات
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                        <th class="HeaderStyle">
                                                                        </th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" valign="top">
                                                                            الهواية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="hoppy0" runat="server" Text='<%# Bind("ArHoppyName")%>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            مكان الهواية
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="hoppyPlace0" runat="server" Text='<%# Bind("HoppyPlace")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="armyTab" runat="server" HeaderText="التجنيد">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            حالة التجنيد
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="armyStatus0" runat="server" Text='<%# Bind("ArArmyStatusName")%>'>
                                                                 
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td class="label" style="width: 20%; padding-right: 30px">
                                                                            الرقم الثلاثي
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="thiroidNo0" runat="server" Columns="60" Text='<%# Bind("ThirdNumber")%>'></asp:Label>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم التأجيل
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:Label ID="exemptedNo0" runat="server" Columns="60" Text='<%# Bind("ExemptedNumber")%>'></asp:Label>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td class="label" style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ التأجيل
                                                                        </td>
                                                                        <td class="label" style="padding-top: 7px">
                                                                            <asp:Label ID="exemptedDate0" runat="server" Columns="12" Text='<%# Bind("ExemptedDate","{0:dd/MM/yyyy}")%>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            منطوق القرار
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="operativeDecision0" runat="server" Text='<%# Bind("OperativeDecision")%>'></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                        <ajaxToolkit:TabPanel ID="acceptanceTab" runat="server" HeaderText="القبول">
                                                            <ContentTemplate>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="98%">
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            حالة القبول
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="ddlAcceptance0" runat="server" Text='<%# Bind("ArAcceptanceName") %>'>
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ القبول
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:Label ID="txtAcceptanceDate0" runat="server" Text='<%# Bind("AcceptanceDate","{0:dd/MM/yyyy}") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            رقم القبول
                                                                        </td>
                                                                        <td class="input" style="width: 20%">
                                                                            <asp:Label ID="txtAcceptanceNumber0" runat="server" Text='<%# Bind("AcceptanceNumber") %>'></asp:Label>
                                                                            <%-- <asp:RequiredFieldValidator ID="EnBriefRequired1" runat="server" ControlToValidate="txtEnBrief1"
                                                                                ErrorMessage="Please enter english brief" Display="None"></asp:RequiredFieldValidator>--%>
                                                                        </td>
                                                                        <td style="padding-top: 7px; padding-right: 30px">
                                                                            تاريخ التحويل
                                                                        </td>
                                                                        <td style="padding-top: 7px">
                                                                            <asp:Label ID="txtTransferDate0" runat="server" Text='<%# Bind("TransferDate","{0:dd/MM/yyyy}") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="label" style="width: 20%">
                                                                            الجهة المحول منها
                                                                        </td>
                                                                        <td class="input">
                                                                            <asp:Label ID="txtTransferFrom0" runat="server" Text='<%# Bind("TransferFrom") %>'></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 10px">
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </ajaxToolkit:TabPanel>
                                                    </ajaxToolkit:TabContainer>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
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
                                            <asp:Label ID="imgErr" runat="server" CssClass="error" EnableViewState="False" Visible="false">An error occurred, only images are allowed.</asp:Label>
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
                    <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" runat="server" id="SearchTbl" Visible="false" >
                        <tr>
                            <td class="label">
                                كود الطالب
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtٍStudentCode" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الاسم الاول
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الاسم الثاني
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtSecondName" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الاسم الثالث
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                العام الدراسي
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="years31" runat="server" DataSourceID="YearsDS31" DataValueField="YearId"
                                    DataTextField="YearName" AppendDataBoundItems="True" Width="200px" >
                                    <asp:ListItem Text="--- اختر ---" Value="0" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="YearsDS31" runat="server" SelectMethod="GetAll" TypeName="TeiLib.YearsDAL">
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الشعبة
                            </td>
                            <td class="input">
                                <asp:DropDownList ID="departmentDDL" runat="server" DataSourceID="departmentDS" DataValueField="DepartmentId"
                                    DataTextField="ArDepartmentName" AppendDataBoundItems="True" Width="200px">
                                    <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="departmentDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.DepartmentsDAL">
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center" class="button">
                                <asp:LinkButton ID="btnSearch" runat="server" CssClass="linkbtn" Text="بحث" OnClick="btnSearch_Click"></asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                    <table cellpadding="0" cellspacing="0" border="0" width="610px">
                        <tr>
                            <td colspan="3">
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnAdd" runat="server" CssClass="button" Text="أضف طالب جديد" Style="direction: ltr"
                                                 OnClick="btnAdd_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdStudents" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowPaging="True"
                                    AllowSorting="True" OnRowDeleted="grdStudents_RowDeleted" OnSelectedIndexChanged="grdStudents_SelectedIndexChanged"
                                    DataKeyNames="StudentId" OnDataBound="grdStudents_DataBound" DataSourceID="StudentsDataSource"
                                    OnRowCommand="grdStudents_RowCommand" Visible="false">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <PagerStyle CssClass="PagerStyle" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد طلاب
                                        </div>
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#"></asp:BoundField>
                                        <asp:TemplateField HeaderText="كود الطالب" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="viewStudent" runat="server" Text='<%# Eval("StudentCode") %>'
                                                    CausesValidation="False" CommandName="ViewData" CommandArgument='<%# Eval("StudentId") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ArFullName" HeaderText="اسم الطالب" SortExpression="ArFullName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="ArDepartmentName" HeaderText="الشعبة" SortExpression="ArDepartmentName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="YearName" HeaderText="العام الدراسي" SortExpression="YearName"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:ButtonField CommandName="Select" HeaderText="تعديل" Text="تعديل" HeaderStyle-Width="70px"
                                            ItemStyle-Width="50px" />
                                        <asp:TemplateField HeaderText="طباعة بيانات" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <a href='<%# "StudentInfo.aspx?iframe=true&width=100%&height=100%&StudentId="+Eval("StudentId")%>'
                                                    rel="prettyPhoto[iframes]" title='<%# Eval("ArFullName") %>'>طباعة بيانات</a>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حذف" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="btnDelete" runat="server" Text="حذف" CausesValidation="False" Visible='<%# CurrentUser.GetUserId() == "1"%>'
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
                                <%--<asp:LinkButton CausesValidation="False" CssClass="linkbtn" ID="btnUpdate" runat="server"
                                    ToolTip="Update Hide Values" OnClick="btnUpdate_Click">تحديث</asp:LinkButton>--%>
                            </td>
                            <td align="center">
                                <asp:Label ID="deleteErr" runat="server" CssClass="error" EnableViewState="False"
                                    Visible="False">خطأ أثناء الحذف.</asp:Label>
                            </td>
                            <%--<td align="left">
                                <asp:LinkButton ID="btnAdd1" runat="server" CssClass="linkbtn" OnClick="btnAdd_Click" Visible="false">أضف طالب جديد</asp:LinkButton>
                                <%----%>
                            </td>
                        </tr>
                    </table>
                    <asp:ObjectDataSource ID="StudentsDataSource" runat="server" DeleteMethod="Delete"
                        SelectMethod="GetByPage" SelectCountMethod="GetRowsCount" TypeName="TeiLib.StudentsDAL"
                        EnablePaging="true" OnDeleted="DataSourceDeleted" OnSelecting="StudentsDataSource_Selecting">
                        <SelectParameters>
                            <asp:Parameter Name="StudentCode" Type="String" />
                            <asp:Parameter Name="ArFirstName" Type="String" />
                            <asp:Parameter Name="ArMiddleName" Type="String" />
                            <asp:Parameter Name="ArLastName" Type="String" />
                            <asp:Parameter Name="SemesterId" Type="Int32" />
                            <asp:Parameter Name="YearId" Type="Int32" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:Parameter Name="StudentId" Type="Int32" />
                        </DeleteParameters>
                    </asp:ObjectDataSource>
                </asp:View>
                <asp:View ID="NoAccessView" runat="server">
                    <h2 id="noAccess">
                        غير مسموح لك دخول هذه الصفحة</h2>
                </asp:View>
            </asp:MultiView>
            <asp:ObjectDataSource ID="StudentsDS" runat="server" DataObjectTypeName="TeiLib.Student"
                InsertMethod="Insert_Terms" SelectMethod="GetById" UpdateMethod="Update" TypeName="TeiLib.StudentsDAL"
                OnInserted="StudentsDS_Inserted">
                <SelectParameters>
                    <asp:ControlParameter ControlID="grdStudents" Name="studentId" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
                <InsertParameters>
                    <asp:Parameter Direction="Output" Name="StudentId" Type="Int32" />
                </InsertParameters>
            </asp:ObjectDataSource>
            <asp:Label ID="lblStudentId" runat="server" Text="0" Visible="false"></asp:Label>
      <%--  </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="StudentsForm" />
           
        </Triggers>
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
    </asp:UpdateProgress>--%>
     
</asp:Content>
