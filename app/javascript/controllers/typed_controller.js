import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

// Connects to data-controller="typed"
export default class extends Controller {
  connect() {
    new Typed(this.element, {
      strings: ["quick", "start", "quickstart"],
      typeSpeed: 20,
      loop: true,
      showCursor: false,
    })
  }
}
