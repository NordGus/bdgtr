import { Controller } from "@hotwired/stimulus"

const HIDDEN_CSS_CLASS = "hidden"

// Connects to data-controller="finances"
export default class extends Controller {
  static targets = [ "back", "new", "save", "accounts", "account" ]

  connect() {}

  displayAccount() {
    this.accountsTarget.classList.toggle(HIDDEN_CSS_CLASS, true)
    this.newTarget.classList.toggle(HIDDEN_CSS_CLASS, true)

    this.accountTarget.classList.toggle(HIDDEN_CSS_CLASS, false)
    this.backTarget.classList.toggle(HIDDEN_CSS_CLASS, false)
    this.saveTarget.classList.toggle(HIDDEN_CSS_CLASS, false)
  }

  hideAccount() {
    this.accountTarget.classList.toggle(HIDDEN_CSS_CLASS, true)
    this.backTarget.classList.toggle(HIDDEN_CSS_CLASS, true)
    this.saveTarget.classList.toggle(HIDDEN_CSS_CLASS, true)

    this.accountsTarget.classList.toggle(HIDDEN_CSS_CLASS, false)
    this.newTarget.classList.toggle(HIDDEN_CSS_CLASS, false)
  }

  saveAccount() {
    this.accountTarget.querySelector(`form input[type="submit"]`).click()
  }

  disconnect() {}
}
