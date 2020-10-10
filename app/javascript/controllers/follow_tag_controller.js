import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ["container"];

  toggle(event){
    let [data, status, xhr] = event.detail;
    if (RegExp('^Turbolinks').test(xhr.response)){
      return
    }
    this.containerTarget.innerHTML = xhr.response;
  }
}