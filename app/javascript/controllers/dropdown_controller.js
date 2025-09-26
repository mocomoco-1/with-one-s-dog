import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"]
  connect(){
    document.addEventListener("click",this.close.bind(this))
  }
  disconnect(){
    document.removeEventListener("click",this.close.bind(this))
  }
  toggle(event) {
    event.stopPropagation()
      this.menuTarget.classList.toggle("hidden")
  }
  close(){
      this.menuTarget.classList.add("hidden")
  }
}