import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {
    this.element.dataset.action = "modal#show";
  }

  show(event) {
    // ...
  }
}
