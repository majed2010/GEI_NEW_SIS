import { Component, inject, signal } from '@angular/core';
import { ApiError, AuthService } from './auth.service';
import { IconComponent } from './icon.component';

type Lookup = { id: number; label: string; hidden: boolean };
type StudentRow = { studentId: number; studentCode: string; arabicName: string; englishName?: string; department?: string; year?: string; semester?: string; nationality?: string; acceptance?: string; enrollment?: string; archived: boolean };
type StudentDetail = { studentId: number; studentCode: string; archived: boolean; version: string; student: Record<string, any>; metadata: Record<string, unknown> };
type Context = { admissionYearId: number | null; admissionYear: string | null; actualYear: string | null; admissionsSemesterId: number | null; admissionsSemester: string | null; defaultDepartmentId: number; canCreate: boolean; configurationMessage: string | null; writeSchemaReady: boolean; canWrite: boolean; writeMessage: string | null };
type Field = { path: string; label: string; type?: 'text'|'date'|'number'|'email'|'select'|'textarea'; lookup?: string; required?: boolean; hint?: string };
type Section = { title: string; description: string; fields: Field[] };
type DetailField = { path: string; label: string; lookup?: string; wide?: boolean; ltr?: boolean };
type DetailBlock = { title: string; fields: DetailField[] };
type DetailTab = { id: string; title: string; subtitle: string; icon: string; blocks: DetailBlock[] };

