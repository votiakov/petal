import '../semantic/src/semantic.less';
// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

function ready(fn) {
  if (document.readyState != 'loading'){
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
}

function togglePasswordFieldVisibility()
{
  const passwordFields = document.querySelectorAll('[name="user[password]"]')
  passwordFields.forEach((el) => {
    if (el.type == 'password')
    {
      el.type = 'text'
    } 
    else
    {
      el.type = 'password'
    }
  })
}

ready(() => {
  document.querySelectorAll('.js-passwordRevealer').forEach((el) => {
    el.addEventListener('click', togglePasswordFieldVisibility)
  })
})
