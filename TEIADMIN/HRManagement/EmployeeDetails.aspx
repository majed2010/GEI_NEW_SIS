<%@ Page Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="EmployeeDetails.aspx.cs"
    Inherits="EmployeeDetails" Title=".:: موظفين ::." %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    الموظفين
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
<%--<asp:UpdatePanel ID  = "Update1" runat = "server">
    <ContentTemplate>--%>
      <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1"
        SelectedIndex="0" Skin="Office2007" CausesValidation = "false">
        <Tabs>
             <telerik:RadTab runat="server" Text="تعريف الموظف" PageViewID="RadPageView1" 
                Selected="True">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="معلومات عامة"
                PageViewID="RadPageView2">
            </telerik:RadTab>
             <telerik:RadTab runat="server" Text="معلومات عن الوظيفه" PageViewID="RadPageView3">
            </telerik:RadTab>
             <telerik:RadTab runat="server" Text="الدرجات العلميه" PageViewID="RadPageView4">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="خبرات العمل السابقه" PageViewID="RadPageView5">
            </telerik:RadTab>
        </Tabs>
    </telerik:RadTabStrip>
    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="0" 
        Width="100%">
        <telerik:RadPageView ID="RadPageView1" runat="server" Width="100%">
            <div style="height: 30%">
            </div>
            <div style="width: 100%">
                <asp:Panel ID="Panel1" runat="server" Width="100%" GroupingText="<B>المعلومات بالعربيه</B>">
                
                 <table cellpadding="2" cellspacing="2" border="0" width="300" class="form">
                        <tr>
                            <td class="label">
                              الاسم الاول
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txt_Emp_First_Name" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                               الاسم الثاني
                            </td>
                            <td class="input">
                             <asp:TextBox ID="txt_Emp_Second_Name" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                اسم العائله
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txt_Family_Name" runat="server" AutoPostBack="True" 
                                    ontextchanged="txt_Family_Name_TextChanged" ></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                الاسم كامل
                            </td>
                            <td class="input" >
                                <asp:TextBox ID="txt_Full_Name" runat="server" Enabled="False" 
                                    AutoPostBack="True"></asp:TextBox>
                            </td>
                        </tr>
                      
                    </table>
                </asp:Panel>
                <div style="height: 30%">
                </div>
                <asp:Panel ID="Panel3" runat="server" Width="100%" GroupingText="<b>العناوين و ارقام التلفونات</b>">
                 <table cellpadding="2" cellspacing="2" border="0" width="300" class="form">
                        <tr>
                            <td class="label">
                              العنوان
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txt_Address" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                               رقم المنزل
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txt_Home_Tel" runat="server"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "txt_Home_Tel" 
                                    ValidationExpression="^\d+$" ></asp:RegularExpressionValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                                رقم الموبايل
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txt_Mobile" runat="server"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "txt_Mobile" 
                                    ValidationExpression="^\d+$" ></asp:RegularExpressionValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                               البريد الالكتروني
                            </td>
                            <td class="input" >
                            
                                <telerik:RadTextBox ID="txt_E_Mail" runat="server">
                                </telerik:RadTextBox>
                                      <asp:RegularExpressionValidator ID="RegularExpressionValidator14" runat="server" 
                                    ErrorMessage="Email not In Correct form" ControlToValidate =  "txt_E_Mail" 
                                    ValidationExpression="^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$" ></asp:RegularExpressionValidator>
                            </td>
                        </tr>
                      
                    </table>
                </asp:Panel>
                <asp:Panel ID="Panel9" runat="server" Width="100%">
                    <div style="width: 100%; float: left; text-align: center;">
                       
                        <asp:Button ID="btn_Save" runat="server" Text="حفظ" Width="59px" OnClick="btn_Save_Click" />&#160;<asp:Button
                            ID="btn_Back" runat="server" Text="الرجوع" Width="59px" 
                            OnClick="btn_Back_Click" CausesValidation="False" /></div>
                </asp:Panel>
            </div>
        </telerik:RadPageView>
                <telerik:RadPageView ID="RadPageView2" runat="server" Width="100%">
            <div style="height: 30%">
            </div>
            <div style="width: 100%">
                <div style="height: 30%">
                </div>
                <asp:Panel ID="Panel6" runat="server" Width="100%" GroupingText="<b> معلومات شخصيه</b>">
                     <table cellpadding="2" cellspacing="2" border="0" width="300" class="form">
                      <tr>
                                <td class="label">
                                   النوع 
                                </td>
                                <td class="input">
                                      <telerik:RadComboBox ID="ddr_gender" runat="server" MarkFirstMatch="True" 
                                    Height="200px">
                                          <Items>
                                              <telerik:RadComboBoxItem runat="server" Text="ذكر" Value="0" />
                                              <telerik:RadComboBoxItem runat="server" Text="انثى" Value="1" />
                                          </Items>
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                   موقف التجنيد
                                </td>
                                <td class="input">
                                      <telerik:RadComboBox ID="Military_txt" runat="server" MarkFirstMatch="True" 
                                    Height="200px">
                                          <Items>
                                              <telerik:RadComboBoxItem runat="server" Text="اختر...." Value="0" />
                                              <telerik:RadComboBoxItem runat="server" Text="قضت" Value="1" />
                                              <telerik:RadComboBoxItem runat="server" Text="مؤجل" Value="2" />
                                              <telerik:RadComboBoxItem runat="server" Text="اعفاء" Value="3" />
                                          </Items>
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                   الجنسية
                                </td>
                                <td class="input">
                                
                                   <telerik:RadComboBox ID="txt_Nationality" runat="server" MarkFirstMatch="true" 
                                    Height="200px">
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                   نوع تعريف الشخصيه
                                </td>
                                <td class="input">
                                    
                                 <telerik:RadComboBox ID="ID_type_txt" runat="server" MarkFirstMatch="True" 
                                    Height="200px">
                                     <Items>
                                         <telerik:RadComboBoxItem runat="server" Text="ااختر..." Value="0" />
                                         <telerik:RadComboBoxItem runat="server" Text="بطاقه مدنيه" Value="1" />
                                         <telerik:RadComboBoxItem runat="server" Text="جواز سفر" Value="2" />
                                     </Items>
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                    رقم تعريف الشخصيه
                                </td>
                                <td class="input" >
                                    <asp:TextBox ID="txt_ID_No" runat="server" 
                                        ontextchanged="txt_ID_No_TextChanged" AutoPostBack="True" ></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator8" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "txt_ID_No" 
                                    ValidationExpression="^\d+$" ></asp:RegularExpressionValidator>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txt_ID_No"
                                    Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                    تاريخ الاصدار
                                </td>
                            
                                
                                  <td style="padding-top: 7px">
                                <asp:TextBox ID="RDP_issue_date" runat="server" Columns="12"></asp:TextBox>
                                <asp:ImageButton runat="server" ID="ImageButton1" CausesValidation="False" ImageUrl="~/images/calendar.gif"
                                    AlternateText="Select Date" />
                                <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                    TargetControlID="RDP_issue_date" PopupButtonID="ImageButton1" Enabled="True" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="RDP_issue_date"
                                    Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="RDP_issue_date"
                                    ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                    SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                            </td>
                            
                            </tr>
                             <tr>
                                <td class="label">
                                    مكان الاصدار
                                </td>
                                <td class="input" >
                                    
                                    <telerik:RadComboBox ID="txt_issue_place" runat="server" MarkFirstMatch="True" 
                                    Height="200px">
                                     
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                              <tr>
                                <td class="label">
                                    الحالة الاجتماعيه
                                </td>
                                <td class="input" >
                                       
                                 <telerik:RadComboBox ID="Marital_txt" runat="server" MarkFirstMatch="True" 
                                    Height="200px">
                                     <Items>
                                         <telerik:RadComboBoxItem runat="server" Text="اختر...." Value="0" />
                                         <telerik:RadComboBoxItem runat="server" Text="اعزب" Value="1" />
                                         <telerik:RadComboBoxItem runat="server" Text="متزوج" Value="2" />
                                         <telerik:RadComboBoxItem runat="server" Text="مطلق" Value="3" />
                                         <telerik:RadComboBoxItem runat="server" Text="ارمل" Value="4" />
                                     </Items>
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                    تاريخ الميلاد
                                </td>
                                
                                 <td style="padding-top: 7px">
                                <asp:TextBox ID="RadDatePicker1" runat="server" Columns="12"></asp:TextBox>
                                <asp:ImageButton runat="server" ID="ImageButton2" CausesValidation="False" ImageUrl="~/images/calendar.gif"
                                    AlternateText="Select Date" />
                                <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                    TargetControlID="RadDatePicker1" PopupButtonID="ImageButton2" Enabled="True" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="RadDatePicker1"
                                    Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="RadDatePicker1"
                                    ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                    SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                            </td>
                            
                            </tr>
                                <tr>
                                <td class="label">
                                    محل الميلاد
                                </td>
                                <td class="input" >
                                  
                                          
                                 <telerik:RadComboBox ID="txt_place_of_birth" runat="server" MarkFirstMatch="true" 
                                    Height="200px">
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                        </table>
                </asp:Panel>
                <asp:Panel ID="Panel8" runat="server" Width="100%">
                    <div style="width: 100%; float: left; text-align: center;">
                        <asp:Button ID="Button1" runat="server" Text="حفظ" Width="59px" OnClick="btn_Save_Click" />&#160;<asp:Button
                            ID="Button4" runat="server" Text="الرجوع" Width="59px" 
                            OnClick="btn_Back_Click" CausesValidation="False" /></div>
                </asp:Panel>
                <div style="height: 30%">
                </div>
            </div>
        </telerik:RadPageView>
               <telerik:RadPageView ID="RadPageView3" runat="server" Width="100%">
            <div style="height: 30%">
            </div>
            <div style="width: 100%">
                <asp:Panel ID="Panel7" runat="server" Width="100%" GroupingText="&lt;b&gt;معلومات عن التامين&lt;/b&gt;">
                 <table cellpadding="2" cellspacing="2" border="0" width="300" class="form">
                            <tr>
                                <td class="label">
                                  الرقم التاميني
                                </td>
                                <td  class="input">
                                 <asp:TextBox ID="txt_insure_no" runat="server" Text = "0"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator9" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "txt_insure_no" 
                                    ValidationExpression="^\d+$" ></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                   تاريخ التامين
                                </td>
                                
                                    <td style="padding-top: 7px">
                                <asp:TextBox ID="rdp_insurance_date" runat="server" Columns="12"></asp:TextBox>
                                <asp:ImageButton runat="server" ID="ImageButton3" CausesValidation="False" ImageUrl="~/images/calendar.gif"
                                    AlternateText="Select Date" />
                                <ajaxToolkit:CalendarExtender ID="CalendarExtender3" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                    TargetControlID="rdp_insurance_date" PopupButtonID="ImageButton3" Enabled="True" />
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="rdp_insurance_date"
                                    ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                    SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                            </td>
                            
                            </tr>
                            <tr>
                                <td class="label">
                                رقم صفحة التامين
                                </td>
                                <td class="input">
                                    <asp:TextBox ID="txt_ins_page" runat="server" Text = "0"></asp:TextBox>
                                      <asp:RegularExpressionValidator ID="RegularExpressionValidator10" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "txt_ins_page" 
                                    ValidationExpression="^\d+$" ></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                    <asp:CheckBox ID="chk_worked_before" runat="server"  Checked = "false" Text = "هل عمل من قبل ؟"/>
                                </td>
                                
                            </tr>
                            <tr>
                                <td class="label">
                                    نوع العمل
                                </td>
                                <td class="input" >
                                         <telerik:RadComboBox ID="cmb_job_type" runat="server" MarkFirstMatch="true" 
                                    Height="200px">
                                    <Items>
                                              <telerik:RadComboBoxItem runat="server" Text="اختر...." Value="0" />
                                              <telerik:RadComboBoxItem runat="server" Text="تعيين" Value="1" />
                                              <telerik:RadComboBoxItem runat="server" Text="انتداب" Value="2" />
                                              <telerik:RadComboBoxItem runat="server" Text="انتداب جزئي" Value="3" />
                                              </Items>
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                    مكان الانتداب في حالةالانتداب الجزئي فقط
                                </td>
                                <td class="input" >
                                    <asp:TextBox ID="txt_jobt_type_place" runat="server"></asp:TextBox>  
                               
                                </td>
                            </tr>
                             <tr>
                                <td class="label">
                                    المسمى الوظيفي
                                </td>
                                <td class="input" >
                                          <telerik:RadComboBox ID="cmb_job_title" runat="server" MarkFirstMatch="True" 
                                    Height="200px">
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                        ErrorMessage="**" ControlToValidate = "cmb_job_title" InitialValue = "0"></asp:RequiredFieldValidator>
                                        
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                    تاريخ استلام العمل 
                                </td>
                               
                                
                                     <td style="padding-top: 7px">
                                <asp:TextBox ID="rdp_job_date" runat="server" Columns="12"></asp:TextBox>
                                <asp:ImageButton runat="server" ID="ImageButton4" CausesValidation="False" ImageUrl="~/images/calendar.gif"
                                    AlternateText="Select Date" />
                                <ajaxToolkit:CalendarExtender ID="CalendarExtender4" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                    TargetControlID="rdp_job_date" PopupButtonID="ImageButton4" Enabled="True" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="rdp_job_date"
                                    Display="Dynamic" SetFocusOnError="True" Text="*"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="rdp_job_date"
                                    ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                    SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                            </td>
                            
                            </tr>
                         <tr>
                                <td class="label">
                                   المرتب الاساسي
                                </td>
                                <td class="input" >
                                    <asp:TextBox ID="txt_basic_salary" runat="server">0</asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator11" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "txt_basic_salary" 
                                    ValidationExpression="^\d*\.?\d*$" ></asp:RegularExpressionValidator>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                   المرتب المتغير
                                </td>
                                <td class="input" >
                                    <asp:TextBox ID="txt_var_salary" runat="server">0</asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator12" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "txt_var_salary" 
                                    ValidationExpression="^\d*\.?\d*$" ></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                   مرتب الموظف
                                </td>
                                <td class="input" >
                                    <asp:TextBox ID="TextBox6" runat="server"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator13" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "TextBox6" 
                                    ValidationExpression="^\d*\.?\d*$" ></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                             <tr>
                                <td class="label">
                                  الادارةالتابع لهاالموظف
                                </td>
                                <td class="input" >
                                    
                                    <telerik:RadComboBox ID="Dept_RCB" runat="server" MarkFirstMatch="true" 
                                Height="200px">
                                <CollapseAnimation Duration="200" Type="OutQuint" />
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                        ErrorMessage="**" ControlToValidate = "Dept_RCB" InitialValue = "0"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                        </table>
                </asp:Panel>
                <div style="height: 30%">
                </div>
                <asp:Panel ID="Panel11" runat="server" Width="100%">
                    <div style="width: 100%; float: left; text-align: center;">
                  
                        <asp:Button ID="btn_Save3" runat="server" Text="حفظ" Width="59px" OnClick="btn_Save_Click" />&#160;<asp:Button
                            ID="btn_Back3" runat="server" Text="الرجوع" Width="59px" 
                            OnClick="btn_Back_Click" CausesValidation="False" /></div>
                    
                </asp:Panel>
            </div>
        </telerik:RadPageView>
        <telerik:RadPageView ID="RadPageView4" runat="server" Width="100%">
            <div style="height: 30%">
            </div>
            <div style="width: 100%">
                <asp:Panel ID="Panel4" runat="server" Width="100%" GroupingText="<B>الـــدرجات العــــلميــــة</B>">
                    <div style="width: 100%"align = "center" >
                        <asp:GridView ID="grd_scientific" runat="server" AutoGenerateColumns="False"  
                            CssClass="GridViewStyle" CellPadding="4" ForeColor="#333333" 
                            EmptyDataText = "لا يوجد شهادات علميه" Width= "100%" 
                            onrowcommand="grd_scientific_RowCommand">
                            <RowStyle BackColor="#EFF3FB" />
                            <Columns>
                                <asp:BoundField DataField="Emp_Scientific_Type_Name_ara" 
                                    HeaderText="نوع الشهاده" />
                                <asp:BoundField DataField="Emp_University_Degres_Name_ara" 
                                    HeaderText="الجامعه" />
                                <asp:BoundField DataField="Emp_Faculty_Degree_Name_ara" HeaderText="الكليه" />
                                <asp:BoundField DataField="Emp_Degree_Year" HeaderText="السنه" />
                                <asp:BoundField DataField="Emp_Degree_Desc_ara" HeaderText="التفاصيل" />
                                <asp:TemplateField HeaderText="حذف">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="LinkButton1" runat="server" 
                                            CommandArgument="<%# bind('Emp_Scientific_Degree_ID') %>" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>' CommandName = "Row_Delete">حذف</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <EditRowStyle BackColor="#2461BF" />
                            <AlternatingRowStyle BackColor="White" />
                        </asp:GridView>
                         <asp:LinkButton ID="btn_Add" runat="server" onclick="btn_Add_Click" 
                            CausesValidation="False">اضافة شهاده</asp:LinkButton>
                    </div>
                    <div style="width: 100%"align = "center" >
                        <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" id = "add_cert" runat = "server">
                            <tr>
                                <td class="label">
                                   الشهاده
                                </td>
                                <td class="input">
                                      <telerik:RadComboBox ID="ddr_certificate_type" runat="server" MarkFirstMatch="True" 
                                    Height="200px">
                                
                                          <Items>
                                              <telerik:RadComboBoxItem runat="server" Text="اختر شهاده" Value="0" />
                                              <telerik:RadComboBoxItem runat="server" Text="شهادة البكالوريوس" Value="1" />
                                              <telerik:RadComboBoxItem runat="server" Text="شهادة اللصنص" Value="2" />
                                              <telerik:RadComboBoxItem runat="server" Text="شهادة الماجستير" Value="3" />
                                              <telerik:RadComboBoxItem runat="server" Text="شهادةالدكتوراه" Value="4" />
                                              <telerik:RadComboBoxItem runat="server" Text="درجة الاستاذيه" Value="5" />
                                          </Items>
                                
                                    <CollapseAnimation Duration="200" Type="OutQuint" />
                                
                                </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                   الجامعه
                                </td>
                                <td class="input">
                                    <asp:TextBox ID="University_txt" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                   الكلية
                                </td>
                                <td class="input">
                                    
                                 <asp:TextBox ID="txt_faculty" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="label">
                                    السنه
                                </td>
                                <td class="input" >
                                    <asp:TextBox ID="txt_Year" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator15" runat="server" 
                                    ErrorMessage="Only Numbers" ControlToValidate =  "txt_Year" 
                                    ValidationExpression="^\d+$" ></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                             <tr>
                                <td class="label">
                                    التفاصيل
                                </td>
                                <td class="input" >
                                    <asp:TextBox ID="TextBox2" runat="server" TextMode = "MultiLine"></asp:TextBox>
                                </td>
                            </tr>
                             <tr>
                            
                            <td class="label" >
                                <asp:LinkButton ID="btn_cancel_sc" runat="server" 
                                    onclick="btn_cancel_sc_Click" CausesValidation="False" >الغاء</asp:LinkButton> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="btn_save_sc" runat="server" onclick="btn_save_sc_Click" 
                                    Width="220px">حفظ شهادات</asp:LinkButton>
                            
                            </td>
                        </tr>
                        </table>
                    </div>  
                </asp:Panel>
                <div style="height: 30%">
                </div>
                
                <asp:Panel ID="Panel10" runat="server" Width="100%">
                    <div style="width: 100%; float: left; text-align: center;">
                        <asp:Button ID="btn_Save2" runat="server" Text="حفظ" Width="59px" OnClick="btn_Save_Click" />&#160;<asp:Button
                            ID="btn_Back2" runat="server" Text="الرجوع" Width="59px" 
                            OnClick="btn_Back_Click" CausesValidation="False" /></div>
                </asp:Panel>
                <div style="height: 30%">
                </div>
            </div>
        </telerik:RadPageView>
 
        <telerik:RadPageView ID="RadPageView5" runat="server" Width="100%">
            <div style="height: 30%">
            </div>
            <div style="width: 100%">
            
                <asp:Panel ID="Panel12" runat="server" Width="100%" GroupingText="&lt;b&gt;خبرات العمل السابقه&lt;/b&gt;">
                  <div style="width: 100%"align = "center" >
                        <asp:GridView ID="grd_prev_work" runat="server" AutoGenerateColumns="False"  
                            CssClass="GridViewStyle" CellPadding="4" ForeColor="#333333" 
                            EmptyDataText = "لا يوجد خبرات عمل سابقه" Width = "100%" 
                            onrowcommand="grd_prev_work_RowCommand">
                            <RowStyle BackColor="#EFF3FB" />
                            <Columns>
                            
                             <asp:BoundField DataField="Work_Place_Name_ara" 
                                    HeaderText="مكان العمل السابق" />
                                <asp:BoundField DataField="Work_Title_Name_ara" 
                                    HeaderText="المسمى الوظيفي" />
                                <asp:BoundField DataField="Leave_Reason_ara" 
                                    HeaderText="  اسباب ترك العمل" />
                                <asp:BoundField DataField="Work_From" 
                                    HeaderText="بدءالعمل في" />
                                <asp:BoundField DataField="Work_To" HeaderText="ترك العمل من" />
                                <asp:TemplateField HeaderText="حذف">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="LinkButton1" runat="server" 
                                            CommandArgument="<%# bind('Emp_Work_ID') %>" CommandName = "Row_Delete" OnClientClick='<%# "return confirm(\"Are you sure you want to continue?\")"%>'>حذف</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <EditRowStyle BackColor="#2461BF" />
                            <AlternatingRowStyle BackColor="White" />
                        </asp:GridView>
                         <asp:LinkButton ID="btn_add_new_prev_work" runat="server" 
                            onclick="btn_add_new_prev_work_Click" CausesValidation="False">اضافة خبرات عمل سابقة</asp:LinkButton>
                    </div>
                    <div style="width: 100%"align = "center" >
                        <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" id = "Div_add_work_prev" runat = "server">
                        <tr>
                            <td class="label">
                              مكان العمل السابق
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txt_Work_Place_Name_ara" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                               المسمى الوظيفي
                            </td>
                            <td class="input">
                                <asp:TextBox ID="txt_job_title_prev" runat="server"></asp:TextBox>
                                
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                               اسباب ترك العمل
                            </td>
                            <td class="input">
                               <asp:TextBox ID="txt_leave_work" textmode ="MultiLine"  runat="server"></asp:TextBox>
                                
                            </td>
                        </tr>
                        <tr>
                            <td class="label">
                               بدء العمل من
                            </td>

                            
                                   <td style="padding-top: 7px">
                                <asp:TextBox ID="RadDP_start_work_prev" runat="server" Columns="12"></asp:TextBox>
                                <asp:ImageButton runat="server" ID="ImageButton5" CausesValidation="False" ImageUrl="~/images/calendar.gif"
                                    AlternateText="Select Date" />
                                <ajaxToolkit:CalendarExtender ID="CalendarExtender5" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                    TargetControlID="RadDP_start_work_prev" PopupButtonID="ImageButton5" Enabled="True" />
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="RadDP_start_work_prev"
                                    ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                    SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                            </td>
                            
                        </tr>
                         <tr>
                            <td class="label">
                               ترك العمل في
                            </td>
                      
                            
                             <td style="padding-top: 7px">
                                <asp:TextBox ID="RadDP_end_work_prev" runat="server" Columns="12"></asp:TextBox>
                                <asp:ImageButton runat="server" ID="birthdateImg1" CausesValidation="False" ImageUrl="~/images/calendar.gif"
                                    AlternateText="Select Date" />
                                <ajaxToolkit:CalendarExtender ID="Calendar" runat="server" CssClass="Calendar" Format="dd/MM/yyyy"
                                    TargetControlID="RadDP_end_work_prev" PopupButtonID="birthdateImg1" Enabled="True" />
                           
                                <asp:RegularExpressionValidator ID="DateValidator" runat="server" ControlToValidate="RadDP_end_work_prev"
                                    ValidationExpression="([0]?[1-9]|[1|2][0-9]|[3][0|1])/([0]?[1-9]|[1][0-2])/((19|20)[0-9]{2})"
                                    SetFocusOnError="True">تاريخ غير صحيح</asp:RegularExpressionValidator>
                            </td>
                                                                        
                        </tr>
                       <tr>
                            
                            <td class="label" >
                                <asp:LinkButton ID="btn_cancel_prev_work" runat="server" 
                                    onclick="btn_cancel_prev_work_Click" CausesValidation="False">الغاء</asp:LinkButton> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="btn_save_prev_work" runat="server" 
                                    onclick="btn_save_prev_work_Click" Width = "220px">حفظ خبرات العمل</asp:LinkButton>
                            
                            </td>
                        </tr>
                    </table>
                    </div>
                  <div style="height: 30%">
            </div>
                  </asp:Panel>
            <asp:Panel ID="Panel13" runat="server" Width="100%">
                    <div style="width: 100%; float: left; text-align: center;">
                  
                        <asp:Button ID="Button2" runat="server" Text="حفظ" Width="59px" OnClick="btn_Save_Click" />&#160;<asp:Button
                            ID="Button3" runat="server" Text="الرجوع" Width="59px" 
                            OnClick="btn_Back_Click" CausesValidation="False" /></div>
                    
                </asp:Panel>
            </div>
        </telerik:RadPageView>
    </telerik:RadMultiPage>
    
<%--        </ContentTemplate>
</asp:UpdatePanel>
--%>
        <telerik:RadWindowManager ID="RadWindowManager2" runat="server">
        <Windows>
        <telerik:RadWindow ID="RadWindow1" OnClientClose="ReloadForm" NavigateUrl="getBackReason.aspx"
                        Skin="Vista" VisibleOnPageLoad="false" OffsetElementID="offsetElement" runat="server"
                        Width="80%" Height="600px" ReloadOnShow="true" />
        
        </Windows>
        </telerik:RadWindowManager>  
</asp:Content>
