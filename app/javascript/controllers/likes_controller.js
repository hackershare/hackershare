import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "data", "svg" ]

  connect() {
  }

  toggle(event){
    let [data, status, xhr] = event.detail;
    if (typeof(data) === 'string') {
      return;
    }
    if (data["like"]) {
      this.svgTarget.classList.remove("text-gray-300");
      this.svgTarget.classList.remove("hover:text-gray-400");
      this.svgTarget.classList.add("text-yellow-300");
      this.svgTarget.classList.add("hover:text-yellow-400");
    } else {
      this.svgTarget.classList.remove("text-yellow-300");
      this.svgTarget.classList.remove("hover:text-yellow-400");
      this.svgTarget.classList.add("text-gray-300");
      this.svgTarget.classList.add("hover:text-gray-400");
    }
    this.dataTarget.innerHTML = data["bookmark"]["likes_count"];
  }
}