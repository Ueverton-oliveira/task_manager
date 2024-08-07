import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ["modal"]
  static targets = ["modal", "frame"]

  connect() {
    this.modalTarget.addEventListener("close", this.enableBodyScroll.bind(this))
  }

  disconnect() {
    this.modalTarget.removeEventListener("close", this.enableBodyScroll.bind(this))
  }

  open() {
    this.modalTarget.showModal()
    document.body.classList.add('overflow-hidden')
  }

 submitEnd(e) {
   if (e.detail.success) {
     this.close()
   }
 }

  close() {
    this.modalTarget.close()
    // clean up the frame
    this.frameTarget.removeAttribute("src")
    this.frameTarget.innerHTML = ""
  }

  enableBodyScroll() {
    document.body.classList.remove('overflow-hidden')
  }

  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }
}