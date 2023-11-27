import { Controller } from "@hotwired/stimulus"

const HIDDEN_CSS_CLASS = "hidden"

// Connects to data-controller="finances--account-saved"
export default class extends Controller {
  connect() {
    this.dispatch("success", { cancelable: false })
  }
}
