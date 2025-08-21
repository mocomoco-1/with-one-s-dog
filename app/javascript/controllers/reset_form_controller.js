import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset(e) {
    if (e.detail.success) {
      this.element.reset() // formをリセット
    }
  }
}