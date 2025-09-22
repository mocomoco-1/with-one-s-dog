import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Turboフォーム送信後のイベントを監視
    this.element.addEventListener("turbo:submit-end", (event) => {
      // 送信成功時に自動スクロール
      if (event.detail.success) {
        this.scrollToBottom()
      }
    })
  }

  scrollToBottom() {
    // ページ下部までスムーズにスクロール
    window.scrollTo({ top: document.body.scrollHeight, behavior: "smooth" })
  }
}