const sections: Section[] = [
  { title: 'بيانات الطالب', description: 'الهوية والاسم كما يظهران في المستندات الرسمية.', fields: [
    { path:'arabicName.first',label:'الاسم الأول بالعربية',required:true },{ path:'arabicName.middle',label:'الاسم الأوسط بالعربية',required:true },{ path:'arabicName.last',label:'اسم العائلة بالعربية',required:true },
    { path:'englishName.first',label:'First name',required:true },{ path:'englishName.middle',label:'Middle name',required:true },{ path:'englishName.last',label:'Last name',required:true },
    { path:'gender',label:'النوع',type:'select',lookup:'gender',required:true },{ path:'religion',label:'الديانة',type:'select',lookup:'religion',required:true },
    { path:'dateOfBirth',label:'تاريخ الميلاد',type:'date',required:true },{ path:'placeOfBirth',label:'مكان الميلاد',type:'select',lookup:'birthPlaces',required:true },
    { path:'nationality',label:'الجنسية',type:'select',lookup:'nationalities',required:true },{ path:'nationalId',label:'الرقم القومي',hint:'للمصريين: ١٤ رقماً ويطابق تاريخ الميلاد' },
    { path:'nationalIdReleaseDate',label:'تاريخ إصدار البطاقة',type:'date' },{ path:'nationalIdReleaseZone',label:'جهة إصدار البطاقة',type:'select',lookup:'locations' },
    { path:'passportId',label:'رقم جواز السفر',hint:'إلزامي لغير المصريين' },{ path:'passportReleaseDate',label:'تاريخ إصدار الجواز',type:'date' },{ path:'passportExpirationDate',label:'تاريخ انتهاء الجواز',type:'date' }
  ] },
  { title: 'المؤهل الدراسي', description: 'بيانات الشهادة التي يتقدم بها الطالب.', fields: [
    { path:'certificate.certificateId',label:'نوع الشهادة',type:'select',lookup:'certificates',required:true },{ path:'certificate.countryLocationId',label:'بلد الشهادة',type:'select',lookup:'countries',required:true },
    { path:'certificate.yearId',label:'سنة الشهادة',type:'select',lookup:'years',required:true },{ path:'certificate.seatNumber',label:'رقم الجلوس',required:true },
    { path:'certificate.totalResult',label:'المجموع',type:'number',required:true },{ path:'certificate.resultPercentage',label:'النسبة المئوية',type:'number',required:true },
    { path:'certificate.schoolName',label:'المدرسة' },{ path:'certificate.educationalPlace',label:'مكان التعليم' },
    { path:'firstForeignLanguage',label:'اللغة الأجنبية الأولى',type:'select',lookup:'languages' },{ path:'secondForeignLanguage',label:'اللغة الأجنبية الثانية',type:'select',lookup:'languages' }
  ] },
  { title: 'التواصل والعنوان', description: 'وسائل التواصل ومحل الإقامة الحالي.', fields: [
    { path:'contact.mobile',label:'الهاتف المحمول',required:true },{ path:'contact.mobile2',label:'هاتف محمول إضافي' },{ path:'contact.phone',label:'هاتف أرضي' },
    { path:'contact.email',label:'البريد الإلكتروني',type:'email',required:true },{ path:'contact.addressLocationId',label:'منطقة السكن',type:'select',lookup:'locations',required:true },
    { path:'contact.arabicAddress',label:'العنوان بالعربية',type:'textarea',required:true },{ path:'contact.address',label:'Address',type:'textarea' },
    { path:'contact.facebook',label:'Facebook' },{ path:'contact.twitter',label:'Twitter / X' }
  ] },
  { title: 'بيانات الأسرة', description: 'معلومات الوالدين ووسائل الاتصال بهما.', fields: [
    { path:'arFatherName',label:'اسم الأب بالعربية',required:true },{ path:'fatherName',label:'Father name',required:true },
    { path:'arFatherJob',label:'مهنة الأب بالعربية' },{ path:'fatherJob',label:'Father job',required:true },
    { path:'contact.fatherMobile',label:'هاتف الأب' },{ path:'contact.fatherEmail',label:'بريد الأب',type:'email' },
    { path:'arMotherName',label:'اسم الأم بالعربية' },{ path:'motherName',label:'Mother name' },
    { path:'arMotherJob',label:'مهنة الأم بالعربية' },{ path:'motherJob',label:'Mother job' },{ path:'contact.motherMobile',label:'هاتف الأم' }
  ] },
  { title: 'الأنشطة والقبول', description: 'النشاط والهواية ومصدر معرفة الطالب بالمعهد.', fields: [
    { path:'activity.activityId',label:'النشاط',type:'select',lookup:'activities',required:true },{ path:'activity.place',label:'مكان النشاط' },
    { path:'activity.championship',label:'البطولة أو الإنجاز' },{ path:'activity.championshipDate',label:'تاريخ البطولة',type:'date' },
    { path:'hobbyId',label:'الهواية',type:'select',lookup:'hobbies',required:true },{ path:'hobbyPlace',label:'مكان ممارسة الهواية' },
    { path:'instituteStatementId',label:'كيف عرفت المعهد؟',type:'select',lookup:'instituteStatements',required:true },
    { path:'armyStatusId',label:'الموقف من التجنيد',type:'select',lookup:'armyStatuses' },
    { path:'armyExemptedNumber',label:'رقم الإعفاء' },{ path:'armyThirdNumber',label:'الرقم الثلاثي' },
    { path:'armyExemptedDate',label:'تاريخ الإعفاء',type:'date' },{ path:'armyOperativeDecision',label:'القرار التنفيذي' },
    { path:'acceptanceTypeId',label:'نوع القبول',type:'select',lookup:'acceptanceTypes' },
    { path:'enrollmentStatusId',label:'حالة القيد',type:'select',lookup:'enrollmentStatuses' },
    { path:'acceptanceDate',label:'تاريخ القبول',type:'date' },{ path:'acceptanceNumber',label:'رقم القبول',type:'number' },
    { path:'transferDate',label:'تاريخ التحويل',type:'date' },{ path:'transferFrom',label:'الجهة المحوّل منها' }
  ] }
];

