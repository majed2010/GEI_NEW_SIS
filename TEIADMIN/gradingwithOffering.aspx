<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="gradingwithOffering.aspx.cs" Inherits="gradingwithOffering" EnableEventValidation="false" %>

<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">

    <script type="text/javascript">
function fnClientFunction(source, arguments)
{
  if (arguments.Value>0 || arguments.Value==<41) 
    arguments.IsValid=true; 
  else 
    arguments.IsValid=false;
}




//   function verify_text(control,name,maxValue) {
//   alert('hello');
////      if (control.value < 0) {
////       alert('the '+name+' must be more than '+minValue);
////      }
////      else if(control.value > maxValue) {
////       alert('the '+name+' must be less than '+maxValue);
////      }
//   }

    </script>

</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
    رصد درجات الطلاب
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">

    <script type="text/javascript">
        function verify_text(control, name, maxValue) {
            //   alert('hello');
            if (control.value < 0) {
                alert('درجة' + name + 'يجب أن تكون أكبر من ' + '0');
                control.style.background = '#FABBBC';
                control.focus();
            }
            else if (control.value > maxValue) {
                alert('درجة' + name + 'يجب أن تكون أقل من ' + maxValue);

                control.style.background = '#FABBBC';
                control.focus();
            }
            else if (control.value == '') {
                alert('من فضلك قم بادخال درجة');

                control.style.background = '#FABBBC';
                control.focus();
            }
            else {
                control.style.background = 'white';
            }
        }
    </script>

    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>
            <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="0">
                <asp:View ID="FormView" runat="server">
                    <div id="accordion-container">
                        <h2 class="accordion-header">
                            رصد الدرجات</h2>
                       
                        <div class="accordion-content">
                            <div style="height: auto; overflow: auto;">
                                <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            الفصل الدراسي
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:DropDownList ID="semesters" runat="server" DataSourceID="SemesterDS" DataValueField="SemesterId"
                                                DataTextField="ArSemesterName" AppendDataBoundItems="True" Width="200px">
                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:ObjectDataSource ID="SemesterDS" runat="server" SelectMethod="GetAll" TypeName="TeiLib.SemestersDAL">
                                            </asp:ObjectDataSource>
                                            <%--<asp:RequiredFieldValidator ID="semestersRequired" runat="server" ControlToValidate="semesters"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>AutoPostBack="true"--%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            القسم
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:DropDownList ID="depts" runat="server" DataSourceID="deptsDS" DataValueField="DepartmentId"
                                                DataTextField="ArDepartmentName" AppendDataBoundItems="True" Width="200px" AutoPostBack="true"
                                                OnSelectedIndexChanged="depts_SelectedIndexChanged">
                                                <asp:ListItem Text="-- اختر --" Value="0" Selected="True"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:HiddenField ID="hdnDeptId" runat="server" />
                                            <asp:ObjectDataSource ID="deptsDS" runat="server" SelectMethod="GetByUserId" TypeName="TeiLib.DepartmentsDAL">
                                            <SelectParameters>
                                            <asp:ControlParameter Name="departmentId" ControlID="hdnDeptId" PropertyName="Value"  DbType="Int32"/>
                                            </SelectParameters>
                                            </asp:ObjectDataSource>
                                            <%--<asp:RequiredFieldValidator ID="departmentsRequired" runat="server" ControlToValidate="departments"
                                ErrorMessage="*" InitialValue="0"></asp:RequiredFieldValidator>--%>
                                        </td>
                                    </tr>
                                         <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    المادة
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="courses" runat="server" Width="200px" OnSelectedIndexChanged="courses_SelectedIndexChanged" AutoPostBack="true">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                              <tr>
                                <td class="label" style="color: blue; width: 141px;">
                                    اسم المحاضر
                                </td>
                                <td class="input" style="width: 333px">
                                    <asp:DropDownList ID="ddlDoctor" runat="server"  ><%--OnSelectedIndexChanged="ddlDoctor_SelectedIndexChanged"--%>
                                       
                                    </asp:DropDownList>
                                    <%--<asp:HiddenField ID="hdnDoctorCoursesId" runat="server" />--%>
                                    
                                    <asp:RequiredFieldValidator ID="DoctorsRequired" runat="server" ControlToValidate="ddlDoctor" InitialValue="0"
                                ErrorMessage="*" ></asp:RequiredFieldValidator>

                                </td>
                            </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            التحريري
                                        </td>
                                        <td class="input" style="width: 333px">
                                            من:
                                            <asp:TextBox ID="finalFrom" runat="server" Width="100px">
                                            </asp:TextBox>
                                            إلى:
                                            <asp:TextBox ID="finalTo" runat="server" Width="100px">
                                            </asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            مجموع الدرجات
                                        </td>
                                        <td class="input" style="width: 333px">
                                            من:
                                            <asp:TextBox ID="totalFrom" runat="server" Width="100px">
                                            </asp:TextBox>
                                            إلى:
                                            <asp:TextBox ID="totalTo" runat="server" Width="100px">
                                            </asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            التقدير
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:DropDownList ID="gradesDDL" runat="server" Width="200px">
                                                <asp:ListItem Text="اختر" Value="0" Selected="True">
                                                </asp:ListItem>
                                                <asp:ListItem Text="A+" Value="1">
                                                </asp:ListItem>
                                                <asp:ListItem Text="A" Value="2">
                                                </asp:ListItem>
                                                <asp:ListItem Text="A-" Value="3">
                                                </asp:ListItem>
                                                <asp:ListItem Text="B+" Value="4">
                                                </asp:ListItem>
                                                <asp:ListItem Text="B" Value="5">
                                                </asp:ListItem>
                                                <asp:ListItem Text="C+" Value="6">
                                                </asp:ListItem>
                                                <asp:ListItem Text="C" Value="7">
                                                </asp:ListItem>
                                                <asp:ListItem Text="D+" Value="8">
                                                </asp:ListItem>
                                                <asp:ListItem Text="D" Value="9">
                                                </asp:ListItem>
                                                <asp:ListItem Text="D-" Value="10">
                                                </asp:ListItem>
                                                <asp:ListItem Text="F" Value="11">
                                                </asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            حالة الطالب
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:DropDownList ID="statesDDL" runat="server" Width="200px">
                                                <asp:ListItem Text="اختر" Value="0" Selected="True">
                                                </asp:ListItem>
                                                <asp:ListItem Text="حضر" Value="1">
                                                </asp:ListItem>
                                                <asp:ListItem Text="غياب" Value="2">
                                                </asp:ListItem>
                                                <asp:ListItem Text="عذر" Value="3">
                                                </asp:ListItem>
                                                <asp:ListItem Text="اخلال" Value="4">
                                                </asp:ListItem>
                                                  <asp:ListItem Text="ناجح" Value="5">
                                                </asp:ListItem>
                                                <asp:ListItem Text="راسب" Value="6">
                                                </asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            عدد مرات دخول الامتحان
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:TextBox ID="examTimes" runat="server" Width="200px">
                                            </asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="بحـث" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div style="clear: both; padding-top: 20px">
                    </div>
                    <div id="accordion-container">
                        <h2 class="accordion-header">
                            إضـافـة معــامـل تحســــين</h2>
                        <div class="accordion-content">
                            <div style="height: auto; overflow: auto;">
                                <table cellpadding="2" cellspacing="2" border="0" class="form" align="right">
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            العملي
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:TextBox ID="practicalFactor" runat="server"></asp:TextBox>
                                            <ajaxToolkit:FilteredTextBoxExtender ID="practicalFactorExtender" runat="server"
                                                TargetControlID="practicalFactor" FilterType="Custom,Numbers" ValidChars=".">
                                            </ajaxToolkit:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            أعمال السنة
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:TextBox ID="performanceFactor" runat="server"></asp:TextBox>
                                            <ajaxToolkit:FilteredTextBoxExtender ID="performanceFactorFilter" runat="server"
                                                TargetControlID="performanceFactor" FilterType="Custom,Numbers" ValidChars=".">
                                            </ajaxToolkit:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                            التحريري
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:TextBox ID="finalFactor" runat="server"></asp:TextBox>
                                            <ajaxToolkit:FilteredTextBoxExtender ID="finalFactorFilter" runat="server" TargetControlID="finalFactor"
                                                FilterType="Custom,Numbers" ValidChars=".">
                                            </ajaxToolkit:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="label" style="color: blue; width: 141px;">
                                        </td>
                                        <td class="input" style="width: 333px">
                                            <asp:Button ID="btnAddFactor" runat="server" OnClick="btnAddFactor_Click" Text="أضافة" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div style="clear: both">
                    </div>
                    <table cellpadding="0" cellspacing="0" border="0" width="800px">
                        <tr>
                            <td colspan="3" style="padding-top: 15px">
                                <asp:GridView ID="grdCourses" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                    Width="100%" AutoGenerateColumns="False" GridLines="None" AllowSorting="True"
                                    DataKeyNames="advisingId" DataSourceID="AdvObjectDataSource" OnRowDataBound="grdCourses_RowDataBound">
                                    <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                    <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                    <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                    <EmptyDataTemplate>
                                        <div>
                                            لا يوجد طلاب مسجلين في هذه المادة
                                        </div>
                                    </EmptyDataTemplate>
                                    <PagerStyle CssClass="PagerStyle" />
                                    <Columns>
                                        <asp:BoundField DataField="RowId" HeaderText="#"></asp:BoundField>
                                        <asp:BoundField DataField="StudentCode" HeaderText="رقم الطالب" SortExpression="StudentCode"
                                            HeaderStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="FullName" HeaderText="اسم الطالب" SortExpression="FullName"
                                            HeaderStyle-HorizontalAlign="Right" ItemStyle-Font-Bold="true" HeaderStyle-Width="150px"
                                            ItemStyle-Width="150px" />
                                        <asp:TemplateField HeaderText="advisingId" Visible="false" ItemStyle-Width="70px">
                                            <ItemTemplate>
                                                <asp:Label ID="advisingIdLbl" runat="server" Width="60px" Visible="false" Text='<%# Eval("AdvisingId") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="أعمال السنة" ItemStyle-Width="60px">
                                            <ItemTemplate>
                                                <asp:TextBox ID="performanceTxt" runat="server" Width="60px" Text='<%# Convert.IsDBNull(Eval("PerformanceResult")) ? "" : Eval("PerformanceResult") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="العملي" ItemStyle-Width="80px">
                                            <ItemTemplate>
                                                <asp:TextBox ID="practicalTxt" runat="server" Width="70px" Text='<%# Convert.IsDBNull(Eval("LabResult")) ? "" : Eval("LabResult") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="التحريري" ItemStyle-Width="80px">
                                            <ItemTemplate>
                                                <asp:TextBox ID="finalTxt" runat="server" Width="70px" Text='<%# Convert.IsDBNull(Eval("WrittenResult")) ? "" : Eval("WrittenResult") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="المجموع" ItemStyle-Width="60px">
                                            <ItemTemplate>
                                                <asp:Label ID="totalLbl" runat="server" Text='<%# Eval("TotalResult") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="التقدير" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <span style="direction: rtl">
                                                    <asp:Label ID="gradeLbl" runat="server" Text='<%# Eval("Grade") %>'></asp:Label></span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="النقاط" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <asp:Label ID="pointsLbl" runat="server" Text='<%# Eval("TotalPoints") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="مرات الامتحان" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <asp:Label ID="ExamTimesLbl" runat="server" Text='<%# Eval("ExamTimesCount") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="الحالة" ItemStyle-Width="60px" Visible="false">
                                            <ItemTemplate>
                                                <asp:TextBox ID="Failed" runat="server" Width="60px" Text='<%# Eval("FailedBefore") %>'></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="حالة الطالب" ItemStyle-Width="40px">
                                            <ItemTemplate>
                                                <asp:DropDownList ID="attendDDL" runat="server" Width="80px" SelectedValue='<%# Eval("ExamAttendance") %>'>
                                                    <asp:ListItem Text="اختر" Value="0">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="حضر" Value="1" Selected="True">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="غياب" Value="2">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="عذر" Value="3">
                                                    </asp:ListItem>
                                                    <asp:ListItem Text="اخلال" Value="4">
                                                </asp:ListItem>
                                                      <asp:ListItem Text="ناجح" Value="5">
                                                </asp:ListItem>
                                                <asp:ListItem Text="راسب" Value="6">
                                                </asp:ListItem>
                                                </asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:ObjectDataSource ID="AdvObjectDataSource" runat="server" SelectMethod="GetByCourseSemester_Offering"
                                    TypeName="TeiLib.StudentsAdvisingDAL" 
                                    onselected="AdvObjectDataSource_Selected" >
                                    <SelectParameters>
                                        <asp:Parameter Name="courseId" Type="Int32" DefaultValue="1" />
                                        <asp:Parameter Name="semesterId" Type="Int32" DefaultValue="1" />
                                        <asp:Parameter Name="departmentId" Type="Int32" DefaultValue="1" />
                                        <%--<asp:Parameter Name="DoctorCoursesId" Type="Int32" DefaultValue="1" />--%>
                                        <asp:Parameter Name="FinalFrom" Type="Decimal" />
                                        <asp:Parameter Name="FinalTo" Type="Decimal" />
                                        <asp:Parameter Name="TotalFrom" Type="Decimal" />
                                        <asp:Parameter Name="TotalTo" Type="Decimal" />
                                        <asp:Parameter Name="GradeId" Type="Int32" />
                                        <asp:Parameter Name="ExamAttend" Type="Int32" />
                                        <asp:Parameter Name="ExamTimes" Type="Int32" />
                                        <asp:Parameter Name="sectionId" Type="Int32" />
                                        <asp:Parameter Name="recordsCount" Type="Int32" Direction="Output" />
                                        <asp:Parameter Name="absentCount" Type="Int32" Direction="Output" />
                                        <asp:Parameter Name="successCount" Type="Int32" Direction="Output" />
                                        <asp:Parameter Name="failCount" Type="Int32" Direction="Output" />
                                        <asp:Parameter Name="attendCount" Type="Int32" Direction="Output" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 15px" colspan="3">
                                <asp:Label ID="lblSuccess" runat="server" Font-Bold="True" Font-Size="Large" 
                                    Text="عدد الطلاب الناجحين"></asp:Label>
                                &nbsp;&nbsp;
                                <asp:Label ID="successLbl" runat="server"></asp:Label>
                                 <br />
                                <br />
                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="Large" 
                                    Text="نسبة الطلاب الناجحين"></asp:Label>
                                    &nbsp;&nbsp;
                                <asp:Label ID="successLblPrct" runat="server"></asp:Label>
                                <br />
                                <br />
                                <asp:Label ID="lblfailed" runat="server" Font-Bold="True" Font-Size="Large" 
                                    Text="عدد الطلاب الراسبين"></asp:Label>
                                    &nbsp;&nbsp;
                                <asp:Label ID="failedLbl" runat="server"></asp:Label>
                                <br />
                                <br />
                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Size="Large" 
                                    Text="نسبة الطلاب الراسبين"></asp:Label>
                                    &nbsp;&nbsp;
                                <asp:Label ID="failedLblPrct" runat="server"></asp:Label>
                                <br />
                                <br />
                                <asp:Label ID="lblattend" runat="server" Font-Bold="True" Font-Size="Large" 
                                    Text="عدد الطلاب الحاضرين"></asp:Label>
                                    &nbsp;&nbsp;
                                <asp:Label ID="attendLbl" runat="server"></asp:Label>
                                <br />
                                <br />
                                <asp:Label ID="Label3" runat="server" Font-Bold="True" Font-Size="Large" 
                                    Text="نسبة الطلاب الحاضرين"></asp:Label>
                                    &nbsp;&nbsp;
                                <asp:Label ID="attendLblPrct" runat="server"></asp:Label>
                                <br />
                                <br />
                                <asp:Label ID="lblabsent" runat="server" Font-Bold="True" Font-Size="Large" 
                                    Text="عدد الطلاب الغائبين"></asp:Label>
                                    &nbsp;&nbsp;
                                <asp:Label ID="absentLbl" runat="server"></asp:Label>
                                  <br />
                                <br />
                                <asp:Label ID="Label4" runat="server" Font-Bold="True" Font-Size="Large" 
                                    Text="نسبة الطلاب الغائبين"></asp:Label>
                                    &nbsp;&nbsp;
                                <asp:Label ID="absentLblPrct" runat="server"></asp:Label>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 7px">
                                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="حفـــظ" 
                                    ValidationGroup="grb" />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
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

    <script type="text/javascript" charset="utf-8">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequest);
        function EndRequest(sender, args) {
            $(document).ready(function() {
                //Add Inactive Class To All Accordion Headers
                $('.accordion-header').toggleClass('inactive-header');

                //Set The Accordion Content Width
                var contentwidth = $('.accordion-header').width();
                $('.accordion-content').css({ 'width': contentwidth });

                //Open The First Accordion Section When Page Loads
                //	$('.accordion-header').first().toggleClass('active-header').toggleClass('inactive-header');
                //	$('.accordion-content').first().slideDown().toggleClass('open-content');

                // The Accordion Effect
                $('.accordion-header').click(function() {
                    if ($(this).is('.inactive-header')) {
                        $('.active-header').toggleClass('active-header').toggleClass('inactive-header').next().slideToggle().toggleClass('open-content');
                        $(this).toggleClass('active-header').toggleClass('inactive-header');
                        $(this).next().slideToggle().toggleClass('open-content');
                    }

                    else {
                        $(this).toggleClass('active-header').toggleClass('inactive-header');
                        $(this).next().slideToggle().toggleClass('open-content');
                    }
                });

                return false;
            });
        }
        
    </script>

</asp:Content>
