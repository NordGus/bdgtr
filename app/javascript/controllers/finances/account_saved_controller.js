import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="finances--account-saved"
export default class extends Controller {
  connect() {
    this.dispatch("success", { cancelable: false })
  }
}
