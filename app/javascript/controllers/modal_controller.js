import { Controller } from "@hotwired/stimulus"

const HIDDEN_CSS_CLASS = "hidden"
const FLEX_CSS_CLASS = "flex"

// This controller needs to be set at the parent element of a application section.
//
// Triggers need to have data-action="event->modal#open" to open the modal or data-action="event->modal#close" to close
// it. `event` refers to any dom event you want to make the modal react to.
//
// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "modal" ]

  connect() {}

  open() {
    this.modalTarget.classList.toggle(HIDDEN_CSS_CLASS, false)
    this.modalTarget.classList.toggle(FLEX_CSS_CLASS, true)
  }

  close() {
    this.modalTarget.classList.toggle(FLEX_CSS_CLASS, false)
    this.modalTarget.classList.toggle(HIDDEN_CSS_CLASS, true)
  }

  disconnect() {}
}
