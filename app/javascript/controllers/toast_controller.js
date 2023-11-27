import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  static targets = [ "progress" ]

  connect() {
    setTimeout(() => {
      this.progressTarget.classList.remove("w-0")
      this.progressTarget.classList.add("w-full")
    }, 1)

    this.timeoutID = setTimeout(() => {
      this.clearTimeout = 0
      this.clear()
    }, 3000)
  }

  clear() {
    this.element.remove()
  }

  disconnect() {
    if (this.timeoutID) clearTimeout(this.timeoutID)
  }
}
