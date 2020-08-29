// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("alpinejs")
require("@rails/activestorage").start()
require("channels")
require("timeago.js")
import { createPopper } from '@popperjs/core';
import { format, render, cancel, register } from 'timeago.js';


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "controllers"
require("css/application.scss")

document.addEventListener("turbolinks:load", function() {
    const timeagos = document.querySelectorAll('.timeago');
    const locale = document.querySelector('[data-locale]').getAttribute('data-locale')
    if (timeagos.length > 0){
      render(timeagos, locale);
    }   
});


window.onpopstate = function(event) {
  document.location.reload();
};
