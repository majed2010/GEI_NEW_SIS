import { Component, input } from '@angular/core';
const paths: Record<string, string> = {
  grid: 'M3 3h7v7H3z M14 3h7v7h-7z M3 14h7v7H3z M14 14h7v7h-7z',
  people: 'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2 M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8 M22 21v-2a4 4 0 0 0-3-3.87 M16 3.13a4 4 0 0 1 0 7.75',
  file: 'M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z M14 2v6h6 M8 13h8 M8 17h5',
  book: 'M12 6c-3-3-7-3-10-2v15c4-1 7-1 10 2 3-3 6-3 10-2V4c-3-1-7-1-10 2z M12 6v15',
  layers: 'M12 3 2 8l10 5 10-5z M2 12l10 5 10-5 M2 16l10 5 10-5',
  calendar: 'M5 4h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z M16 2v4 M8 2v4 M3 10h18 M8 14h2 M14 14h2 M8 18h2',
  chart: 'M4 3v18h17 M9 16v-5 M14 16V7 M19 16v-8',
  shield: 'M12 2 3 6v6c0 5 9 10 9 10s9-5 9-10V6z M8 12l3 3 5-6',
  arrow: 'M19 12H5 M11 6l-6 6 6 6',
  chevron: 'm14 7-5 5 5 5',
  search: 'M21 21l-5-5 M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16',
  bell: 'M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9 M10 21h4',
  help: 'M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20 M9.1 9a3 3 0 0 1 5.8 1c0 2-3 3-3 3 M12 17h.01',
  logout: 'M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4 M16 17l5-5-5-5 M21 12H9',
  clock: 'M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20 M12 6v6l4 2',
  check: 'm5 12 4 4L19 6', plus: 'M12 5v14 M5 12h14',
  cap: 'm2 9 10-5 10 5-10 5z M6 11v6c4 3 8 3 12 0v-6 M22 9v7',
  settings: 'M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8 M9 2h6l1 3 3 1 3 4-2 3v4l-4 2-1 3H9l-1-3-4-2v-4L2 10l3-4 3-1z',
  close: 'm6 6 12 12 M18 6 6 18', menu: 'M3 6h18 M3 12h18 M3 18h18',
  globe: 'M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20 M2 12h20 M12 2c6 6 6 14 0 20-6-6-6-14 0-20'
};
@Component({ selector: 'sis-icon', template: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.65" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path [attr.d]="path()" /></svg>', styles: [':host{display:inline-flex;width:22px;height:22px;flex-shrink:0}svg{width:100%;height:100%}'] })
export class IconComponent { name = input('grid'); path() { return paths[this.name()] || paths['grid']; } }
