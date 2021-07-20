// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import "alpinejs";
import "./live";
import { ready } from "./utils";

var bloop;

function togglePasswordFieldVisibility() {
  const passwordFields = document.querySelectorAll('[name="user[password]"]');
  passwordFields.forEach((el) => {
    if (el.type == "password") {
      el.type = "text";
    } else {
      el.type = "password";
    }
  });
}

const toggleSidebar = (event) => {
  document.querySelectorAll(".sidebar").forEach((el) => {
    el.classList.toggle("visible");
  });
};

ready(() => {
  (document.getElementById("nav-toggle") || {}).onclick = function () {
    document.getElementById("nav-content").classList.toggle("hidden");
  };

  document.querySelectorAll(".js-passwordRevealer").forEach((el) => {
    el.addEventListener("click", togglePasswordFieldVisibility);
  });

  document.querySelectorAll(".js-SidebarOpener").forEach((el) => {
    el.addEventListener("click", toggleSidebar);
  });

  document.querySelectorAll(".js-flash-closer").forEach((el) => {
    el.addEventListener("click", () => {
      el.closest(".js-flash").remove();
    });
  });
});
