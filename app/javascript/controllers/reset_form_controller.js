import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset(e) {
    if (e.detail.success) {
      this.element.reset() // formをリセット
      const previewTarget = this.element.querySelector("[data-preview-target='images']")
      if (previewTarget) {
        previewTarget.innerHTML = ""
      }
    }
  }
}