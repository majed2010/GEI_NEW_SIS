import { Component, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { AuthService } from './auth.service';
import { IconComponent } from './icon.component';
@Component({ selector: 'sis-login', imports: [RouterLink, IconComponent], templateUrl: './login.component.html' })
export class LoginComponent { auth = inject(AuthService); }
