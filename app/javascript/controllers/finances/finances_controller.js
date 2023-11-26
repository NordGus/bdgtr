import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="finances"
export default class extends Controller {
  connect() {
    console.log("hello world")
  }

  disconnect() {
  }
}
