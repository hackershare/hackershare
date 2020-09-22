import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "element" ]

  show() {
    this.elementTarget.classList.remove('hidden')
  }

  hide() {
    this.elementTarget.classList.add('hidden')
  }
}
