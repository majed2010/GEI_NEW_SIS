import { bootstrapApplication } from '@angular/platform-browser';
import { Component, inject, provideAppInitializer } from '@angular/core';
import { provideRouter, RouterOutlet, Routes } from '@angular/router';
import { AuthService, staffGuard, previewGuard } from './app/auth.service';
import { LoginComponent } from './app/login.component';
import { WorkspaceComponent } from './app/workspace.component';

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'preview', component: WorkspaceComponent, canActivate: [previewGuard], data: { preview: true } },
  { path: 'preview/:module', component: WorkspaceComponent, canActivate: [previewGuard], data: { preview: true } },
  { path: 'workspace', component: WorkspaceComponent, canActivate: [staffGuard] },
  { path: 'workspace/:module', component: WorkspaceComponent, canActivate: [staffGuard] },
  { path: '**', redirectTo: 'login' }
];
@Component({ selector: 'app-root', imports: [RouterOutlet], template: '<router-outlet />' })
class AppComponent {}
bootstrapApplication(AppComponent, { providers: [provideRouter(routes), provideAppInitializer(() => inject(AuthService).initialize())] }).catch(console.error);
