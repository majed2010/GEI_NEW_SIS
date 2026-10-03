<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="admin_login"
    Culture="ar-EG" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>.:: TEI ::.</title>
    <%--<style type="text/css">
        ul
        {
            list-style: none;
            margin: 0;
            padding: 0;
            width: 200px;
        }
        ul li
        {
            font: bold 11px/16px arial, helvetica, sans-serif;
            height: 100%;
            background: #ff8b8e;
            border-bottom: 1px solid #fff;
            position: relative;
            float: left;
            width: 100%;
        }
        ul li ul li
        {
            background: #ffcf8b;
        }
        ul li a
        {
            display: block;
            padding: 2px 3px;
        }
        ul li a:hover
        {
            color: #a00;
            background: #ffd3d4;
            border-right: 1px solid #fff;
            border-left: 1px solid #fff;
        }
        ul li ul li a:hover
        {
            background: #ffedd3;
            border-left: 1px solid #fff;
        }
        ul ul
        {
            position: absolute;
            top: 0;
            display: none;
        }
        ul li:hover ul
        {
            display: block;
            left: 200px;
        }
    </style>--%>

    <script src="js/jquery.min.js" type="text/javascript"></script>

    <script src="js/jquery.cookie.js" type="text/javascript"></script>

    <link href="style/YahooGridView.css" rel="stylesheet" type="text/css" />
    <link href="style/style.css" rel="stylesheet" type="text/css" />
    <link href="style/tabs.css" rel="stylesheet" type="text/css" />
    <link href="style/calendar.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="header-wrapper">
        <div id="header">
            <div id="logo" align="center">
                <div>
                    <h1 dir="ltr" style="font-family:Times New Roman">
                        High Institute For Engineering & Technology
                    </h1>
                </div>
            </div>
        </div>
    </div>
    <div id="wrapper">
        <!-- end #header -->
        <div id="page">
            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#FFFFFF">
                <tr>
                    <td id="header1">
                    </td>
                    <td id="header2" align="center">
                        <br />
                        Please provide your login credentials
                        <br />
                        <br />
                    </td>
                    <td id="header3">
                    </td>
                </tr>
                <tr>
                    <td background="images/side1.gif">
                    </td>
                    <td id="title">
                    </td>
                    <td background="images/side2.gif">
                    </td>
                </tr>
                <tr>
                    <td background="images/side1.gif">
                    </td>
                    <td id="login">
                        <table cellpadding="2" cellspacing="1" border="0" width="250" class="form" align="center">
                            <tr>
                                <td class="formheader" colspan="3">
                                    Login
                                </td>
                            </tr>
                            <tr>
                                <td class="margin" rowspan="4">
                                </td>
                                <td style="padding-bottom: 12px">
                                    Username
                                </td>
                                <td class="input">
                                    <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-bottom: 12px">
                                    Password
                                </td>
                                <td class="input">
                                    <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" class="button" colspan="2">
                                    <asp:Button ID="btnSubmit" runat="server" Text="Login" CssClass="button" OnClick="Authenticate" />
                                </td>
                            </tr>
                        </table>
                        <br />
                        <div align="center">
                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal></div>
                        <br />
                        <br />
                        <br />
                    </td>
                    <td background="images/side2.gif">
                    </td>
                </tr>
                <tr>
                    <td id="footer1">
                    </td>
                    <td id="footer2">
                    </td>
                    <td id="footer3">
                    </td>
                </tr>
            </table>
        </div>
        <!-- end #page -->
    </div>
    <div id="footer">
        <p>
            Copyright (c) 2012 Sitename.com. All rights reserved. Design by <a href="http://www.freecsstemplates.org/">
                Free CSS Templates</a>.</p>
    </div>
    <!-- end #footer -->
    </form>
</body>
</html>
