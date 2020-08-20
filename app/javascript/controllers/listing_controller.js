import { Controller } from 'stimulus';
import { format, render, cancel, register } from 'timeago.js';

export default class extends Controller {
  static targets = ["container"];

  replace(event){
    let [data, status, xhr] = event.detail;
    this.containerTarget.innerHTML = xhr.response;
    const timeagos = document.querySelectorAll('.timeago');
    if (timeagos.length > 0){
      render(timeagos);
    }
    window.history.pushState(null, null, event.target.getAttribute("href"));
  }
}