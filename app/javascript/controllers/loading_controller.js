import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submitButton", "loadingIndicator", "form"]

  connect(){
  }

  submitStart(){
    this.submitButtonTarget.disabled = true
    this.submitButtonTarget.value = "考え中🐾🐾🐾"
    this.loadingIndicatorTarget.classList.remove("hidden")
  }

  submitEnd(){
    this.submitButtonTarget.disabled = false
    this.submitButtonTarget.value = "相談する"
    this.loadingIndicatorTarget.classList.add("hidden")
    if (this.hasFormTarget) {
      this.formTarget.classList.add("hidden"); // CSSで非表示に
    }
  }
}