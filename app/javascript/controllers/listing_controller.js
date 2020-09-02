import { Controller } from 'stimulus';
import { format, render, cancel, register } from 'timeago.js';

export default class extends Controller {
  static targets = ["container"];

  replace(event){
    let [data, status, xhr] = event.detail;
    this.containerTarget.innerHTML = xhr.response;
    const timeagos = document.querySelectorAll('.timeago');
    const lang = I18n.locale == 'cn' ? 'zh_CN' : 'en_US'
    if (timeagos.length > 0){
      render(timeagos, lang);
    }
    window.history.pushState(null, null, event.target.getAttribute("href"));
  }
}