const detailTabs: DetailTab[] = [
  { id:'personal', title:'البيانات الشخصية', subtitle:'الاسم والهوية والميلاد', icon:'people', blocks:[
    { title:'الاسم والبيانات الأساسية', fields:[
      {path:'arabicName',label:'الاسم الكامل بالعربية',wide:true},{path:'englishName',label:'الاسم الكامل بالإنجليزية',wide:true,ltr:true},
      {path:'dateOfBirth',label:'تاريخ الميلاد'},{path:'gender',label:'النوع',lookup:'gender'},
      {path:'religion',label:'الديانة',lookup:'religion'},{path:'nationality',label:'الجنسية',lookup:'nationalities'},
      {path:'placeOfBirth',label:'مكان الميلاد',lookup:'birthPlaces'}
    ]},
    { title:'مستندات الهوية', fields:[
      {path:'nationalId',label:'الرقم القومي',ltr:true},{path:'nationalIdReleaseDate',label:'تاريخ إصدار البطاقة'},
      {path:'nationalIdReleaseZone',label:'جهة إصدار البطاقة',lookup:'locations'},
      {path:'passportId',label:'رقم جواز السفر',ltr:true},{path:'passportReleaseDate',label:'تاريخ إصدار الجواز'},
      {path:'passportExpirationDate',label:'تاريخ انتهاء الجواز'}
    ]}
  ]},
  { id:'education', title:'المؤهل الدراسي', subtitle:'الشهادة واللغات', icon:'book', blocks:[
    { title:'الشهادة السابقة', fields:[
      {path:'certificate.certificateId',label:'نوع الشهادة',lookup:'certificates'},
      {path:'certificate.countryLocationId',label:'بلد الشهادة',lookup:'countries'},
      {path:'certificate.yearId',label:'سنة الشهادة',lookup:'years'},
      {path:'certificate.seatNumber',label:'رقم الجلوس',ltr:true},
      {path:'certificate.totalResult',label:'المجموع'},{path:'certificate.resultPercentage',label:'النسبة المئوية'},
      {path:'certificate.schoolName',label:'المدرسة',wide:true},{path:'certificate.educationalPlace',label:'مكان التعليم',wide:true}
    ]},
    { title:'اللغات', fields:[{path:'firstForeignLanguage',label:'اللغة الأجنبية الأولى',lookup:'languages'},
      {path:'secondForeignLanguage',label:'اللغة الأجنبية الثانية',lookup:'languages'}]}
  ]},
  { id:'contact', title:'التواصل والعنوان', subtitle:'الهواتف والبريد ومحل الإقامة', icon:'bell', blocks:[
    { title:'وسائل التواصل', fields:[
      {path:'contact.mobile',label:'الهاتف المحمول',ltr:true},{path:'contact.mobile2',label:'هاتف إضافي',ltr:true},
      {path:'contact.phone',label:'الهاتف الأرضي',ltr:true},{path:'contact.email',label:'البريد الإلكتروني',ltr:true,wide:true},
      {path:'contact.facebook',label:'Facebook',ltr:true},{path:'contact.twitter',label:'Twitter / X',ltr:true}
    ]},
    { title:'العنوان', fields:[
      {path:'contact.addressLocationId',label:'منطقة السكن',lookup:'locations'},
      {path:'contact.arabicAddress',label:'العنوان بالعربية',wide:true},
      {path:'contact.address',label:'Address',wide:true,ltr:true}
    ]}
  ]},
  { id:'family', title:'بيانات الأسرة', subtitle:'الأب والأم ووسائل التواصل', icon:'people', blocks:[
    { title:'بيانات الأب', fields:[
      {path:'arFatherName',label:'الاسم بالعربية',wide:true},{path:'fatherName',label:'الاسم بالإنجليزية',wide:true,ltr:true},
      {path:'arFatherJob',label:'المهنة بالعربية'},{path:'fatherJob',label:'المهنة بالإنجليزية',ltr:true},
      {path:'contact.fatherMobile',label:'الهاتف',ltr:true},{path:'contact.fatherEmail',label:'البريد الإلكتروني',ltr:true}
    ]},
    { title:'بيانات الأم', fields:[
      {path:'arMotherName',label:'الاسم بالعربية',wide:true},{path:'motherName',label:'الاسم بالإنجليزية',wide:true,ltr:true},
      {path:'arMotherJob',label:'المهنة بالعربية'},{path:'motherJob',label:'المهنة بالإنجليزية',ltr:true},
      {path:'contact.motherMobile',label:'الهاتف',ltr:true}
    ]}
  ]},
  { id:'admission', title:'القبول والقيد', subtitle:'الدفعة والحالة والموقف العسكري', icon:'file', blocks:[
    { title:'بيانات القبول', fields:[
      {path:'admissionYearId',label:'سنة القبول',lookup:'years'},{path:'admissionsSemesterId',label:'فصل القبول',lookup:'semesters'},
      {path:'departmentId',label:'القسم',lookup:'departments'},
      {path:'acceptanceTypeId',label:'نوع القبول',lookup:'acceptanceTypes'},
      {path:'enrollmentStatusId',label:'حالة القيد',lookup:'enrollmentStatuses'},
      {path:'acceptanceDate',label:'تاريخ القبول'},{path:'acceptanceNumber',label:'رقم القبول',ltr:true},
      {path:'transferDate',label:'تاريخ التحويل'},{path:'transferFrom',label:'الجهة المحوّل منها',wide:true}
    ]},
    { title:'الموقف من التجنيد', fields:[
      {path:'armyStatusId',label:'الحالة',lookup:'armyStatuses'},
      {path:'armyExemptedNumber',label:'رقم الإعفاء',ltr:true},{path:'armyThirdNumber',label:'الرقم الثلاثي',ltr:true},
      {path:'armyExemptedDate',label:'تاريخ الإعفاء'},
      {path:'armyOperativeDecision',label:'القرار التنفيذي',wide:true}
    ]}
  ]},
  { id:'activities', title:'الأنشطة والهوايات', subtitle:'اهتمامات الطالب ومصدر التعرف على المعهد', icon:'layers', blocks:[
    { title:'الأنشطة والإنجازات', fields:[
      {path:'activity.activityId',label:'النشاط',lookup:'activities'},
      {path:'activity.place',label:'مكان النشاط'},
      {path:'activity.championship',label:'البطولة أو الإنجاز',wide:true},
      {path:'activity.championshipDate',label:'تاريخ البطولة'}
    ]},
    { title:'الهوايات والتعريف بالمعهد', fields:[
      {path:'hobbyId',label:'الهواية',lookup:'hobbies'},
      {path:'hobbyPlace',label:'مكان ممارسة الهواية'},
      {path:'instituteStatementId',label:'كيف عرفت المعهد؟',lookup:'instituteStatements',wide:true}
    ]}
  ]}
];

