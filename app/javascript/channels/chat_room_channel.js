import consumer from "./consumer"

// DOM読み込み完了を待つ
document.addEventListener('turbo:load', initChat)

function initChat() {
  const messagesElement = document.getElementById("messages")
  const roomId = messagesElement?.dataset?.roomId
  const currentUserId = messagesElement?.dataset?.currentUserId
  if (!roomId) return

  consumer.subscriptions.subscriptions.forEach((sub) => {
    if (sub.identifier.includes(`"chat_room_id":"${roomId}"`)) {
      consumer.subscriptions.remove(sub)
      console.log("♻️ 既存サブスクリプションを削除しました")
    }
  })

  // ページ読み込み時に最下部にスクロール
  if (messagesElement.children.length > 0) {
    scrollToBottom(messagesElement)
    applyMessageAlignment(messagesElement, currentUserId)
  }
  consumer.subscriptions.create(
    { channel: "ChatRoomChannel", chat_room_id: roomId },
    {
      connected() {
        console.log("✅ チャットルームに接続しました")
        messagesElement.querySelectorAll("[data-sender-id]").forEach((msg) => {
          applyAlignment(msg,msg.dataset.senderId, currentUserId)
        })
        scrollToBottom(messagesElement)
      },
      disconnected() {
        console.log("❌ チャットルームから切断されました")
        const statusDiv = document.getElementById('connection-status')
        if (statusDiv) {
          statusDiv.style.background = 'red'
          statusDiv.textContent = '切断中'
        }
      },
      received(data) {
        try {
          if (!data || !data.message) return
          // ブロードキャストされたHTMLをDOMに追加
          const wrapper = document.createElement("div")
          wrapper.innerHTML = data.message
          const messageDiv = wrapper.firstElementChild
          applyAlignment(messageDiv, data.sender_id, currentUserId)
          messagesElement.appendChild(messageDiv)
          scrollToBottom(messagesElement)          
          console.log("✅ メッセージDOMに追加完了")
        } catch (error) {
          console.error("❌ メッセージ表示エラー:", error)
        }
      },
      rejected() {
        console.error("❌ チャンネル接続が拒否されました")
        alert("チャットに接続できませんでした。ページを再読み込みしてください。")
      }
    }
  )
    console.error("❌ roomIdが見つかりません")
  // スクロール処理を関数化
  function scrollToBottom(element) {
    element.scrollTop = element.scrollHeight
  }
  // 左右分けの処理を関数化
  function applyAlignment(messageDiv, senderId, currentUserId) {
    if (!messageDiv || !senderId || !currentUserId) return

    if (senderId.toString() === currentUserId.toString()) {
      messageDiv.classList.add("justify-end")
      messageDiv.querySelector(".message-bubble")?.classList.add("bg-base-200")
    } else {
      messageDiv.classList.add("justify-start")
      messageDiv.querySelector(".message-bubble")?.classList.add("bg-accent")
    }
  }
  // 既存メッセージ全体に左右・色分けを適用
  function applyMessageAlignment(messagesElement, currentUserId) {
    messagesElement.querySelectorAll("[data-sender-id]").forEach((msg) => {
      applyAlignment(msg, msg.dataset.senderId, currentUserId)
    })
  }
}
