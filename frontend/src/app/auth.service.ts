import { Injectable, inject, signal } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { PublicClientApplication, InteractionRequiredAuthError } from '@azure/msal-browser';

interface AppConfig { tenantId: string; clientId: string; apiScope: string; redirectUri: string; apiBaseUrl: string; enablePreview: boolean; }
export class ApiError extends Error {
  constructor(message: string, readonly fields: Record<string,string> = {}) { super(message); }
}
@Injectable({ providedIn: 'root' })
export class AuthService {
  readonly configured = signal(false);
  readonly previewEnabled = signal(false);
  readonly busy = signal(false);
  readonly error = signal('');
  readonly name = signal('');
  readonly roles = signal<string[]>([]);
  private config?: AppConfig;
  private msal?: PublicClientApplication;
  async initialize(): Promise<void> {
    try {
      const response = await fetch('/app-config.json', { cache: 'no-store' });
      if (!response.ok) throw new Error('config');
      this.config = await response.json() as AppConfig;
      this.previewEnabled.set(this.config.enablePreview === true);
      if (!this.config.tenantId || !this.config.clientId || !this.config.apiScope) return;
      this.msal = new PublicClientApplication({ auth: { clientId: this.config.clientId, authority: `https://login.microsoftonline.com/${this.config.tenantId}`, redirectUri: this.config.redirectUri, postLogoutRedirectUri: this.config.redirectUri, navigateToLoginRequestUrl: false }, cache: { cacheLocation: 'sessionStorage' } });
      await this.msal.initialize();
      const result = await this.msal.handleRedirectPromise();
      if (result?.account) this.msal.setActiveAccount(result.account);
      this.configured.set(true);
      if (result?.account) location.replace('/workspace');
    } catch { this.error.set('تعذر تهيئة تسجيل الدخول. يرجى التواصل مع مسؤول النظام.'); }
  }
  async login(): Promise<void> {
    if (!this.msal || !this.configured() || !this.config) {
      this.error.set('تسجيل الدخول المؤسسي قيد الإعداد. يمكنك استكشاف الواجهة التجريبية الآن.'); return;
    }
    this.busy.set(true); this.error.set('');
    try { await this.msal.loginRedirect({ scopes: [this.config.apiScope], prompt: 'select_account' }); }
    catch { this.error.set('تعذر بدء تسجيل الدخول. يرجى المحاولة مرة أخرى.'); this.busy.set(false); }
  }
  async verifyStaff(): Promise<boolean> {
    if (!this.msal || !this.config) return false;
    const account = this.msal.getActiveAccount();
    if (!account) return false;
    try {
      const token = await this.msal.acquireTokenSilent({ account, scopes: [this.config.apiScope] });
      const response = await fetch(`${this.config.apiBaseUrl}/me`, { headers: { Authorization: `Bearer ${token.accessToken}` } });
      if (!response.ok) { this.error.set(response.status === 403 ? 'حسابك غير مُصرّح له بالدخول. تواصل مع مسؤول النظام لإسناد دور موظف النظام.' : 'تعذر التحقق من صلاحية الدخول. يرجى المحاولة لاحقاً.'); return false; }
      const profile = await response.json(); this.name.set(profile.name || 'زميلنا العزيز'); this.roles.set(profile.roles || []); return true;
    } catch (error) {
      if (error instanceof InteractionRequiredAuthError) {
        await this.msal.acquireTokenRedirect({ account, scopes: [this.config.apiScope] });
      } else this.error.set('تعذر الاتصال بالخادم للتحقق من صلاحية الدخول.');
      return false;
    }
  }
  async api<T>(path: string, init: RequestInit = {}): Promise<T> {
    if (!this.msal || !this.config) throw new Error('تسجيل الدخول المؤسسي غير مهيأ.');
    const account = this.msal.getActiveAccount();
    if (!account) throw new Error('يرجى تسجيل الدخول مرة أخرى.');
    let token;
    try { token = await this.msal.acquireTokenSilent({ account, scopes: [this.config.apiScope] }); }
    catch (error) {
      if (error instanceof InteractionRequiredAuthError) {
        await this.msal.acquireTokenRedirect({ account, scopes: [this.config.apiScope] });
      }
      throw new Error('تعذر تجديد جلسة الدخول.');
    }
    const headers = new Headers(init.headers);
    headers.set('Authorization', `Bearer ${token.accessToken}`);
    if (init.body && !headers.has('Content-Type')) headers.set('Content-Type', 'application/json');
    const response = await fetch(`${this.config.apiBaseUrl}${path}`, { ...init, headers, cache: 'no-store' });
    if (!response.ok) {
      const body = await response.json().catch(() => null);
      throw new ApiError(body?.message || `تعذر إكمال الطلب (${response.status}).`, body?.errors || {});
    }
    return response.status === 204 ? undefined as T : await response.json() as T;
  }
  async apiBlob(path: string): Promise<Blob | null> {
    if (!this.msal || !this.config) return null;
    const account = this.msal.getActiveAccount(); if (!account) return null;
    const token = await this.msal.acquireTokenSilent({ account, scopes: [this.config.apiScope] });
    const response = await fetch(`${this.config.apiBaseUrl}${path}`, {
      headers: { Authorization: `Bearer ${token.accessToken}` }, cache: 'no-store'
    });
    if (response.status === 204) return null;
    if (!response.ok) throw new Error('تعذر تحميل صورة الطالب.');
    return response.blob();
  }
  async logout(): Promise<void> {
    if (this.msal?.getActiveAccount()) await this.msal.logoutRedirect();
    else location.assign('/login');
  }
}
export const staffGuard: CanActivateFn = async () => {
  const auth = inject(AuthService); const router = inject(Router);
  return await auth.verifyStaff() || router.createUrlTree(['/login']);
};
export const previewGuard: CanActivateFn = () => inject(AuthService).previewEnabled() || inject(Router).createUrlTree(['/login']);
