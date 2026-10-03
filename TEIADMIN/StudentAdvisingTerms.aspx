<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="StudentAdvisingTerms.aspx.cs" Inherits="StudentAdvisingTerms" %>

<script runat="server">

    protected void btnAdd_Click(object sender, EventArgs e)
    {

    }
</script>


<asp:Content ID="head" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(document).bind("contextmenu", function (e) {
            e.preventDefault();
        });
        $(document).keydown(function (e) {
            if (e.which === 123) {
                return false;
            }
        });


    </script>
    <style type="text/css">
        .greenButton {
            background-color: #4CAF50; /* Green */
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
        }
    </style>
    <link href="js/sweetalert.css" rel="stylesheet" />
    <script src="js/sweetalert.min.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="PageTitle" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="BodyContent" runat="Server">
    <%--<asp:UpdatePanel ID="advisingPanel" runat="server" UpdateMode="Always">
        <contenttemplate>--%>

    <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" align="right">
        <tr>
            <td class="label" style="color: blue">كود الطالب
            </td>
            <td class="input">
                <asp:TextBox ID="txtStudentCode" runat="server"></asp:TextBox>
                <asp:HiddenField ID="HiddenField1" runat="server"></asp:HiddenField>
                <asp:HiddenField ID="HiddenField2" runat="server"></asp:HiddenField>
                <asp:HiddenField ID="HiddenField3" runat="server"></asp:HiddenField>
                <asp:HiddenField ID="hdnExpensesId" runat="server"></asp:HiddenField>
                <asp:HiddenField ID="hdnCompltedhours" runat="server"></asp:HiddenField>
                <asp:HiddenField ID="hdnResultSemesterId" runat="server"></asp:HiddenField>
                <asp:HiddenField ID="HiddenField4" runat="server"></asp:HiddenField>
            </td>
        </tr>
        <tr>
            <td class="button" colspan="2" align="center">
                <asp:Button ID="btnSearch" runat="server" Text="بحث" OnClick="btnSearch_Click" />

            </td>

        </tr>
    </table>
    <asp:MultiView ID="PageView" runat="server" ActiveViewIndex="0">
        <asp:View ID="FormView" runat="server">
            <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" align="right">
                <tr>
                    <td class="label" style="color: blue">كود الطالب
                    </td>
                    <td class="input">

                        <asp:Label ID="lblStudentCode" runat="server"></asp:Label>
                        <asp:HiddenField ID="hdnStudentCode" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="studentId" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="departmentIdHdn" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="hdnSemesterId" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="hdnSemesterName" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="hdnSavedSchedule" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="hdnLevelId" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="hdn_yearId" runat="server"></asp:HiddenField>
                    </td>
                </tr>
                <tr>
                    <td class="label" style="color: blue">الاسم
                    </td>
                    <td class="label">
                        <asp:Label ID="lblFullName" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="label" style="color: blue">القسم
                    </td>
                    <td class="input">
                        <asp:Label ID="lblDept" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="label" style="color: blue">الفرقة
                    </td>
                    <td class="input">
                        <asp:Label ID="lblLevel" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="label" style="color: blue">التقدير العام
                    </td>
                    <td class="input">
                        <asp:Label ID="lblGrade" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="label">الجدول 
                    </td>
                    <td class="input">
                        <asp:Label ID="lblSchedule" runat="server">
                        </asp:Label>

                    </td>

                </tr>

                <asp:PlaceHolder ID="levelHolder" runat="server">
                    <tr>
                        <td class="label">الجداول
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="ddlSchedules" runat="server" ValidationGroup="gr1"
                                OnSelectedIndexChanged="ddlSchedules_SelectedIndexChanged" AutoPostBack="true">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ForeColor="Red"
                                ErrorMessage="*" InitialValue="0" ControlToValidate="ddlSchedules" ValidationGroup="gr1"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </asp:PlaceHolder>
            </table>
            <div style="clear: both;">
            </div>
            <asp:PlaceHolder ID="selectLevelHolder" runat="server" Visible="false">
                <table cellpadding="2" cellspacing="2" border="0" width="300" class="form" align="right">
                    <tr>
                        <td class="label">اختر المستوى
                        </td>
                        <td class="input">
                            <asp:DropDownList ID="ddlLevel" runat="server" ValidationGroup="gr2">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ForeColor="Red"
                                ErrorMessage="*" InitialValue="0" ControlToValidate="ddlLevel" ValidationGroup="gr2"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="btnSelectLevel" runat="server" CssClass="greenButton"
                                Text='حفظ المستوى' OnClick="btnSelectLevel_Click" ValidationGroup="gr2"></asp:Button>
                        </td>
                    </tr>
                </table>
            </asp:PlaceHolder>
            <%--<h1>
                        درجات الطالب
                    </h1>--%>
            <asp:PlaceHolder ID="notPrepHolder" runat="server" Visible="false">
                <table cellpadding="0" cellspacing="0" border="0" width="500px">
                    <tr>
                        <td colspan="3" style="padding-top: 15px">
                            <br />
                            <div style="align: center">
                                <%--  <asp:LinkButton ID="btnGenerateReport2" runat="server" CssClass="linkbtn" Text="(موقف الطالب)أعرض التقرير"
                                        OnClick="btnGenerateReport2_Click" Visible="false" CausesValidation="false"></asp:LinkButton>--%>
                            </div>
                        </td>
                    </tr>


                </table>

                <div style="clear: both;">
                </div>
                <br />
                <br />
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td colspan="3" style="padding-top: 15px">
                            <asp:GridView ID="grdCourses" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                Width="100%" AutoGenerateColumns="False" GridLines="None">
                                <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                <PagerStyle CssClass="PagerStyle" />
                                <Columns>
                                    <asp:BoundField DataField="ArCourseName" HeaderText="اسم المادة" SortExpression="ArCourseName"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="SectionCode" HeaderText="السيكشن" SortExpression="SectionCode"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="MemberName" HeaderText="المحاضر" SortExpression="MemberName"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="TimeFrom" HeaderText="من"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="TimeTo" HeaderText="إلى"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="DayName" HeaderText="اليوم" SortExpression="DayName"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="ClassName" HeaderText="القاعة" SortExpression="ClassName"
                                        HeaderStyle-HorizontalAlign="Right" />

                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <asp:PlaceHolder ID="addScheduleHolder" runat="server">
                        <tr>
                            <td>
                                <asp:Button ID="btnAdd" runat="server" CssClass="greenButton"
                                    Text='حفظ الجدول' OnClick="btnAdd_Click1" ValidationGroup="gr1"></asp:Button>
                            </td>
                            <asp:PlaceHolder ID="changelevelHolder" runat="server" Visible="false">
                                <td>
                                    <asp:Button ID="btnChangeLevel" runat="server" CssClass="greenButton"
                                        Text='تغيير المستوى' OnClick="btnChangeLevel_Click" Visible="false"></asp:Button>
                                </td>
                            </asp:PlaceHolder>
                        </tr>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="removeSchedule" runat="server">
                        <tr>
                            <td>
                                <asp:Button ID="btnDelete" runat="server" CssClass="greenButton" Text=' حذف الجدول ' OnClick="btnDelete_Click"></asp:Button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="btnStudentPayment" runat="server" CssClass="greenButton" Text='طباعة اذن الدفع ' OnClick="btnStudentPayment_Click"></asp:Button>
                            </td>
                        </tr>
                    </asp:PlaceHolder>
                </table>
                <div style="clear: both;">
                </div>
                <br />
                <br />
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tr>
                        <td colspan="3" style="padding-top: 15px">
                            <asp:GridView ID="ResultGrid" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                Width="100%" AutoGenerateColumns="False" GridLines="None">
                                <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                <PagerStyle CssClass="PagerStyle" />
                                <Columns>
                                    <asp:BoundField DataField="ArCourseName" HeaderText="اسم المادة" SortExpression="ArCourseName"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="ArGradeName" HeaderText="التقدير" SortExpression="ArGradeName"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="ArStatusName" HeaderText="الحالة" SortExpression="ArStatusName"
                                        HeaderStyle-HorizontalAlign="Right" />


                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <table cellpadding="0" cellspacing="0" border="0" width="500px">
                    <tr>
                        <td colspan="3" style="padding-top: 15px">
                            <asp:GridView ID="RepeatGrid" runat="server" CellPadding="1" CellSpacing="1" CssClass="GridViewStyle"
                                Width="100%" AutoGenerateColumns="False" GridLines="None" AllowSorting="True">
                                <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                                <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                                <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                                <EmptyDataTemplate>
                                    <div>
                                        لا يوجد درجات لهذا الطالب
                                    </div>
                                </EmptyDataTemplate>
                                <PagerStyle CssClass="PagerStyle" />
                                <Columns>
                                    <asp:BoundField DataField="ArCourseName" HeaderText="اسم المادة" SortExpression="ArCourseName"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="ArGradeName" HeaderText="التقدير" SortExpression="ArGradeName"
                                        HeaderStyle-HorizontalAlign="Right" />
                                    <asp:BoundField DataField="ArStatusName" HeaderText="الحالة" SortExpression="ArStatusName"
                                        HeaderStyle-HorizontalAlign="Right" />
                                </Columns>
                            </asp:GridView>
                            <%--  <asp:ObjectDataSource ID="Adv1ObjectDataSource" runat="server" SelectMethod="GetByStudentId"
                                    TypeName="GeiLib.StudentsDAL" >
                                    <SelectParameters>
                                        <asp:ControlParameter Name="studentId" Type="Int32" DefaultValue="0" ControlID="studentId" />
                                       
                                    </SelectParameters>
                                </asp:ObjectDataSource>--%>
                            <br />

                        </td>
                    </tr>

                </table>
            </asp:PlaceHolder>

        </asp:View>
        <asp:View ID="NoAccessView" runat="server">

            <asp:Label ID="Label2" runat="server" Text=" عذرًا هذا الطالب محجوب! راجع"
                Visible="true"></asp:Label>
            <asp:Label ID="noRegisterlbl" runat="server" Visible="false"
                Text=" عذرا لا يمكنك التسجيل لهذا الطالب"></asp:Label>
            <asp:Label ID="finance" runat="server" Text=" الإدارة المالية"
                Visible="false"></asp:Label>
            <asp:Label ID="affairs" runat="server" Text=" شئون الطـلاب إدارة التسجيل الخاصة بالقسم"
                Visible="false"></asp:Label>
            <asp:Label ID="AdvisingDepart" runat="server" Text="  إدارة التسجيل الخاصة بالقسم"
                Visible="false"></asp:Label>
            <asp:Label ID="noAccessLbl" runat="server" Text=" غير مسموح لك دخول هذه الصفحة"
                Visible="false"></asp:Label>
            <asp:LinkButton ID="returnBTN" runat="server" CssClass="linkbtn" Text="عودة" OnClick="returnBTN_Click"
                Visible="false"></asp:LinkButton>

        </asp:View>
    </asp:MultiView>
    <%--      </contenttemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="LoadingProgress" runat="server">
        <progresstemplate>
            <div id="progressFilter">
            </div>
            <div id="progressMessage">
                Processing... &nbsp;
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
            </div>
        </progresstemplate>
    </asp:UpdateProgress>--%>
</asp:Content>
