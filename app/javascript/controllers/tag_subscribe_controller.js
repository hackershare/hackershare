import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "container" ]

  toggle(event) {
    const [_data, _status, xhr] = event.detail
    this.containerTarget.innerHTML = xhr.response
  }
}
