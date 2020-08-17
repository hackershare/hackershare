import { Controller } from "stimulus";
import { createPopper } from '@popperjs/core';

export default class extends Controller {
  static targets = ["card", "avatar"];

  show() {
    let url = this.element.getAttribute("data-userhover-url-value");
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
          createPopper(this.avatarTarget, this.cardTarget, {
            placement: 'bottom-end',
          });
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
