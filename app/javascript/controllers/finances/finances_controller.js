import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="finances"
export default class extends Controller {
  static targets = [ "back", "new", "save", "accounts", "account" ]
  static classes = [ "hidden" ]

  connect() {}

  displayAccount() {
    this.accountsTarget.classList.toggle(this.hiddenClass, true)
    this.newTarget.classList.toggle(this.hiddenClass, true)

    this.accountTarget.classList.toggle(this.hiddenClass, false)
    this.backTarget.classList.toggle(this.hiddenClass, false)
    this.saveTarget.classList.toggle(this.hiddenClass, false)
  }

  hideAccount() {
    this.accountTarget.classList.toggle(this.hiddenClass, true)
    this.backTarget.classList.toggle(this.hiddenClass, true)
    this.saveTarget.classList.toggle(this.hiddenClass, true)

    this.accountsTarget.classList.toggle(this.hiddenClass, false)
    this.newTarget.classList.toggle(this.hiddenClass, false)
  }

  disconnect() {}
}
