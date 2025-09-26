import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  markAsRead(event) {
    console.log("=== markAsRead called ===")
    const updateUrl = event.currentTarget.dataset.updateUrl
    console.log("Update URL:", updateUrl)
    fetch(updateUrl,{
      method: "PATCH",
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content
      }
    })
  }
}
