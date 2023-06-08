import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event"
export default class extends Controller {
  connect() {
    console.log("You are connected!")
    //this.getToken()
  }
}
