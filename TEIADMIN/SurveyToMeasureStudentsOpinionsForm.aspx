<%@ Page Title="" Language="C#" MasterPageFile="~/layout.master" AutoEventWireup="true" CodeFile="SurveyToMeasureStudentsOpinionsForm.aspx.cs" Inherits="SurveyToMeasureStudentsOpinionsForm" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageTitle" runat="Server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="BodyContent" runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">

        <ContentTemplate>

            <table class="form" width="100%">

                <tr>
                    <td class="label">السنة الدراسية : 
                    </td>
                    <td>
                        <asp:Label ID="lblYear" runat="server" Text="" CssClass="lbl"></asp:Label>
                    </td>
                    <td style="width: 20px"></td>
                    <td class="label">الفصل الدراسى : 
                    </td>
                    <td>
                        <asp:Label ID="lblClass" runat="server" Text="" CssClass="lbl"></asp:Label>
                    </td>
                </tr>

                <tr>
                    <td class="label">الشعبة : 
                    </td>
                    <td>
                        <asp:Label ID="lblBranch" runat="server" Text="" CssClass="lbl"></asp:Label>
                    </td>
                    <td style="width: 20px"></td>
                    <td class="label">المستوى : 
                    </td>
                    <td>
                        <asp:Label ID="lblLevel" runat="server" Text="" CssClass="lbl"></asp:Label>
                    </td>
                </tr>

                <tr>
                    <td>
                        <br />
                    </td>
                </tr>

                <tr>
                    <td colspan="8" class="label">إرشادات تعبئة الاستبيان :                     
                    </td>
                </tr>

                <tr>
                    <td colspan="8" class="label">1-يهدف هذا الإستبيان إلى تقييم تدريس المقرارات بهدف تحسين وتطوير العملية التعليمية من خلال إجابتك حتى يمكن الاستفادة من أراءك فى الارتقاء بالعملية التعليمية .                     
                    </td>
                </tr>

                <tr>
                    <td colspan="8" class="label">2- تأكد من أن إجابتك على هذه الاستمارة ستعامل بسرية تامة ولن تؤثر على تقديرك فى هذا المقرر .
                    </td>
                </tr>

                <tr>
                    <td colspan="8" class="label">3- من فضلك كن حياديا وموضوعيا عند الإجابة .
                    </td>
                </tr>

                <tr>
                    <td colspan="8" class="label">4- اختر امام كل بند من البنود التالية كلمة تعبر عن تقييمك ممتاز - جيد جدا - جيد - مقبول - ضعيف . 
                    </td>
                </tr>

                <tr>
                    <td>
                        <br />
                    </td>
                </tr>

                <tr>
                    <td colspan="5">
                        <asp:GridView ID="GridView_AdministrationCredibility" runat="server"
                            AutoGenerateColumns="False" Width="630px" DataSourceID="ObjectDataSource1">
                            <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                            <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                            <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                            <PagerStyle CssClass="PagerStyle" />
                            <Columns>

                                <asp:TemplateField HeaderText="مسلسل">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="QuesItemId" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemId" runat="server" Text='<%# Eval("SurveyItemId") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="مصداقية الإدارة">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemText" runat="server" Text='<%# Eval("SurveyItemText") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="التقييم">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlItems" runat="server" required="">
                                            <asp:ListItem></asp:ListItem>
                                            <asp:ListItem Value="1" Text="ممتاز"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="جيد جدا"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="جيد"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="مقبول"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="ضعيف"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSurveyItemsByType" TypeName="SurveyLib.SurveyItemsDAL">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="4" Name="SurveyItemType" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>

                <tr>
                    <td colspan="5">
                        <asp:GridView ID="GridView_AdmissionPolicies" runat="server"
                            AutoGenerateColumns="False" Width="630px" DataSourceID="ObjectDataSource2">
                            <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                            <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                            <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                            <PagerStyle CssClass="PagerStyle" />
                            <Columns>

                                <asp:TemplateField HeaderText="مسلسل">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="QuesItemId" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemId" runat="server" Text='<%# Eval("SurveyItemId") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="سياسات القبول">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemText" runat="server" Text='<%# Eval("SurveyItemText") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="التقييم">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlItems" runat="server" required="">
                                            <asp:ListItem></asp:ListItem>
                                            <asp:ListItem Value="1" Text="ممتاز"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="جيد جدا"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="جيد"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="مقبول"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="ضعيف"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSurveyItemsByType" TypeName="SurveyLib.SurveyItemsDAL">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="5" Name="SurveyItemType" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>

                <tr>
                    <td colspan="5">
                        <asp:GridView ID="GridView_EducationAndEvaluationMethods" runat="server"
                            AutoGenerateColumns="False" Width="628px" DataSourceID="ObjectDataSource3">
                            <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                            <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                            <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                            <PagerStyle CssClass="PagerStyle" />
                            <Columns>

                                <asp:TemplateField HeaderText="مسلسل">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="QuesItemId" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemId" runat="server" Text='<%# Eval("SurveyItemId") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="أساليب التعلم والتقويم">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemText" runat="server" Text='<%# Eval("SurveyItemText") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="التقييم">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlItems" runat="server" required="">
                                            <asp:ListItem></asp:ListItem>
                                            <asp:ListItem Value="1" Text="ممتاز"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="جيد جدا"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="جيد"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="مقبول"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="ضعيف"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="ObjectDataSource3" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSurveyItemsByType" TypeName="SurveyLib.SurveyItemsDAL">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="6" Name="SurveyItemType" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>

                <tr>
                    <td colspan="5">
                        <asp:GridView ID="GridView_PossibilitiesLaboratory" runat="server"
                            AutoGenerateColumns="False" Width="628px" DataSourceID="ObjectDataSource4">
                            <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                            <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                            <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                            <PagerStyle CssClass="PagerStyle" />
                            <Columns>

                                <asp:TemplateField HeaderText="مسلسل">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="QuesItemId" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemId" runat="server" Text='<%# Eval("SurveyItemId") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="الامكانيات المعملية">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemText" runat="server" Text='<%# Eval("SurveyItemText") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="التقييم">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlItems" runat="server" required="">
                                            <asp:ListItem></asp:ListItem>
                                            <asp:ListItem Value="1" Text="ممتاز"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="جيد جدا"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="جيد"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="مقبول"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="ضعيف"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="ObjectDataSource4" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSurveyItemsByType" TypeName="SurveyLib.SurveyItemsDAL">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="7" Name="SurveyItemType" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>

                <tr>
                    <td colspan="5">
                        <asp:GridView ID="GridView_TeachingAidsSupporting" runat="server"
                            AutoGenerateColumns="False" Width="628px" DataSourceID="ObjectDataSource5">
                            <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                            <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                            <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                            <PagerStyle CssClass="PagerStyle" />
                            <Columns>

                                <asp:TemplateField HeaderText="مسلسل">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="QuesItemId" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemId" runat="server" Text='<%# Eval("QuesItemId") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="الوسائل التعليمية الداعمة">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemText" runat="server" Text='<%# Eval("ItemText") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="التقييم">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlItems" runat="server" required="">
                                            <asp:ListItem></asp:ListItem>
                                            <asp:ListItem Value="1" Text="ممتاز"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="جيد جدا"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="جيد"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="مقبول"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="ضعيف"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="ObjectDataSource5" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSurveyItemsByType" TypeName="SurveyLib.SurveyItemsDAL">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="8" Name="SurveyItemType" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>

                <tr>
                    <td colspan="5">
                        <asp:GridView ID="GridView_Library" runat="server"
                            AutoGenerateColumns="False" Width="630px" DataSourceID="ObjectDataSource6">
                            <HeaderStyle CssClass="HeaderStyle" HorizontalAlign="Right" />
                            <RowStyle CssClass="RowStyle" HorizontalAlign="Right" />
                            <AlternatingRowStyle CssClass="AltRowStyle" HorizontalAlign="Right" />
                            <PagerStyle CssClass="PagerStyle" />
                            <Columns>

                                <asp:TemplateField HeaderText="مسلسل">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="QuesItemId" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemId" runat="server" Text='<%# Eval("QuesItemId") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="المكتبة">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemText" runat="server" Text='<%# Eval("ItemText") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="التقييم">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlItems" runat="server" required="">
                                            <asp:ListItem></asp:ListItem>
                                            <asp:ListItem Value="1" Text="ممتاز"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="جيد جدا"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="جيد"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="مقبول"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="ضعيف"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="ObjectDataSource6" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSurveyItemsByType" TypeName="SurveyLib.SurveyItemsDAL">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="9" Name="SurveyItemType" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>

                <%--<tr>
                    <td colspan="5" class="label">اراء أو مقترحات أو ملاحظات تود إضافتها ولم تدرج فى هذا الاستبيان
                    </td>
                </tr>

                <tr>
                    <td colspan="5">
                        <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Height="111px" Width="450px"></asp:TextBox>
                    </td>
                </tr>--%>

                <tr>
                    <td colspan="8" align="center" class="button">
                        <asp:Button ID="btnSubmit" runat="server" Text="حفظ" Width="100px" OnClick="btnSubmit_Click" />
                    </td>
                </tr>

            </table>

        </ContentTemplate>

    </asp:UpdatePanel>

</asp:Content>

