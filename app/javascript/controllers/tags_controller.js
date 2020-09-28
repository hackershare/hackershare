// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>
// document.querySelector("#hello-target").textContent = "aaa";

import { Controller } from "stimulus"
import Tagify from '@yaireo/tagify';

export default class extends Controller {
  static targets = [ "output" ]
  
  connect() {
    let whitelist = this.outputTarget.dataset.whitelist.trim().split(/\s*,\s*/);
    new Tagify(
      this.outputTarget,

      {
        whitelist: whitelist,
        maxTags: 5,
        editTags: 1,
        autoComplete: { enabled: true },
        dropdown: {
          caseSensitive: true,
          maxItems: 20,           // <- mixumum allowed rendered suggestions
          classname: "tags-look", // <- custom classname for this dropdown, so it could be targeted
          enabled: 0,             // <- show suggestions on focus
          closeOnSelect: false    // <- do not hide the suggestions dropdown once an item has been selected
        }
      }
    );
  }
}
