using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text.RegularExpressions;
using System.IO;
using System.Globalization;
using System.Collections;
using TeiLib;

public partial class Insert_students : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ArrayList sections = CurrentUser.GetUserRoleAndSections();
        if (!sections[0].Equals("1") && !sections.Contains("Students_insert"))
            PageView.ActiveViewIndex = 2;

        this.Form.Attributes.Add("enctype", "multipart/form-data");
    }

    protected void StudentsForm_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        //object val = e.Values["Date"];
        //e.Values["Date"] = Convert.ToDateTime(val);
        IFormatProvider culture = new CultureInfo("en-GB", true);

        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;

        TextBox arStudentFirstName1 = Tabs.Controls[0].FindControl("arStudentFirstName1") as TextBox;
        TextBox arStudentSecondName1 = Tabs.Controls[0].FindControl("arStudentSecondName1") as TextBox;

        TextBox arStudentLastName1 = Tabs.Controls[0].FindControl("arStudentLastName1") as TextBox;
        TextBox studentsFirstName1 = Tabs.Controls[0].FindControl("studentFirstName1") as TextBox;
        TextBox studentMiddleName1 = Tabs.Controls[0].FindControl("studentMiddleName1") as TextBox;
        TextBox studentLastName1 = Tabs.Controls[0].FindControl("studentLastName1") as TextBox;
        RadioButtonList gender1 = Tabs.Controls[0].FindControl("gender1") as RadioButtonList;
        RadioButtonList religion1 = Tabs.Controls[0].FindControl("religion1") as RadioButtonList;

        TextBox birthdate1 = Tabs.Controls[0].FindControl("birthdate1") as TextBox;
        DropDownList birthPlace1 = Tabs.Controls[0].FindControl("birthPlace1") as DropDownList;
        TextBox nationalId1 = Tabs.Controls[0].FindControl("nationalId1") as TextBox;
        TextBox ReleaseDate1 = Tabs.Controls[0].FindControl("ReleaseDate1") as TextBox;
        DropDownList NationalZone1 = Tabs.Controls[0].FindControl("NationalZone1") as DropDownList;

        TextBox passportNo1 = Tabs.Controls[0].FindControl("passportNo1") as TextBox;
        TextBox PaassportRelDate1 = Tabs.Controls[0].FindControl("PaassportRelDate1") as TextBox;
        TextBox PassExpirDate1 = Tabs.Controls[0].FindControl("PassExpirDate1") as TextBox;
        TextBox studentImage1 = StudentsForm.Controls[0].FindControl("studentImage1") as TextBox;
        //DropDownList years1 = Tabs.Controls[0].FindControl("years1") as DropDownList;
        DropDownList nationality1 = Tabs.Controls[0].FindControl("nationality1") as DropDownList;
        //DropDownList departments1 = Tabs.Controls[0].FindControl("departments1") as DropDownList;

        DropDownList certificate1 = Tabs.Controls[1].FindControl("certificate1") as DropDownList;
        DropDownList certitificateLocation1 = Tabs.Controls[1].FindControl("certitificateLocation1") as DropDownList;
        DropDownList certificateYear1 = Tabs.Controls[1].FindControl("certificateYear1") as DropDownList;
        TextBox certificateٍٍٍSeatNo1 = Tabs.Controls[1].FindControl("certificateٍٍٍSeatNo1") as TextBox;
        TextBox certificateTotalResult1 = Tabs.Controls[1].FindControl("certificateTotalResult1") as TextBox;
        TextBox certificateResultPercentage1 = Tabs.Controls[1].FindControl("certificateResultPercentage1") as TextBox;

        TextBox SchoolName1 = Tabs.Controls[1].FindControl("SchoolName1") as TextBox;
        TextBox educationalPlace1 = Tabs.Controls[1].FindControl("educationalPlace1") as TextBox;

        DropDownList firstLanguage1 = Tabs.Controls[1].FindControl("firstLanguage1") as DropDownList;
        DropDownList secondLanguage1 = Tabs.Controls[1].FindControl("secondLanguage1") as DropDownList;

        TextBox arAddress1 = Tabs.Controls[2].FindControl("arAddress1") as TextBox;
        TextBox address1 = Tabs.Controls[2].FindControl("address1") as TextBox;
        DropDownList addressLocation1 = Tabs.Controls[2].FindControl("addressLocation1") as DropDownList;
        TextBox studentPhone1 = Tabs.Controls[2].FindControl("studentPhone1") as TextBox;
        TextBox studentMobile1 = Tabs.Controls[2].FindControl("studentMobile1") as TextBox;
        TextBox studentEmail1 = Tabs.Controls[2].FindControl("studentEmail1") as TextBox;
        TextBox studentFacebook1 = Tabs.Controls[2].FindControl("studentFacebook1") as TextBox;
        TextBox studentTwitter1 = Tabs.Controls[2].FindControl("studentTwitter1") as TextBox;
        TextBox txtMobile21 = Tabs.Controls[2].FindControl("txtMobile21") as TextBox;

        TextBox arFatherName1 = Tabs.Controls[3].FindControl("arFatherName1") as TextBox;
        TextBox fatherName1 = Tabs.Controls[3].FindControl("fatherName1") as TextBox;
        TextBox fatherJob1 = Tabs.Controls[3].FindControl("fatherJob1") as TextBox;
        TextBox arFatherJob1 = Tabs.Controls[3].FindControl("arFatherJob1") as TextBox;
        TextBox fahterMobile1 = Tabs.Controls[3].FindControl("fahterMobile1") as TextBox;
        TextBox fatherEmail1 = Tabs.Controls[3].FindControl("fatherEmail1") as TextBox;
        TextBox arMotherName1 = Tabs.Controls[3].FindControl("arMotherName1") as TextBox;
        TextBox motherName1 = Tabs.Controls[3].FindControl("motherName1") as TextBox;
        TextBox arMotherJob1 = Tabs.Controls[3].FindControl("arMotherJob1") as TextBox;
        TextBox motherJob1 = Tabs.Controls[3].FindControl("motherJob1") as TextBox;
        TextBox motherMobile1 = Tabs.Controls[3].FindControl("motherMobile1") as TextBox;

        DropDownList activity1 = Tabs.Controls[4].FindControl("activity1") as DropDownList;
        TextBox activityPlace1 = Tabs.Controls[4].FindControl("activityPlace1") as TextBox;
        TextBox activityChamp1 = Tabs.Controls[4].FindControl("activityChamp1") as TextBox;
        TextBox activityChampDate1 = Tabs.Controls[4].FindControl("activityChampDate1") as TextBox;
        DropDownList hoppy1 = Tabs.Controls[4].FindControl("hoppy1") as DropDownList;
        TextBox hoppyPlace1 = Tabs.Controls[4].FindControl("hoppyPlace1") as TextBox;
        DropDownList InstituteStatment1 = Tabs.Controls[4].FindControl("InstituteStatment1") as DropDownList;
        /*
        DropDownList armyStatus1 = Tabs.Controls[5].FindControl("armyStatus1") as DropDownList;
        TextBox thiroidNo1 = Tabs.Controls[5].FindControl("thiroidNo1") as TextBox;
        TextBox exemptedDate1 = Tabs.Controls[5].FindControl("exemptedDate1") as TextBox;
        TextBox exemptedNo1 = Tabs.Controls[5].FindControl("exemptedNo1") as TextBox;
        TextBox operativeDecision1 = Tabs.Controls[5].FindControl("operativeDecision1") as TextBox;

        DropDownList ddlAcceptance1 = Tabs.Controls[6].FindControl("ddlAcceptance1") as DropDownList;
        TextBox txtAcceptanceDate1 = Tabs.Controls[6].FindControl("txtAcceptanceDate1") as TextBox;
        TextBox txtAcceptanceNumber1 = Tabs.Controls[6].FindControl("txtAcceptanceNumber1") as TextBox;
        TextBox txtTransferDate1 = Tabs.Controls[6].FindControl("txtTransferDate1") as TextBox;
        TextBox txtTransferFrom1 = Tabs.Controls[6].FindControl("txtTransferFrom1") as TextBox;
        */
        e.Values["FirstName"] = studentFirstName1.Text; ;
        e.Values["MiddleName"] = studentMiddleName1.Text; ;
        e.Values["LastName"] = studentLastName1.Text;
        e.Values["ArFirstName"] = arStudentFirstName1.Text;
        e.Values["ArMiddleName"] = arStudentSecondName1.Text;
        e.Values["ArLastName"] = arStudentLastName1.Text;

        e.Values["Gender"] = Convert.ToBoolean(gender1.SelectedItem.Value);
        e.Values["Religion"] = Convert.ToInt32(religion1.SelectedItem.Value);
        e.Values["DateOfBirth"] = Convert.ToDateTime(birthdate1.Text, culture);
        e.Values["PlaceOfBirth"] = Convert.ToInt32(birthPlace1.SelectedValue);
        e.Values["NationalId"] = nationalId1.Text;
        e.Values["NationalIdReleaseDate"] =  Convert.ToDateTime(ReleaseDate1.Text, culture);
        e.Values["NationalIdReleaseZone"] = Convert.ToInt32(NationalZone1.SelectedValue);
        e.Values["Nationality"] = Convert.ToInt32(nationality1.SelectedValue);
        e.Values["PassportId"] = passportNo1.Text;
        e.Values["PassportReleaseDate"] = PaassportRelDate1.Text == "" ? PaassportRelDate1.Text : Convert.ToDateTime(PaassportRelDate1.Text, culture).ToShortDateString();
        e.Values["PassportExpirationDate"] = PassExpirDate1.Text == "" ? PassExpirDate1.Text : Convert.ToDateTime(PassExpirDate1.Text, culture).ToShortDateString();
        e.Values["FatherName"] = fatherName1.Text;
        e.Values["ArFatherName"] = arFatherName1.Text;
        e.Values["FatherJob"] = fatherJob1.Text;
        e.Values["ArFatherJob"] = arFatherJob1.Text;
        e.Values["MotherName"] = motherName1.Text;
        e.Values["ArMotherName"] = arMotherName1.Text;
        e.Values["MotherJob"] = motherJob1.Text;
        e.Values["ArMotherJob"] = arMotherJob1.Text;
        e.Values["FirstForeignLanguage"] = Convert.ToInt32(firstLanguage1.SelectedValue);
        e.Values["SecondForeignLanguage"] = Convert.ToInt32(secondLanguage1.SelectedValue);
        e.Values["Image"] = "";
        //e.Values["DepartmentId"] = Convert.ToInt32(departments1.SelectedValue);
        //e.Values["YearId"] = Convert.ToInt32(years1.SelectedValue);

        e.Values["ActivityId"] = Convert.ToInt32(activity1.SelectedValue);
        e.Values["ActivityPlace"] = activityPlace1.Text;
        e.Values["ActivityChampionship"] = activityChamp1.Text;
        e.Values["ActivityChampionshipDate"] = activityChampDate1.Text == "" ? activityChampDate1.Text : Convert.ToDateTime(activityChampDate1.Text, culture).ToShortDateString();

        e.Values["CertificateId"] = Convert.ToInt32(certificate1.SelectedValue);
        e.Values["CertificateCountry"] = Convert.ToInt32(certitificateLocation1.SelectedValue);
        e.Values["CertificateYear"] = certificateYear1.SelectedValue;
        e.Values["CertificateSeatNo"] = certificateٍٍٍSeatNo1.Text;
        e.Values["CertificateTotalResult"] = Convert.ToDecimal(certificateTotalResult1.Text);
        e.Values["CertificateResultPercentage"] = Convert.ToDecimal(certificateResultPercentage1.Text);
        e.Values["SchoolId"] = SchoolName1.Text;
        e.Values["educationalPlace"] = educationalPlace1.Text;
       
            

        e.Values["StudentPhone"] = studentPhone1.Text;
        e.Values["StudentMobile"] = studentMobile1.Text;
        e.Values["StudentEmail"] = studentEmail1.Text;
        e.Values["StudentFacebook"] = studentFacebook1.Text;
        e.Values["StudentTwitter"] = studentTwitter1.Text;
        e.Values["FatherMobile"] = fahterMobile1.Text;
        e.Values["FatherEmail"] = fatherEmail1.Text;
        e.Values["MotherMobile"] = motherMobile1.Text;
        e.Values["StudentAddress"] = address1.Text;
        e.Values["ArStudentAddress"] = arAddress1.Text;
        e.Values["StudentAddressLocation"] = Convert.ToInt32(addressLocation1.SelectedValue);
        e.Values["StudentMobile2"] = txtMobile21.Text;

        e.Values["HoppyId"] = Convert.ToInt32(hoppy1.SelectedValue);


        e.Values["HoppyPlace"] = hoppyPlace1.Text;
        e.Values["InstituteStatmentId"] = Convert.ToInt32(InstituteStatment1.SelectedValue);
        /*
        e.Values["ArmyId"] = armyStatus1.SelectedValue;
        e.Values["ExemptedNumber"] = exemptedNo1.Text;
        e.Values["ThirdNumber"] = thiroidNo1.Text;
        e.Values["ExemptedDate"] = exemptedDate1.Text == "" ? exemptedDate1.Text : Convert.ToDateTime(exemptedDate1.Text, culture).ToShortDateString();
        e.Values["OperativeDecision"] = operativeDecision1.Text;

        e.Values["AcceptanceId"] = Convert.ToInt32(ddlAcceptance1.SelectedValue);
        e.Values["AcceptanceDate"] = txtAcceptanceDate1.Text;
        e.Values["AcceptanceNumber"] = Convert.ToInt32(txtAcceptanceNumber1.Text == "" ? "0" : txtAcceptanceNumber1.Text);
        e.Values["TransferDate"] = txtTransferDate1.Text == "" ? txtTransferDate1.Text : Convert.ToDateTime(txtTransferDate1.Text, culture).ToShortDateString();
        e.Values["TransferFrom"] = txtTransferFrom1.Text;
         * */
        e.Values["Image"] = "";
        
        string folder = Server.MapPath("~/Students/Images/");//"C:/Inetpub/vhosts/hanbly.net/httpdocs/TeiAdmin/Students/Images/";
        string fileName = string.Empty;
        string Thumbnail = string.Empty;

        FileUpload PhotoUpld = Tabs.Controls[0].FindControl("studentImage1") as FileUpload;
        if (PhotoUpld.HasFile)
        {
            if (Regex.IsMatch(PhotoUpld.PostedFile.ContentType, "image/\\S+") && PhotoUpld.PostedFile.ContentType != "image/tiff")
            {
                fileName = Path.GetFileName(PhotoUpld.PostedFile.FileName);
                fileName = Common.SetUniqueFilename(folder, fileName.Replace(" ", ""));
                PhotoUpld.SaveAs(folder + fileName);

                Common.ResizeImage(folder, fileName, 150, 230, true, false);

                e.Values["Image"] = fileName;

                PhotoUpld.Dispose();
            }
            else
            {
                imgErr.Visible = true;
                e.Cancel = true;
            }
        }
    }
    protected void StudentsForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            if (e.Exception.InnerException != null)
            {
                if (e.Exception.InnerException.Message != "")
                {
                    submitErr.Text = e.Exception.InnerException.Message;

                    string folder = Server.MapPath("~/Students/Images/");
                    if (Convert.ToString(e.Values["Image"]) != string.Empty)
                        Common.DeleteFileFromDisk(folder + e.Values["Image"]);

                }
            }

            e.ExceptionHandled = true;
            e.KeepInInsertMode = true;
            submitErr.Visible = true;
        }
        else
        {
            
            PageView.ActiveViewIndex = 1;
            grdStudents.DataBind();
        }

    }
    protected void StudentsForm_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        //object val = e.NewValues["Date"];
        //e.NewValues["Date"] = Convert.ToDateTime(val);
        IFormatProvider culture = new CultureInfo("en-GB", true);
        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;

        TextBox arStudentFirstName = Tabs.Controls[0].FindControl("arStudentFirstName") as TextBox;
        TextBox arStudentSecondName = Tabs.Controls[0].FindControl("arStudentSecondName") as TextBox;

        TextBox arStudentLastName = Tabs.Controls[0].FindControl("arStudentLastName") as TextBox;
        TextBox studentsFirstName = Tabs.Controls[0].FindControl("studentFirstName") as TextBox;
        TextBox studentMiddleName = Tabs.Controls[0].FindControl("studentMiddleName") as TextBox;
        TextBox studentLastName = Tabs.Controls[0].FindControl("studentLastName") as TextBox;
        RadioButtonList gender = Tabs.Controls[0].FindControl("gender") as RadioButtonList;
        RadioButtonList religion = Tabs.Controls[0].FindControl("religion") as RadioButtonList;
        TextBox birthdate = Tabs.Controls[0].FindControl("birthdate") as TextBox;
        DropDownList birthPlace = Tabs.Controls[0].FindControl("birthPlace") as DropDownList;
        TextBox nationalId = Tabs.Controls[0].FindControl("nationalId") as TextBox;
        TextBox ReleaseDate = Tabs.Controls[0].FindControl("ReleaseDate") as TextBox;
        DropDownList NationalZone = Tabs.Controls[0].FindControl("NationalZone") as DropDownList;
        TextBox passportNo = Tabs.Controls[0].FindControl("passportNo") as TextBox;
        TextBox PaassportRelDate = Tabs.Controls[0].FindControl("PaassportRelDate") as TextBox;
        TextBox PassExpirDate = Tabs.Controls[0].FindControl("PassExpirDate") as TextBox;
        TextBox studentImage = StudentsForm.Controls[0].FindControl("studentImage") as TextBox;
        DropDownList years = Tabs.Controls[0].FindControl("years") as DropDownList;
        DropDownList nationality = Tabs.Controls[0].FindControl("nationality") as DropDownList;
        DropDownList departments = Tabs.Controls[0].FindControl("departments") as DropDownList;

        DropDownList certificate = Tabs.Controls[1].FindControl("certificate") as DropDownList;
        DropDownList certitificateLocation = Tabs.Controls[1].FindControl("certitificateLocation") as DropDownList;
        DropDownList certificateYear = Tabs.Controls[1].FindControl("certificateYear") as DropDownList;
        TextBox certificateٍٍٍSeatNo = Tabs.Controls[1].FindControl("certificateٍٍٍSeatNo") as TextBox;
        TextBox certificateTotalResult = Tabs.Controls[1].FindControl("certificateTotalResult") as TextBox;
        TextBox certificateResultPercentage = Tabs.Controls[1].FindControl("certificateResultPercentage") as TextBox;
        DropDownList firstLanguage = Tabs.Controls[1].FindControl("firstLanguage") as DropDownList;
        DropDownList secondLanguage = Tabs.Controls[1].FindControl("secondLanguage") as DropDownList;

        TextBox arAddress = Tabs.Controls[2].FindControl("arAddress") as TextBox;
        TextBox address = Tabs.Controls[2].FindControl("address") as TextBox;
        DropDownList addressLocation = Tabs.Controls[2].FindControl("addressLocation") as DropDownList;
        TextBox studentPhone = Tabs.Controls[2].FindControl("studentPhone") as TextBox;
        TextBox studentMobile = Tabs.Controls[2].FindControl("studentMobile") as TextBox;
        TextBox studentEmail = Tabs.Controls[2].FindControl("studentEmail") as TextBox;
        TextBox studentFacebook = Tabs.Controls[2].FindControl("studentFacebook") as TextBox;
        TextBox studentTwitter = Tabs.Controls[2].FindControl("studentTwitter") as TextBox;

        TextBox arFatherName = Tabs.Controls[3].FindControl("arFatherName") as TextBox;
        TextBox fatherName = Tabs.Controls[3].FindControl("fatherName") as TextBox;
        TextBox fatherJob = Tabs.Controls[3].FindControl("fatherJob") as TextBox;
        TextBox arFatherJob = Tabs.Controls[3].FindControl("arFatherJob") as TextBox;
        TextBox fahterMobile = Tabs.Controls[3].FindControl("fahterMobile") as TextBox;
        TextBox fatherEmail = Tabs.Controls[3].FindControl("fatherEmail") as TextBox;
        TextBox arMotherName = Tabs.Controls[3].FindControl("arMotherName") as TextBox;
        TextBox motherName = Tabs.Controls[3].FindControl("motherName") as TextBox;
        TextBox arMotherJob = Tabs.Controls[3].FindControl("arMotherJob") as TextBox;
        TextBox motherJob = Tabs.Controls[3].FindControl("motherJob") as TextBox;
        TextBox motherMobile = Tabs.Controls[3].FindControl("motherMobile") as TextBox;

        DropDownList activity = Tabs.Controls[4].FindControl("activity") as DropDownList;
        TextBox activityPlace = Tabs.Controls[4].FindControl("activityPlace") as TextBox;
        TextBox activityChamp = Tabs.Controls[4].FindControl("activityChamp") as TextBox;
        TextBox activityChampDate = Tabs.Controls[4].FindControl("activityChampDate") as TextBox;
        DropDownList hoppy = Tabs.Controls[4].FindControl("hoppy") as DropDownList;
        TextBox hoppyPlace = Tabs.Controls[4].FindControl("hoppyPlace") as TextBox;
        
        DropDownList armyStatus = Tabs.Controls[5].FindControl("armyStatus") as DropDownList;
        TextBox thiroidNo = Tabs.Controls[5].FindControl("thiroidNo") as TextBox;
        TextBox exemptedDate = Tabs.Controls[5].FindControl("exemptedDate") as TextBox;
        TextBox exemptedNo = Tabs.Controls[5].FindControl("exemptedNo") as TextBox;
        TextBox operativeDecision = Tabs.Controls[5].FindControl("operativeDecision") as TextBox;
        
        DropDownList ddlAcceptance = Tabs.Controls[6].FindControl("ddlAcceptance") as DropDownList;
        TextBox txtAcceptanceDate = Tabs.Controls[6].FindControl("txtAcceptanceDate") as TextBox;
        TextBox txtAcceptanceNumber = Tabs.Controls[6].FindControl("txtAcceptanceNumber") as TextBox;
        TextBox txtTransferDate = Tabs.Controls[6].FindControl("txtTransferDate") as TextBox;
        TextBox txtTransferFrom = Tabs.Controls[6].FindControl("txtTransferFrom") as TextBox;
        
        TextBox codeText = Tabs.Controls[0].FindControl("codeText") as TextBox;
        e.NewValues["StudentCode"] = codeText.Text;
        e.NewValues["FirstName"] = studentFirstName.Text; ;
        e.NewValues["MiddleName"] = studentMiddleName.Text; ;
        e.NewValues["LastName"] = studentLastName.Text;
        e.NewValues["ArFirstName"] = arStudentFirstName.Text;
        e.NewValues["ArMiddleName"] = arStudentSecondName.Text;
        e.NewValues["ArLastName"] = arStudentLastName.Text;

        e.NewValues["Gender"] = Convert.ToBoolean(gender.SelectedItem.Value);
        e.NewValues["Religion"] = Convert.ToInt32(religion.SelectedItem.Value);
        e.NewValues["DateOfBirth"] = Convert.ToDateTime(birthdate.Text, culture);
        e.NewValues["PlaceOfBirth"] = Convert.ToInt32(birthPlace.SelectedValue);
        e.NewValues["NationalId"] = nationalId.Text;
        e.NewValues["NationalIdReleaseDate"] = ReleaseDate.Text == "" ? ReleaseDate.Text : Convert.ToDateTime(ReleaseDate.Text, culture).ToShortDateString();
        e.NewValues["NationalIdReleaseZone"] = Convert.ToInt32(NationalZone.SelectedValue);
        e.NewValues["Nationality"] = Convert.ToInt32(nationality.SelectedValue);
        e.NewValues["PassportId"] = passportNo.Text;
        e.NewValues["PassportReleaseDate"] = PaassportRelDate.Text == "" ? PaassportRelDate.Text : Convert.ToDateTime(PaassportRelDate.Text, culture).ToShortDateString();
        e.NewValues["PassportExpirationDate"] = PassExpirDate.Text == "" ? PassExpirDate.Text : Convert.ToDateTime(PassExpirDate.Text, culture).ToShortDateString();
        e.NewValues["FatherName"] = fatherName.Text;
        e.NewValues["ArFatherName"] = arFatherName.Text;
        e.NewValues["FatherJob"] = fatherJob.Text;
        e.NewValues["ArFatherJob"] = arFatherJob.Text;
        e.NewValues["MotherName"] = motherName.Text;
        e.NewValues["ArMotherName"] = arMotherName.Text;
        e.NewValues["MotherJob"] = motherJob.Text;
        e.NewValues["ArMotherJob"] = arMotherJob.Text;
        e.NewValues["FirstForeignLanguage"] = Convert.ToInt32(firstLanguage.SelectedValue);
        e.NewValues["SecondForeignLanguage"] = Convert.ToInt32(secondLanguage.SelectedValue);

        e.NewValues["DepartmentId"] = Convert.ToInt32(departments.SelectedValue);
        e.NewValues["YearId"] = Convert.ToInt32(years.SelectedValue);

        e.NewValues["ActivityId"] = Convert.ToInt32(activity.SelectedValue);
        e.NewValues["ActivityPlace"] = activityPlace.Text;
        e.NewValues["ActivityChampionship"] = activityChamp.Text;
        e.NewValues["ActivityChampionshipDate"] = activityChampDate.Text == "" ? activityChampDate.Text : Convert.ToDateTime(activityChampDate.Text, culture).ToShortDateString();

        e.NewValues["CertificateId"] = Convert.ToInt32(certificate.SelectedValue);
        e.NewValues["CertificateCountry"] = Convert.ToInt32(certitificateLocation.SelectedValue);
        e.NewValues["CertificateYear"] = certificateYear.SelectedValue;
        e.NewValues["CertificateSeatNo"] = certificateٍٍٍSeatNo.Text;
        e.NewValues["CertificateTotalResult"] = Convert.ToDecimal(certificateTotalResult.Text);
        e.NewValues["CertificateResultPercentage"] = Convert.ToDecimal(certificateResultPercentage.Text);

        e.NewValues["StudentPhone"] = studentPhone.Text;
        e.NewValues["StudentMobile"] = studentMobile.Text;
        e.NewValues["StudentEmail"] = studentEmail.Text;
        e.NewValues["StudentFacebook"] = studentFacebook.Text;
        e.NewValues["StudentTwitter"] = studentTwitter.Text;
        e.NewValues["FatherMobile"] = fahterMobile.Text;
        e.NewValues["FatherEmail"] = fatherEmail.Text;
        e.NewValues["MotherMobile"] = motherMobile.Text;
        e.NewValues["StudentAddress"] = address.Text;
        e.NewValues["ArStudentAddress"] = arAddress.Text;
        e.NewValues["StudentAddressLocation"] = Convert.ToInt32(addressLocation.SelectedValue);

        e.NewValues["HoppyId"] = Convert.ToInt32(hoppy.SelectedValue);
        e.NewValues["HoppyPlace"] = hoppyPlace.Text;
        
        
        e.NewValues["ArmyId"] = armyStatus.SelectedValue;
        e.NewValues["ExemptedNumber"] = exemptedNo.Text;
        e.NewValues["ThirdNumber"] = thiroidNo.Text;
        e.NewValues["ExemptedDate"] = exemptedDate.Text == "" ? exemptedDate.Text : Convert.ToDateTime(exemptedDate.Text, culture).ToShortDateString();
        e.NewValues["OperativeDecision"] = operativeDecision.Text;
        //e.NewValues["Image"] = "";

        e.NewValues["AcceptanceId"] = Convert.ToInt32(ddlAcceptance.SelectedValue);
        e.NewValues["AcceptanceDate"] = txtAcceptanceDate.Text == "" ? txtAcceptanceDate.Text : Convert.ToDateTime(txtAcceptanceDate.Text, culture).ToShortDateString();
        e.NewValues["AcceptanceNumber"] = Convert.ToInt32(txtAcceptanceNumber.Text);
        e.NewValues["TransferDate"] = txtTransferDate.Text == "" ? txtTransferDate.Text : Convert.ToDateTime(txtTransferDate.Text, culture).ToShortDateString();
        e.NewValues["TransferFrom"] = txtTransferFrom.Text;
        
        string folder = Server.MapPath("~/Students/Images/");//"C:/Inetpub/vhosts/hanbly.net/httpdocs/TeiAdmin/Students/Images/";
        string fileName = string.Empty;
        string Thumbnail = string.Empty;

        FileUpload PhotoUpld = Tabs.Controls[0].FindControl("studentImage") as FileUpload;
        if (PhotoUpld.HasFile)
        {
            if (Regex.IsMatch(PhotoUpld.PostedFile.ContentType, "image/\\S+") && PhotoUpld.PostedFile.ContentType != "image/tiff")
            {
                fileName = Path.GetFileName(PhotoUpld.PostedFile.FileName);
                fileName = Common.SetUniqueFilename(folder, fileName.Replace(fileName.Split('.')[0], e.NewValues["StudentCode"].ToString()));
                PhotoUpld.SaveAs(folder + fileName);

                Common.ResizeImage(folder, fileName, 150, 180, true, false);

                e.NewValues["Image"] = fileName;

                PhotoUpld.Dispose();
            }
            else
            {
                imgErr.Visible = true;
                e.Cancel = true;
            }
        }
        else
            e.NewValues["Image"] = e.OldValues["Image"];
    }
    protected void StudentsForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            updateErr.Visible = true;
            e.ExceptionHandled = true;
            e.KeepInEditMode = true;
            updateErr.Visible = true;

            string folder = Server.MapPath("~/Students/Images/");

            if (e.NewValues["Image"].ToString() != "")
                Common.DeleteFileFromDisk(folder + e.NewValues["Image"]);

        }
        else
        {
            AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;

            Label lblPhoto = Tabs.Controls[0].FindControl("lblPhoto") as Label;

            string folder = Server.MapPath("~/Students/Images/");

            if (lblPhoto.Text != "")
            {
                if (e.NewValues["Image"].ToString() != lblPhoto.Text)
                    Common.DeleteFileFromDisk(folder + lblPhoto.Text);
            }

            
            PageView.ActiveViewIndex = 1;
            StudentsForm.ChangeMode(FormViewMode.Insert);
            grdStudents.DataBind();
        }

    }
    protected void StudentsForm_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
        {
             StudentsForm.DefaultMode = FormViewMode.Insert;
            PageView.ActiveViewIndex = 1;
            //StudentsForm.ChangeMode(FormViewMode.Insert);
           
        }
    }


    protected void lnkBack_Click(object sender, EventArgs e)
    {
        StudentsForm.ChangeMode(FormViewMode.Insert);


        grdStudents.DataBind();
        PageView.ActiveViewIndex = 1;
        //  StudentsForm.DefaultMode = FormViewMode.ReadOnly;

    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        StudentsForm.ChangeMode(FormViewMode.Insert);
        PageView.ActiveViewIndex = 0;

    }
    protected void Next_Click(object sender, EventArgs e)
    {
        bool isValid = StudentsDAL.IsValidNationalId(nationalId1.Text);
        if (isValid)
        {
            AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;
            Tabs.ActiveTab = Tabs.Tabs[1];
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alerts", "alert('رقم قومي مسجل مسبقا')", true);
        }

        
       
    }

    protected void Next1_Click(object sender, EventArgs e)
    {

        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;
        Tabs.ActiveTab = Tabs.Tabs[2];

    }
    protected void Next2_Click(object sender, EventArgs e)
    {

        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;
        Tabs.ActiveTab = Tabs.Tabs[3];

    }
    protected void Next3_Click(object sender, EventArgs e)
    {

        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;
        Tabs.ActiveTab = Tabs.Tabs[4];

    }
    protected void Previous0_Click(object sender, EventArgs e)
    {
        
        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;
        Tabs.ActiveTab =Tabs.Tabs[0];
       
    }
    protected void Previous1_Click(object sender, EventArgs e)
    {

        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;
        Tabs.ActiveTab = Tabs.Tabs[1];

    }
    protected void Previous2_Click(object sender, EventArgs e)
    {

        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;
        Tabs.ActiveTab = Tabs.Tabs[2];

    }

    protected void Previous3_Click(object sender, EventArgs e)
    {

        AjaxControlToolkit.TabContainer Tabs = StudentsForm.Controls[0].FindControl("Tabs") as AjaxControlToolkit.TabContainer;
        Tabs.ActiveTab = Tabs.Tabs[3];

    }
    protected void StudentsDS_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.ReturnValue != null)
            lblStudentId.Text = e.ReturnValue.ToString();
        else
            lblStudentId.Text = "0";
    }
    protected void grdStudents_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            e.ExceptionHandled = true;
            deleteErr.Visible = true;
        }
    }
    protected void grdStudents_SelectedIndexChanged(object sender, EventArgs e)
    {
        StudentsForm.ChangeMode(FormViewMode.Edit);
        PageView.ActiveViewIndex = 0;

    }
    protected void grdStudents_DataBound(object sender, EventArgs e)
    {
        //btnAdd1.Visible = Convert.ToBoolean(grdStudents.Rows.Count);
    }
    protected void DataSourceDeleted(object sender, ObjectDataSourceStatusEventArgs e)
    {
        e.AffectedRows = Convert.ToInt32(e.ReturnValue);
    }

    protected void StudentsDataSource_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        if (!e.ExecutingSelectCount)
        {
            e.InputParameters["StudentCode"] = txtٍStudentCode.Text;
            e.InputParameters["ArFirstName"] = txtFirstName.Text;
            e.InputParameters["ArMiddleName"] = txtSecondName.Text;
            e.InputParameters["ArLastName"] = txtLastName.Text;
            e.InputParameters["YearId"] = years31.SelectedValue.ToString();
            e.InputParameters["DepartmentId"] = departmentDDL.SelectedValue.ToString();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdStudents.DataBind();
    }
    protected void grdStudents_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ViewData")
        {
           //udentsForm.ChangeMode(FormViewMode.ReadOnly);
           // StudentsDS.C
            //StudentsDS.SelectParameters["studentId"]. = e.CommandArgument.ToString();
            //StudentsDS.DataBind();
            StudentsForm.DataSourceID = "";
            StudentsForm.DataSource = StudentsDAL.GetById(Convert.ToInt32(e.CommandArgument.ToString()));
            StudentsForm.DataBind();
            StudentsForm.ChangeMode(FormViewMode.ReadOnly);
            PageView.ActiveViewIndex = 0;
        }
    }
}
