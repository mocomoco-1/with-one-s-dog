import consumer from "./consumer"

// DOM読み込み完了を待つ
document.addEventListener('turbo:load', function() {
  const messagesElement = document.getElementById("messages")
  const roomId = messagesElement?.dataset?.roomId
  const currentUserId = messagesElement?.dataset?.currentUserId

  // ページ読み込み時に最下部にスクロール
  if (messagesElement && messagesElement.children.length > 0) {
    scrollToBottom(messagesElement)
  }
  if (roomId) {
    const subscription = consumer.subscriptions.create(
      { channel: "ChatRoomChannel", chat_room_id: roomId },
      {
        connected() {
          console.log("✅ チャットルームに接続しました")
          messagesElement.querySelectorAll("[data-sender-id]").forEach((msg) => {
          const senderId = msg.dataset.senderId
          if (senderId && currentUserId) {
            if (senderId.toString() === currentUserId.toString()) {
              msg.classList.add("justify-end")
              msg.querySelector(".message-bubble").classList.add("bg-base-200")
            } else {
              msg.classList.add("justify-start")
              msg.querySelector(".message-bubble").classList.add("bg-accent")
            }
          }
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
            const wrapper = document.createElement("div")
            wrapper.innerHTML = data.message
            const messageDiv = wrapper.firstElementChild

            if (data.sender_id && currentUserId){
              if (data.sender_id.toString() === currentUserId.toString()){
                messageDiv.classList.add("justify-end")  // 右寄せ
                messageDiv.querySelector(".message-bubble").classList.add("bg-base-200")
              }else{
                messageDiv.classList.add("justify-start") // 左寄せ
                messageDiv.querySelector(".message-bubble").classList.add("bg-accent")
              }
            }
            messagesElement.appendChild(messageDiv)
            scrollToBottom(messagesElement)          
            console.log("✅ メッセージをDOMに追加完了")
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
  } else {
    console.error("❌ roomIdが見つかりません")
  }
  // スクロール処理を関数化
  function scrollToBottom(element) {
    element.scrollTop = element.scrollHeight
  }
})