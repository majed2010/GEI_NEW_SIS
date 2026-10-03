<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="GetAllStudentsExamTableByLevel_Report.aspx.cs" Inherits="GetAllStudentsExamTableByLevel_Report" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" runat="Server">
    تقرير طباعة جداول الامتحانات للطلاب لمستوى
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" runat="Server">
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
    <asp:View ID="PageView" runat="server">
    <asp:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>
            <style type="text/css">
                .button
                {
                    -moz-box-shadow: inset 0px 0px 0px 0px #bbdaf7;
                    -webkit-box-shadow: inset 0px 0px 0px 0px #bbdaf7;
                    box-shadow: inset 0px 0px 0px 0px #bbdaf7;
                    background: -webkit-gradient( linear, left top, left bottom, color-stop(0.05, #79bbff), color-stop(1, #378de5) );
                    background: -moz-linear-gradient( center top, #79bbff 5%, #378de5 100% );
                    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#79bbff', endColorstr='#378de5');
                    background-color: #79bbff;
                    -moz-border-radius: 20px;
                    -webkit-border-radius: 20px;
                    border-radius: 20px;
                    border: 6px solid #898c8f;
                    display: inline-block;
                    color: #ffffff;
                    font-family: Times New Roman;
                    font-size: 30px;
                    font-weight: bold;
                    text-decoration: none;
                    text-shadow: 1px 1px 0px #528ecc;
                }
                .button:hover
                {
                    background: -webkit-gradient( linear, left top, left bottom, color-stop(0.05, #378de5), color-stop(1, #79bbff) );
                    background: -moz-linear-gradient( center top, #378de5 5%, #79bbff 100% );
                    background-color: #378de5;
                }
                .button:active
                {
                    position: relative;
                    top: 1px;
                }
            </style>
            <div style="width: 100%; float: left; padding-bottom: 10px" id="Div4" runat="server"
                visible="true">
                <div style="width: 30%; float: right; height: 41px;">
                    <asp:Label ID="Label2" runat="server" Text="اختر مستوي : " Font-Bold="True"></asp:Label>
                </div>
                <div style="clear: both;">
                </div>
                <div style="width: 30%; float: right; text-align: right; height: 41px;">
                    <asp:DropDownList ID="drp_level" runat="server" Height="26px" Width="236px">
                    </asp:DropDownList>
                </div>
                <div style="clear: both;">
                </div>
            
                <div style="clear: both;">
                </div>
                <div style="width: 20%; float: right; text-align: right">
                    <asp:Button ID="Button1" runat="server" Text="اظهار التقرير " OnClick="Button1_Click"
                        CssClass="button" Font-Bold="True" Font-Size="Medium" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    </asp:View>
    <asp:View ID="NoAccessView" runat="server">
        <asp:Label ID="Label4" runat="server" Text="غير مصرح لك بدخول الصفحة " 
            Font-Size="Larger" ForeColor="Red"></asp:Label>
    </asp:View>
    </asp:MultiView>
    <asp:UpdateProgress ID="LoadingProgress" runat="server">
        <ProgressTemplate>
            <div id="progressFilter">
            </div>
            <div id="progressMessage">
                تحميل البيانات... &nbsp;
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
                <img src="images/18-0.gif" border="0" align="absmiddle" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