function blankStudent(context: Context | null): Record<string, any> {
  return { arabicName:{first:'',middle:'',last:''}, englishName:{first:'',middle:'',last:''}, gender:null, religion:null,
    dateOfBirth:null,placeOfBirth:null,nationality:null,nationalId:null,nationalIdReleaseDate:null,nationalIdReleaseZone:null,
    passportId:null,passportReleaseDate:null,passportExpirationDate:null,fatherName:'',arFatherName:'',fatherJob:'',arFatherJob:null,
    motherName:null,arMotherName:null,motherJob:null,arMotherJob:null,firstForeignLanguage:null,secondForeignLanguage:null,
    departmentId:1,admissionYearId:context?.admissionYearId ?? null,admissionsSemesterId:context?.admissionsSemesterId ?? null,
    certificate:{certificateId:null,countryLocationId:null,yearId:null,seatNumber:null,totalResult:null,resultPercentage:null,schoolName:null,educationalPlace:null},
    contact:{phone:null,mobile:null,mobile2:null,email:null,fatherMobile:null,fatherEmail:null,motherMobile:null,address:null,arabicAddress:null,addressLocationId:null,facebook:null,twitter:null},
    activity:{activityId:null,place:null,championship:null,championshipDate:null},hobbyId:null,hobbyPlace:null,instituteStatementId:null,
    armyStatusId:1,armyExemptedNumber:null,armyThirdNumber:null,armyExemptedDate:null,armyOperativeDecision:null,
    acceptanceTypeId:1,enrollmentStatusId:1,acceptanceDate:null,acceptanceNumber:null,transferDate:null,transferFrom:null };
}

@Component({ selector: 'sis-admissions', imports: [IconComponent], templateUrl: './admissions.component.html', styleUrl: './admissions.component.css' })
export class AdmissionsComponent {
  private auth = inject(AuthService);
  readonly sections = sections;
  readonly detailTabs = detailTabs;
  readonly detailTab = signal('personal');
  readonly view = signal<'list'|'form'|'detail'>('list');
  readonly step = signal(0);
  readonly busy = signal(false);
  readonly error = signal('');
  readonly notice = signal('');
  readonly context = signal<Context | null>(null);
  readonly lookups = signal<Record<string, Lookup[]>>({});
  readonly rows = signal<StudentRow[]>([]);
  readonly total = signal(0);
  readonly page = signal(1);
  readonly archived = signal(false);
  readonly detail = signal<StudentDetail | null>(null);
  readonly photoUrl = signal<string | null>(null);
  readonly editing = signal(false);
  readonly form = signal<Record<string, any>>(blankStudent(null));
  readonly fieldErrors = signal<Record<string,string>>({});
  readonly archiveOpen = signal(false);
  readonly archiveReason = signal('');
  readonly search = { query:'', nationalId:'', passportId:'', yearId:null as number|null, semesterId:null as number|null, departmentId:null as number|null,
    nationalityId:null as number|null, acceptanceId:null as number|null, enrollmentId:null as number|null,
    arabicFirstName:'',arabicMiddleName:'',arabicLastName:'',sort:'newest' };
  private requestKey = crypto.randomUUID();
  get supervisor(): boolean { return this.auth.roles().includes('Admissions.Supervisor'); }
  get selectedSection(): Section { return sections[this.step()]; }
  get pageCount(): number { return Math.max(1, Math.ceil(this.total()/25)); }
  constructor() { void this.load(); }

