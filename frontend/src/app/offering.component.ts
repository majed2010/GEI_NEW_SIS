import { Component, inject, OnInit, signal } from '@angular/core';
import { AuthService } from './auth.service';

interface Lookup { id:number; label:string; code?:string; hidden:boolean }
interface Context { semesterId:number|null; semesterName:string|null; writesEnabled:boolean; message:string|null }
interface Offering { id:number; courseId:number|null; semesterId:number|null; departmentId:number|null; courseName:string|null; courseCode:string|null; departmentName:string|null; active:boolean; sectionCount:number; enrollmentCount:number; version:string|null; warning:string|null }
interface Section { id:number; parentId:number|null; typeId:number|null; typeName:string|null; code:string|null; capacity:number|null; active:boolean; enrollmentCount:number; hasSchedule:boolean; version:string|null }
interface Detail { offering:Offering; sections:Section[] }
interface Issue { sectionId:number; sectionCode:string|null; courseName:string|null; kind:string }
interface Lookups { semesters:Lookup[]; departments:Lookup[]; courses:Lookup[]; sectionTypes:Lookup[] }

@Component({ selector:'sis-offering', imports:[], templateUrl:'./offering.component.html', styleUrl:'./offering.component.css' })
export class OfferingComponent implements OnInit {
  auth=inject(AuthService);
  context=signal<Context|null>(null); lookups=signal<Lookups|null>(null);
  rows=signal<Offering[]>([]); total=signal(0); detail=signal<Detail|null>(null); issues=signal<Issue[]>([]);
  busy=signal(false); saving=signal(false); error=signal(''); success=signal('');
  view=signal<'list'|'new'|'detail'|'edit'>('list');
  term:number|null=null; department:number|null=null; query=''; state='all'; missing=false; page=1;
  courseId:number|null=null; departmentId:number|null=null;
  sectionForm:{kind:'lecture'|'child'|'edit'|null;parentId:number|null;typeId:number;capacity:number;sectionId:number|null}={kind:null,parentId:null,typeId:1,capacity:40,sectionId:null};
  get manager(){return this.auth.roles().includes('Offering.Manager')||this.auth.roles().includes('Offering.Administrator')}
  get administrator(){return this.auth.roles().includes('Offering.Administrator')}
  get writable(){return !!this.context()?.writesEnabled&&this.term===this.context()?.semesterId&&this.manager}
  get pages(){return Math.max(1,Math.ceil(this.total()/25))}
  get lectures(){return this.detail()?.sections.filter(s=>s.parentId===s.id||s.typeId===1)??[]}
  children(parent:Section){return this.detail()?.sections.filter(s=>s.parentId===parent.id&&s.id!==parent.id)??[]}
  private message(e:unknown){return e instanceof Error?e.message:'تعذر إكمال العملية.'}
  private clear(){this.error.set('');this.success.set('')}
  async ngOnInit(){this.busy.set(true);try{const [context,lookups]=await Promise.all([this.auth.api<Context>('/offering/context'),this.auth.api<Lookups>('/offering/lookups')]);this.context.set(context);this.lookups.set(lookups);this.term=context.semesterId;await this.search()}catch(e){this.error.set(this.message(e))}finally{this.busy.set(false)}}
  async search(reset=false){if(reset)this.page=1;this.clear();this.busy.set(true);try{const result=await this.auth.api<{rows:Offering[];total:number}>('/offering/search',{method:'POST',body:JSON.stringify({semesterId:this.term,departmentId:this.department,query:this.query,state:this.state,missingSections:this.missing,page:this.page})});this.rows.set(result.rows);this.total.set(result.total);this.issues.set(this.term ? await this.auth.api<Issue[]>(`/offering/review/${this.term}`) : [])}catch(e){this.error.set(this.message(e))}finally{this.busy.set(false)}}
  async open(id:number){this.clear();this.busy.set(true);try{this.detail.set(await this.auth.api<Detail>(`/offering/${id}`));this.view.set('detail');this.sectionForm.kind=null}catch(e){this.error.set(this.message(e))}finally{this.busy.set(false)}}
  back(){this.view.set('list');this.detail.set(null);this.sectionForm.kind=null;void this.search()}
  create(){this.clear();this.courseId=null;this.departmentId=null;this.view.set('new')}
  edit(){const o=this.detail()?.offering;if(!o)return;this.courseId=o.courseId;this.departmentId=o.departmentId;this.view.set('edit');this.clear()}
  async saveOffering(){if(!this.courseId||!this.departmentId){this.error.set('اختر المقرر والقسم.');return}const editing=this.view()==='edit',o=this.detail()?.offering;this.clear();this.saving.set(true);try{const result=await this.auth.api<{id:number}>(editing?`/offering/${o!.id}`:'/offering/',{method:editing?'PUT':'POST',body:JSON.stringify({courseId:this.courseId,departmentId:this.departmentId,version:editing?o?.version:null})});await this.open(result.id);this.success.set(editing?'تم تحديث الطرح.':'تم إنشاء الطرح. أضف محاضرة الآن.')}catch(e){this.error.set(this.message(e))}finally{this.saving.set(false)}}
  newLecture(){this.sectionForm={kind:'lecture',parentId:null,typeId:1,capacity:40,sectionId:null};this.clear()}
  newChild(parent:Section){this.sectionForm={kind:'child',parentId:parent.id,typeId:3,capacity:40,sectionId:null};this.clear()}
  editSection(s:Section){this.sectionForm={kind:'edit',parentId:s.parentId===s.id?null:s.parentId,typeId:s.typeId??1,capacity:s.capacity??40,sectionId:s.id};this.clear()}
  async saveSection(){const o=this.detail()?.offering;if(!o)return;if(!Number.isInteger(this.sectionForm.capacity)||this.sectionForm.capacity<1||this.sectionForm.capacity>10000){this.error.set('أدخل سعة بين 1 و 10000.');return}const editing=this.sectionForm.kind==='edit',old=this.detail()?.sections.find(s=>s.id===this.sectionForm.sectionId);this.clear();this.saving.set(true);try{await this.auth.api(editing?`/offering/sections/${old!.id}`:`/offering/${o.id}/sections`,{method:editing?'PUT':'POST',body:JSON.stringify({parentId:this.sectionForm.parentId,sectionTypeId:this.sectionForm.typeId,capacity:this.sectionForm.capacity,version:editing?old?.version:null})});await this.open(o.id);this.success.set(editing?'تم تحديث السعة.':'تم إنشاء الشعبة بكودها الجديد.')}catch(e){this.error.set(this.message(e))}finally{this.saving.set(false)}}
  async deactivateSection(s:Section){if(!confirm(`إيقاف الشعبة ${s.code??s.id}؟`))return;const o=this.detail()?.offering;if(!o)return;this.clear();this.saving.set(true);try{await this.auth.api(`/offering/sections/${s.id}/deactivate`,{method:'POST',body:JSON.stringify({version:s.version})});await this.open(o.id);this.success.set('تم إيقاف الشعبة.')}catch(e){this.error.set(this.message(e))}finally{this.saving.set(false)}}
  async deactivateOffering(){const o=this.detail()?.offering;if(!o||!confirm(`إيقاف طرح ${o.courseName??o.id}؟`))return;this.clear();this.saving.set(true);try{await this.auth.api(`/offering/${o.id}/deactivate`,{method:'POST',body:JSON.stringify({version:o.version})});await this.open(o.id);this.success.set('تم إيقاف الطرح.')}catch(e){this.error.set(this.message(e))}finally{this.saving.set(false)}}
}
