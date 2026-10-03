import { AfterViewInit, Directive, ElementRef, OnDestroy, inject } from '@angular/core';

// Native modal dialogs provide keyboard focus containment and restore focus on close.
@Directive({ selector: 'dialog[sisModal]' })
export class ModalDirective implements AfterViewInit, OnDestroy {
  private element = inject<ElementRef<HTMLDialogElement>>(ElementRef);
  ngAfterViewInit(): void { this.element.nativeElement.showModal(); }
  ngOnDestroy(): void { this.element.nativeElement.close(); }
}
