using System.Globalization;
using System.Text.RegularExpressions;

namespace Gei.Sis.Api.Admissions;

public static partial class AdmissionsValidation
{
    [GeneratedRegex("^[0-9]{14}$")]
    private static partial Regex EgyptianIdPattern();

    public static IReadOnlyDictionary<string, string> Validate(StudentInput form, bool isCreate)
    {
        var errors = new Dictionary<string, string>();
        if (form.ArabicName is null || form.EnglishName is null || form.Certificate is null || form.Contact is null || form.Activity is null)
        {
            errors["student"] = "بيانات الطالب غير مكتملة.";
            return errors;
        }
        RequiredName(form.ArabicName, "arabicName", 50, 100, errors);
        RequiredName(form.EnglishName, "englishName", 50, 100, errors);
        Required(form.FatherName, "fatherName", 200, errors);
        Required(form.ArFatherName, "arFatherName", 200, errors);
        Required(form.FatherJob, "fatherJob", 100, errors);
        if (form.Gender is null) errors["gender"] = "اختر النوع.";
        if (form.Religion is not 1 and not 2) errors["religion"] = "اختر الديانة.";
        if (form.DateOfBirth is null || form.DateOfBirth.Value.Date >= DateTime.UtcNow.Date)
            errors["dateOfBirth"] = "أدخل تاريخ ميلاد صحيحاً في الماضي.";
        if (form.PlaceOfBirth is null or <= 0) errors["placeOfBirth"] = "اختر مكان الميلاد.";
        if (form.Nationality is null or <= 0) errors["nationality"] = "اختر الجنسية.";
        if (form.Nationality is > 0)
        {
            // The nationality key is resolved from the database by the repository.
            // Its Arabic label determines the Egyptian-specific requirement.
        }
        if (form.PassportReleaseDate > form.PassportExpirationDate)
            errors["passportExpirationDate"] = "تاريخ انتهاء جواز السفر يسبق تاريخ إصداره.";
        if (form.AcceptanceNumber is < 0) errors["acceptanceNumber"] = "رقم القبول غير صحيح.";
        if (form.Certificate.ResultPercentage is < 0 or > 100)
            errors["certificate.resultPercentage"] = "النسبة يجب أن تكون بين ٠ و١٠٠.";
        if (form.Certificate.CertificateId is null or <= 0) errors["certificate.certificateId"] = "اختر نوع الشهادة.";
        if (form.Certificate.CountryLocationId is null or <= 0) errors["certificate.countryLocationId"] = "اختر مكان الشهادة.";
        if (form.Certificate.YearId is null or <= 0) errors["certificate.yearId"] = "اختر سنة الشهادة.";
        Required(form.Certificate.SeatNumber, "certificate.seatNumber", 50, errors);
        if (form.Certificate.TotalResult is null or < 0) errors["certificate.totalResult"] = "أدخل مجموعاً صحيحاً.";
        if (form.Certificate.ResultPercentage is null) errors["certificate.resultPercentage"] = "أدخل النسبة المئوية.";
        Required(form.Contact.Mobile, "contact.mobile", 100, errors);
        Required(form.Contact.Email, "contact.email", 100, errors);
        Required(form.Contact.ArabicAddress, "contact.arabicAddress", 100, errors);
        if (form.Contact.AddressLocationId is null or <= 0) errors["contact.addressLocationId"] = "اختر منطقة السكن.";
        if (!string.IsNullOrWhiteSpace(form.Contact.Email) && !System.Net.Mail.MailAddress.TryCreate(form.Contact.Email, out _))
            errors["contact.email"] = "أدخل بريداً إلكترونياً صحيحاً.";
        if (!string.IsNullOrWhiteSpace(form.Contact.FatherEmail) && !System.Net.Mail.MailAddress.TryCreate(form.Contact.FatherEmail, out _))
            errors["contact.fatherEmail"] = "أدخل بريد الأب الإلكتروني بشكل صحيح.";
        if (form.InstituteStatementId is null or <= 0) errors["instituteStatementId"] = "اختر كيف عرفت المعهد.";
        if (form.Activity.ActivityId is null or <= 0) errors["activity.activityId"] = "اختر النشاط.";
        if (form.HobbyId is null or <= 0) errors["hobbyId"] = "اختر الهواية.";
        if (isCreate && (form.AdmissionYearId is null or <= 0 || form.AdmissionsSemesterId is null or <= 0))
            errors["admissionContext"] = "أعد تحميل إعدادات سنة وفصل القبول.";
        foreach (var entry in new (string? value, string path, int limit)[] {
            (form.NationalId,"nationalId",14), (form.PassportId,"passportId",100),
            (form.ArFatherJob,"arFatherJob",100), (form.MotherName,"motherName",200),
            (form.ArMotherName,"arMotherName",200), (form.MotherJob,"motherJob",100),
            (form.ArMotherJob,"arMotherJob",100), (form.Contact.Phone,"contact.phone",100),
            (form.Contact.Mobile2,"contact.mobile2",50), (form.Contact.FatherMobile,"contact.fatherMobile",100),
            (form.Contact.FatherEmail,"contact.fatherEmail",100), (form.Contact.MotherMobile,"contact.motherMobile",100),
            (form.Contact.Address,"contact.address",100), (form.Contact.Facebook,"contact.facebook",100),
            (form.Contact.Twitter,"contact.twitter",100), (form.Activity.Place,"activity.place",100),
            (form.Activity.Championship,"activity.championship",150), (form.HobbyPlace,"hobbyPlace",150),
            (form.ArmyExemptedNumber,"armyExemptedNumber",100), (form.ArmyThirdNumber,"armyThirdNumber",100),
            (form.TransferFrom,"transferFrom",150) })
            if (entry.value?.Trim().Length > entry.limit) errors[entry.path] = $"الحد الأقصى {entry.limit} حرفاً.";
        return errors;
    }

    public static bool ValidEgyptianId(string? value, DateTime? birthDate)
    {
        if (birthDate is null || string.IsNullOrWhiteSpace(value) || !EgyptianIdPattern().IsMatch(value)) return false;
        var century = value[0] switch { '2' => 1900, '3' => 2000, _ => 0 };
        if (century == 0) return false;
        var year = century + int.Parse(value.AsSpan(1, 2), CultureInfo.InvariantCulture);
        var month = int.Parse(value.AsSpan(3, 2), CultureInfo.InvariantCulture);
        var day = int.Parse(value.AsSpan(5, 2), CultureInfo.InvariantCulture);
        return DateTime.TryParseExact($"{year:D4}-{month:D2}-{day:D2}", "yyyy-MM-dd", CultureInfo.InvariantCulture,
            DateTimeStyles.None, out var encodedDate) && encodedDate.Date == birthDate.Value.Date;
    }

    private static void RequiredName(StudentName name, string path, int firstLimit, int otherLimit, Dictionary<string, string> errors)
    {
        Required(name.First, $"{path}.first", firstLimit, errors);
        Required(name.Middle, $"{path}.middle", otherLimit, errors);
        Required(name.Last, $"{path}.last", otherLimit, errors);
    }
    private static void Required(string? value, string path, int limit, Dictionary<string, string> errors)
    {
        if (string.IsNullOrWhiteSpace(value)) errors[path] = "هذا الحقل مطلوب.";
        else if (value.Trim().Length > limit) errors[path] = $"الحد الأقصى {limit} حرفاً.";
    }
}
