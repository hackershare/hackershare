import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ["container"];

  append(event){
    let [data, status, xhr] = event.detail;
    this.containerTarget.innerHTML =  xhr.response;
  }
}