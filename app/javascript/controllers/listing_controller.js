import { Controller } from 'stimulus';
import { format, render, cancel, register } from 'timeago.js';

import smoothscroll from 'smoothscroll-polyfill';
smoothscroll.polyfill();

export default class extends Controller {
  static targets = ["container"];

  replace(event){
    let [data, status, xhr] = event.detail;
    this.containerTarget.innerHTML = xhr.response;
    const timeagos = document.querySelectorAll('.timeago');
    const lang = I18n.locale == 'zh-CN' ? 'zh_CN' : 'en_US'
    if (timeagos.length > 0){
      render(timeagos, lang);
    }
    window.history.pushState(null, null, event.target.getAttribute("href"));
    // For alpinejs's dropdown in dynamic element
    // https://github.com/alpinejs/alpine/issues/282
    Alpine.discoverUninitializedComponents(function(el) { Alpine.initializeComponent(el) })
    this.containerTarget.scrollIntoView({ behavior: 'smooth' });
  }
}
