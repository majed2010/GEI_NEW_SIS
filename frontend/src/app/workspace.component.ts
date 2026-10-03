import { Component, computed, effect, inject, signal } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import { IconComponent } from './icon.component';
import { AuthService } from './auth.service';
import { ModalDirective } from './modal.directive';
import { AdmissionsComponent } from './admissions.component';
import { OfferingComponent } from './offering.component';

export const modules = [
  { id: 'admissions', name: 'القبول والتقديم', icon: 'people', text: 'من أول طلب، إلى أول يوم دراسي.', detail: 'إدارة طلبات الالتحاق، مراجعة المستندات، ومتابعة قرارات القبول.', color: 'blue', tags: ['طلبات الالتحاق', 'مراجعة المستندات', 'قرارات القبول'] },
  { id: 'offering', name: 'طرح المقررات والشعب', icon: 'layers', text: 'المقررات والمحاضرات والشعب في فصل واحد.', detail: 'إدارة المقررات المطروحة، المحاضرات، الشعب وسعاتها.', color: 'teal', tags: ['الطرح الأكاديمي', 'الشعب', 'السعات'] },
  { id: 'registrar', name: 'شؤون الطلاب والتسجيل', icon: 'file', text: 'سجل أكاديمي منظّم لكل طالب.', detail: 'متابعة ملفات الطلاب، القيد الأكاديمي، وتسجيل المقررات.', color: 'teal', tags: ['ملفات الطلاب', 'تسجيل المقررات', 'إفادات القيد'] },
  { id: 'courses', name: 'المقررات الدراسية', icon: 'book', text: 'كل مقرر، بكل تفاصيله.', detail: 'إعداد دليل المقررات، الساعات المعتمدة، والمتطلبات السابقة.', color: 'purple', tags: ['دليل المقررات', 'الساعات المعتمدة', 'المتطلبات السابقة'] },
  { id: 'curricula', name: 'البرامج والخطط الدراسية', icon: 'layers', text: 'خطط واضحة لمسيرة أكاديمية ناجحة.', detail: 'تهيئة البرامج الأكاديمية، اللوائح، والخطط الدراسية للأقسام.', color: 'amber', tags: ['البرامج الأكاديمية', 'اللوائح', 'الخطط الدراسية'] }
];
const requests = [
  { id: 'ADM-2026-0142', name: 'أحمد محمد علي', initials: 'أ م', type: 'طلب التحاق جديد', department: 'الهندسة المدنية', status: 'بانتظار المراجعة', tone: 'amber', date: '٢٦ سبتمبر ٢٠٢٦', time: 'منذ ١٥ دقيقة' },
  { id: 'REG-2026-0086', name: 'مريم خالد حسن', initials: 'م خ', type: 'تسجيل مقررات', department: 'الهندسة المعمارية', status: 'مكتمل', tone: 'teal', date: '٢٦ سبتمبر ٢٠٢٦', time: 'منذ ٣٠ دقيقة' },
  { id: 'ADM-2026-0141', name: 'يوسف محمود أحمد', initials: 'ي م', type: 'استكمال مستندات', department: 'هندسة الاتصالات والإلكترونيات', status: 'يحتاج إجراء', tone: 'red', date: '٢٦ سبتمبر ٢٠٢٦', time: 'منذ ساعة' },
  { id: 'REG-2026-0085', name: 'سارة أحمد إبراهيم', initials: 'س أ', type: 'طلب إفادة قيد', department: 'الهندسة المدنية', status: 'بانتظار المراجعة', tone: 'amber', date: '٢٦ سبتمبر ٢٠٢٦', time: 'منذ ساعتين' }
];
@Component({ selector: 'sis-workspace', imports: [IconComponent, RouterLink, ModalDirective, AdmissionsComponent, OfferingComponent], templateUrl: './workspace.component.html' })
export class WorkspaceComponent {
  auth = inject(AuthService); route = inject(ActivatedRoute);
  params = toSignal(this.route.paramMap, { initialValue: this.route.snapshot.paramMap });
  preview = this.route.snapshot.data['preview'] === true;
  base = this.preview ? '/preview' : '/workspace';
  modules = modules;
  module = computed(() => this.params().get('module') || 'home');
  selectedModule = computed(() => modules.find(m => m.id === this.module()));
  titles: Record<string, string> = { home: 'نظرة عامة', calendar: 'التقويم الأكاديمي', reports: 'التقارير والإحصاءات', settings: 'إعدادات النظام' };
  title = computed(() => this.selectedModule()?.name || this.titles[this.module()] || 'الصفحة غير موجودة');
  query = signal(''); filter = signal('all'); term = signal('2026'); mobileMenu = signal(false);
  panel = signal<'help' | 'notifications' | null>(null);
  selectedRequest = signal<(typeof requests)[number] | null>(null);
  visibleModules = computed(() => modules.filter(m => `${m.name} ${m.detail}`.includes(this.query().trim())));
  visibleRequests = computed(() => this.preview && this.term() === '2026' ? requests.filter(r => (this.filter() === 'all' || (this.filter() === 'pending' ? r.tone !== 'teal' : r.tone === 'teal')) && `${r.name} ${r.id} ${r.department}`.toLowerCase().includes(this.query().trim().toLowerCase())) : []);
  pendingCount = computed(() => this.preview && this.term() === '2026' ? '٣٢' : '—');
  constructor() { effect(() => { this.module(); this.mobileMenu.set(false); this.query.set(''); }); }
  closeDialog(event: MouseEvent) { if (event.target === event.currentTarget) { this.panel.set(null); this.selectedRequest.set(null); } }
}
