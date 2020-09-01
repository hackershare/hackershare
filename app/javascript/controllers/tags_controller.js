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
    new Tagify(this.outputTarget);
  }
}
