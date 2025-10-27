import consumer from "./consumer"

consumer.subscriptions.create("RoomsListChannel", {
  connected() {
    console.log("✅ RoomsListChannel connected")
  },

  received(data) {
    console.log("📩 一覧更新:", data)

    const roomElement = document.querySelector(`#room-${data.room_id}`)
    if (!roomElement) return

    const messageEl = roomElement.querySelector(".new-message")
    if (messageEl) {
      if (data.last_message && data.last_message.trim() !== "") {
        messageEl.textContent = data.last_message
      } else if (data.has_images) {
        messageEl.textContent = "画像が送信されました"
      }
    }
    let badgeEl = roomElement.querySelector(".unread-badge")
    if (data.unread_count > 0){
      if (!badgeEl){
        badgeEl = document.createElement("span")
        badgeEl.className = "unread-badge badge badge-md badge-secondary"
        const parentDiv = roomElement.querySelector(".flex.justify-between.items-center:last-child")
        parentDiv.appendChild(badgeEl)
      }
      badgeEl.textContent = data.unread_count
    }else if (badgeEl){
      badgeEl.remove()
    }

    const timeEl = roomElement.querySelector("time")
    if (timeEl) timeEl.textContent = data.latest_time
  }
});
