import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["card"];

  show() {
    let url = this.element.getAttribute("data-hover-like-users-url-value");
    if (this.hasCardTarget) {
      this.cardTarget.classList.remove("hidden");
    } else {
      fetch(url)
        .then((r) => r.text())
        .then((html) => {
          const fragment = document
            .createRange()
            .createContextualFragment(html);

          this.element.appendChild(fragment);
        });
    }
  }

  hide() {
    if (this.hasCardTarget) {
      this.cardTarget.classList.add("hidden");
    }
  }

  disconnect() {
    if (this.hasCardTarget) {
      this.cardTarget.remove();
    }
  }
}
