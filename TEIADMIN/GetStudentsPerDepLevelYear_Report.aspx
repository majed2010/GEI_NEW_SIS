<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true"
    CodeFile="GetStudentsPerDepLevelYear_Report.aspx.cs" Inherits="GetStudentsPerDepLevelYear_Report" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" runat="Server">
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

    <script language="javascript" type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode;
            if (charCode != 46 && charCode > 31
            && (charCode < 48 || charCode > 57))
                return false;

            return true;
        }
       
    </script>

    <div>
        <div style="width: 100%; float: left; padding-bottom: 10px" id="parametres" runat="server"
            visible="true">
            <div style="width: 10%; float: right; height: 17px;">
                <asp:Label ID="Label1" runat="server" Text=": اختر القسم " Font-Bold="True"></asp:Label>
            </div>
            <div style="width: 20%; float: right; text-align: right">
                <asp:DropDownList ID="drp_departments" runat="server">
                </asp:DropDownList>
            </div>
        </div>
        <div style="width: 100%; float: left; padding-bottom: 10px" id="Div2" runat="server"
            visible="true">
            <div style="width: 10%; float: right; height: 17px;">
                <asp:Label ID="Label4" runat="server" Text="اختر مستوي :" Font-Bold="True"></asp:Label>
            </div>
            <div style="width: 20%; float: right; text-align: right">
                <asp:DropDownList ID="ddl_levels" runat="server">
                </asp:DropDownList>
            </div>
        </div>
        
        <div style="width: 100%; float: left; padding-bottom: 10px" id="DivYears" runat="server"
            visible="true">
            <div style="width: 10%; float: right; height: 17px;">
                <asp:Label ID="Label2" runat="server" Text="السنة الدراسية :" Font-Bold="True"></asp:Label>
            </div>
            <div style="width: 20%; float: right; text-align: right">
                <asp:DropDownList ID="ddlYears" runat="server" DataSourceID="DSYears" DataTextField="YearName" DataValueField="YearId" AppendDataBoundItems="true">
                <asp:ListItem Selected="True" Text="---اختر---" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:ObjectDataSource ID="DSYears" runat="server" 
                    OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" 
                    TypeName="TeiLib.YearsDAL"></asp:ObjectDataSource>
            </div>
        </div>
        <div style="width: 100%; float: left; padding-bottom: 10px" id="Div3" runat="server"
            visible="true">
            <div style="width: 10%; float: right; height: 17px;">
                <asp:Label ID="Label3" runat="server" Text="الفصل الدراسي الحالي :" Font-Bold="True"></asp:Label>
            </div>
            <div style="width: 20%; float: right; text-align: right">
                <asp:DropDownList ID="ddlSemesters" runat="server" DataSourceID="DSsemesters" DataTextField="ArSemesterName" DataValueField="SemesterId" Enabled="false" AppendDataBoundItems="true">
                <asp:ListItem Selected="True" Text="---اختر---" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:ObjectDataSource ID="DSsemesters" runat="server" 
                    OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" 
                    TypeName="TeiLib.SemestersDAL"></asp:ObjectDataSource>
            </div>
        </div>


        <div style="width: 100%; float: left; padding-bottom: 10px" id="Div1" runat="server"
            visible="true">
            <div style="width: 10%; float: right; height: 17px;">
                <asp:Label ID="Label6" runat="server" Text=" السنة : " Font-Bold="True"></asp:Label>
            </div>
            <div style="width: 20%; float: right; text-align: right">
                <asp:TextBox ID="txt_year" runat="server" onkeypress="return isNumberKey(event)"
                    MaxLength="4"></asp:TextBox>
            </div>
        </div>
        <div>
            <asp:Button ID="Button1" runat="server" Text="اظهار التقرير " OnClick="Button1_Click"
                CssClass="button" Font-Bold="True" Font-Size="Medium" />
        </div>
        <div>
            <asp:Label ID="lbl_result" runat="server" Visible="false"></asp:Label>
        </div>
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Names="Verdana" Font-Size="8pt"
            Height="400px" Width="600px" Visible="False">
            <LocalReport ReportPath="Reports\GetStudentsPerDepLevelYear_Report.rdlc">
                <DataSources>
                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet2_DataTable13" />
                </DataSources>
            </LocalReport>
        </rsweb:ReportViewer>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetData"
            TypeName="DataSet2TableAdapters.DataTable1TableAdapter"></asp:ObjectDataSource>
    </div>
    
</asp:Content>
