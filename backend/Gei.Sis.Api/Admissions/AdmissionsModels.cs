namespace Gei.Sis.Api.Admissions;

public sealed record SearchStudentsRequest(
    string? Query, string? NationalId, string? PassportId, int? YearId,
    int? SemesterId, int? DepartmentId, bool Archived = false,
    int Page = 1, int PageSize = 25, string Sort = "newest",
    int? NationalityId = null, int? AcceptanceId = null, int? EnrollmentId = null,
    string? ArabicFirstName = null, string? ArabicMiddleName = null, string? ArabicLastName = null);

public sealed record StudentListItem(
    int StudentId, string StudentCode, string ArabicName, string? EnglishName,
    string? Department, string? Year, string? Semester, string? Nationality,
    string? Acceptance, string? Enrollment, bool Archived);

public sealed record StudentSearchResult(IReadOnlyList<StudentListItem> Items, int Total, int Page, int PageSize);
public sealed record LookupItem(int Id, string Label, bool Hidden = false);
public sealed record AdmissionsContext(int? AdmissionYearId, string? AdmissionYear,
    string? ActualYear, int? AdmissionsSemesterId, string? AdmissionsSemester,
    int DefaultDepartmentId, bool CanCreate, string? ConfigurationMessage,
    bool WriteSchemaReady, bool CanWrite, string? WriteMessage);

public sealed record StudentName(string First, string Middle, string Last);
public sealed class StudentInput
{
    public StudentName ArabicName { get; set; } = new("", "", "");
    public StudentName EnglishName { get; set; } = new("", "", "");
    public bool? Gender { get; set; }
    public byte? Religion { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public int? PlaceOfBirth { get; set; }
    public int? Nationality { get; set; }
    public string? NationalId { get; set; }
    public DateTime? NationalIdReleaseDate { get; set; }
    public int? NationalIdReleaseZone { get; set; }
    public string? PassportId { get; set; }
    public DateTime? PassportReleaseDate { get; set; }
    public DateTime? PassportExpirationDate { get; set; }
    public string FatherName { get; set; } = "";
    public string ArFatherName { get; set; } = "";
    public string FatherJob { get; set; } = "";
    public string? ArFatherJob { get; set; }
    public string? MotherName { get; set; }
    public string? ArMotherName { get; set; }
    public string? MotherJob { get; set; }
    public string? ArMotherJob { get; set; }
    public int? FirstForeignLanguage { get; set; }
    public int? SecondForeignLanguage { get; set; }
    public int? DepartmentId { get; set; }
    public int? AdmissionYearId { get; set; }
    public int? AdmissionsSemesterId { get; set; }
    public CertificateInput Certificate { get; set; } = new();
    public ContactInput Contact { get; set; } = new();
    public ActivityInput Activity { get; set; } = new();
    public int? HobbyId { get; set; }
    public string? HobbyPlace { get; set; }
    public int? InstituteStatementId { get; set; }
    public int? ArmyStatusId { get; set; }
    public string? ArmyExemptedNumber { get; set; }
    public string? ArmyThirdNumber { get; set; }
    public DateTime? ArmyExemptedDate { get; set; }
    public string? ArmyOperativeDecision { get; set; }
    public int? AcceptanceTypeId { get; set; }
    public int? EnrollmentStatusId { get; set; }
    public DateTime? AcceptanceDate { get; set; }
    public int? AcceptanceNumber { get; set; }
    public DateTime? TransferDate { get; set; }
    public string? TransferFrom { get; set; }
    public string? Image { get; set; }
}

public sealed class CertificateInput
{
    public int? CertificateId { get; set; }
    public int? CountryLocationId { get; set; }
    public int? YearId { get; set; }
    public string? SeatNumber { get; set; }
    public decimal? TotalResult { get; set; }
    public decimal? ResultPercentage { get; set; }
    public string? SchoolName { get; set; }
    public string? EducationalPlace { get; set; }
}
public sealed class ContactInput
{
    public string? Phone { get; set; }
    public string? Mobile { get; set; }
    public string? Mobile2 { get; set; }
    public string? Email { get; set; }
    public string? FatherMobile { get; set; }
    public string? FatherEmail { get; set; }
    public string? MotherMobile { get; set; }
    public string? Address { get; set; }
    public string? ArabicAddress { get; set; }
    public int? AddressLocationId { get; set; }
    public string? Facebook { get; set; }
    public string? Twitter { get; set; }
}
public sealed class ActivityInput
{
    public int? ActivityId { get; set; }
    public string? Place { get; set; }
    public string? Championship { get; set; }
    public DateTime? ChampionshipDate { get; set; }
}
public sealed record StudentDetail(int StudentId, string StudentCode, bool Archived,
    string Version, StudentInput Student, IReadOnlyDictionary<string, object?> Metadata);
public sealed record ArchiveCommand(string Reason, string Version);
public sealed record SaveResult(int StudentId, string StudentCode, string Version);

public sealed class AdmissionsException(int statusCode, string code, string message,
    IReadOnlyDictionary<string, string>? fieldErrors = null) : Exception(message)
{
    public int StatusCode { get; } = statusCode;
    public string Code { get; } = code;
    public IReadOnlyDictionary<string, string>? FieldErrors { get; } = fieldErrors;
}
