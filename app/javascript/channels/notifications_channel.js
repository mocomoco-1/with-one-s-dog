import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("通知チャネル接続")
  },

  disconnected() {
    console.log("通知チャネル切断")
  },

  received(data) {
    console.log("📩 新しい通知を受信:", data)
    const notificationHTML = data.notification
    const list = document.getElementById("full_list")
    if (list) {
      list.insertAdjacentHTML("afterbegin", notificationHTML)
      updateNotificationCount()
    }else{
      console.warn("⚠️ 通知リスト（#full_list）が見つかりませんでした。")
    }
  //   if (data.unread_count !== undefined){
  //     const countElement = document.getElementById("count")
  //     if(countElement) {
  //       countElement.textContent = data.unread_count
  //     }
  //   }else {
  //     updateNotificationCount()
  //   }
  }
})
function updateNotificationCount() {
  const countElement = document.getElementById("count")
  if (!countElement) return
  const currentCount = parseInt(countElement.textContent) || 0
  countElement.textContent = currentCount + 1
}

