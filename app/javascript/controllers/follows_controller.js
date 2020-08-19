import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "data", "button" ]

  connect() {
  }

  toggle(event){
    let [data, status, xhr] = event.detail;
    if (typeof(data) === 'string') {
      return;
    }
    if (data["follow"]) {
      this.buttonTarget.classList.remove("bg-indigo-600");
      this.buttonTarget.classList.remove("hover:bg-indigo-500");
      this.buttonTarget.classList.remove("focus:border-indigo-700");
      this.buttonTarget.classList.remove("focus:shadow-outline-indigo");
      this.buttonTarget.classList.remove("active:bg-indigo-700");
      
      this.buttonTarget.classList.add("bg-gray-600");
      this.buttonTarget.classList.add("hover:bg-gray-500");
      this.buttonTarget.classList.add("focus:border-gray-700");
      this.buttonTarget.classList.add("focus:shadow-outline-gray");
      this.buttonTarget.classList.add("active:bg-gray-700");

      this.buttonTarget.innerHTML = "Unfollow"
    } else {
      this.buttonTarget.classList.remove("bg-gray-600");
      this.buttonTarget.classList.remove("hover:bg-gray-500");
      this.buttonTarget.classList.remove("focus:border-gray-700");
      this.buttonTarget.classList.remove("focus:shadow-outline-gray");
      this.buttonTarget.classList.remove("active:bg-gray-700");

      this.buttonTarget.classList.add("bg-indigo-600");
      this.buttonTarget.classList.add("hover:bg-indigo-500");
      this.buttonTarget.classList.add("focus:border-indigo-700");
      this.buttonTarget.classList.add("focus:shadow-outline-indigo");
      this.buttonTarget.classList.add("active:bg-indigo-700");

      this.buttonTarget.innerHTML = "Follow";
    }
  }
}