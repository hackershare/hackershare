import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "container" ]

  close(){
    const element = this.containerTarget;
    element.setAttribute("style", "display:none");
  }
}