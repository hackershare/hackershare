import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ["container"];

  connect() {
    if (!localStorage.getItem('extension-banner-dismiss')) {
      this.containerTarget.classList.remove('hidden')
    }
  }

  dismiss() {
    localStorage.setItem('extension-banner-dismiss', true)
    this.containerTarget.classList.add('hidden')
  }
}