  async load(): Promise<void> {
    this.busy.set(true); this.error.set('');
    try {
      const [context, lookups] = await Promise.all([
        this.auth.api<Context>('/admissions/context'),
        this.auth.api<Record<string,Lookup[]>>('/admissions/lookups')
      ]);
      this.context.set(context); this.lookups.set(lookups);
      await this.find(1);
    } catch (error) { this.error.set(this.message(error)); }
    finally { this.busy.set(false); }
  }
  async find(page = 1): Promise<void> {
    this.busy.set(true); this.error.set('');
    try {
      const result = await this.auth.api<{items:StudentRow[];total:number}>('/admissions/students/search', {
        method:'POST',body:JSON.stringify({...this.search,archived:this.archived(),page,pageSize:25})
      });
      this.rows.set(result.items); this.total.set(result.total); this.page.set(page);
    } catch (error) { this.error.set(this.message(error)); }
    finally { this.busy.set(false); }
  }
  async show(id: number): Promise<void> {
    this.busy.set(true); this.error.set('');
    try {
      this.detail.set(await this.auth.api<StudentDetail>(`/admissions/students/${id}`)); this.detailTab.set('personal'); this.archiveOpen.set(false); this.view.set('detail');
      if (this.photoUrl()) URL.revokeObjectURL(this.photoUrl()!);
      this.photoUrl.set(null);
      if (this.detail()?.student.image) {
        try { const blob = await this.auth.apiBlob(`/admissions/students/${id}/photo`); if (blob) this.photoUrl.set(URL.createObjectURL(blob)); }
        catch { /* A missing legacy image must not hide the student record. */ }
      }
    }
    catch (error) { this.error.set(this.message(error)); }
    finally { this.busy.set(false); }
  }
  newStudent(): void {
    if (!this.context()?.canCreate) return;
    this.form.set(blankStudent(this.context())); this.detail.set(null); this.editing.set(false); this.step.set(0);
    this.fieldErrors.set({}); this.error.set(''); this.notice.set(''); this.requestKey = crypto.randomUUID(); this.view.set('form');
  }
  editStudent(): void {
    const detail = this.detail(); if (!detail || detail.archived || !this.context()?.canWrite) return;
    this.form.set(structuredClone(detail.student)); this.editing.set(true); this.step.set(0); this.fieldErrors.set({}); this.error.set(''); this.view.set('form');
  }
  value(path: string): string | number | boolean | null {
    const [first, second] = path.split('.'); const raw = second ? this.form()[first]?.[second] : this.form()[first];
    if (raw == null) return null;
    if (raw instanceof Date) return raw.toISOString().slice(0,10);
    if (typeof raw === 'string' && /^\d{4}-\d\d-\d\dT/.test(raw)) return raw.slice(0,10);
    return raw;
  }
  valueFor(student: Record<string, any>, path: string): any {
    const [first, second] = path.split('.');
    return second ? student[first]?.[second] : student[first];
  }
  displayValue(student: Record<string, any>, path: string): string {
    const value = this.valueFor(student,path);
    if (value === null || value === undefined || value === '') return '—';
    return typeof value === 'string' && /^\d{4}-\d\d-\d\dT/.test(value) ? value.slice(0,10) : String(value);
  }
  detailValue(student: Record<string, any>, field: DetailField): string {
    if (field.path === 'arabicName' || field.path === 'englishName') {
      const name = student[field.path];
      return [name?.first, name?.middle, name?.last].filter(Boolean).join(' ') || '—';
    }
    return field.lookup ? this.label(field.lookup, this.valueFor(student,field.path)) : this.displayValue(student,field.path);
  }
  setValue(field: Field, event: Event): void {
    const target = event.target as HTMLInputElement | HTMLSelectElement;
    const value = field.path === 'gender' ? (target.value === '' ? null : target.value === '1') :
      field.type === 'select' || field.type === 'number' ? (target.value === '' ? null : Number(target.value)) : (target.value || null);
    const [first, second] = field.path.split('.'); const form = this.form();
    if (second) form[first][second] = value; else form[first] = value;
    this.form.set({...form});
    const errors = {...this.fieldErrors()}; delete errors[field.path]; this.fieldErrors.set(errors);
  }
  options(name: string): Lookup[] {
    if (name === 'gender') return [{id:1,label:'ذكر',hidden:false},{id:0,label:'أنثى',hidden:false}];
    if (name === 'religion') return [{id:1,label:'مسلم',hidden:false},{id:2,label:'مسيحي',hidden:false}];
    return this.lookups()[name] ?? [];
  }
  label(name: string, id: number | boolean | null | undefined): string {
    const key = typeof id === 'boolean' ? Number(id) : id;
    return this.options(name).find(o => o.id === key)?.label ?? '—';
  }
  initials(name: string): string { return name.trim().split(/\s+/).slice(0,2).map(part => part[0] || '').join(''); }
  next(): void {
    const errors: Record<string,string> = {};
    for (const field of this.selectedSection.fields) if (field.required && (this.value(field.path) === null || String(this.value(field.path)).trim() === ''))
      errors[field.path] = 'هذا الحقل مطلوب.';
    this.fieldErrors.set(errors);
    if (Object.keys(errors).length) { this.error.set('استكمل الحقول المطلوبة في هذه الخطوة.'); return; }
    this.error.set(''); this.step.set(Math.min(this.step()+1,sections.length));
  }
  async save(): Promise<void> {
    this.busy.set(true); this.error.set('');
    try {
      const detail = this.detail(); const editing = this.editing();
      const result = await this.auth.api<{studentId:number}>('/admissions/students' + (editing ? `/${detail!.studentId}` : ''), {
        method: editing ? 'PUT' : 'POST',
        headers: editing ? {'If-Match':detail!.version} : {'Idempotency-Key':this.requestKey},
        body:JSON.stringify(this.form())
      });
      this.notice.set(editing ? 'حُفظت تعديلات الطالب.' : 'أُضيف الطالب بنجاح.');
      await this.find(1); await this.show(result.studentId);
    } catch (error) {
      if (error instanceof ApiError && Object.keys(error.fields).length) {
        this.fieldErrors.set(error.fields);
        const first = sections.findIndex(section => section.fields.some(field => error.fields[field.path]));
        if (first >= 0) this.step.set(first);
      }
      this.error.set(this.message(error));
    }
    finally { this.busy.set(false); }
  }
  async changeArchive(): Promise<void> {
    const detail = this.detail(); if (!detail || !this.supervisor) return;
    const reason = detail.archived ? 'استعادة الطالب من الأرشيف' : this.archiveReason().trim();
    if (!reason) { this.error.set('اكتب سبب الأرشفة أولاً.'); return; }
    this.busy.set(true); this.error.set('');
    try {
      await this.auth.api<void>(`/admissions/students/${detail.studentId}/${detail.archived ? 'restore' : 'archive'}`, {
        method:'POST',body:JSON.stringify({reason,version:detail.version})
      });
      this.notice.set(detail.archived ? 'استُعيد الطالب من الأرشيف.' : 'أُرشف الطالب.');
      this.archiveOpen.set(false); this.archiveReason.set('');
      await this.find(1); await this.show(detail.studentId);
    } catch (error) { this.error.set(this.message(error)); }
    finally { this.busy.set(false); }
  }
  async uploadPhoto(event: Event): Promise<void> {
    const file = (event.target as HTMLInputElement).files?.[0]; const detail = this.detail();
    if (!file || !detail) return;
    if (!['image/jpeg','image/png'].includes(file.type) || file.size > 2_097_152) {
      this.error.set('اختر صورة JPEG أو PNG بحجم أقل من ٢ ميجابايت.'); return;
    }
    this.busy.set(true); this.error.set('');
    try {
      await this.auth.api(`/admissions/students/${detail.studentId}/photo`, {
        method:'PUT',headers:{'If-Match':detail.version,'Content-Type':file.type},body:file
      });
      this.notice.set('حُفظت صورة الطالب.'); await this.show(detail.studentId);
    } catch (error) { this.error.set(this.message(error)); }
    finally { this.busy.set(false); (event.target as HTMLInputElement).value = ''; }
  }
  print(): void { window.print(); }
  back(): void { this.error.set(''); this.view.set('list'); }
  private message(error: unknown): string { return error instanceof Error ? error.message : 'حدث خطأ غير متوقع.'; }
}
