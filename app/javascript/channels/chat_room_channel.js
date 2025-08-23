import consumer from "./consumer"

// DOM読み込み完了を待つ
document.addEventListener('turbo:load', function() {
  // DOM読み込み完了、ActionCable初期化開始
  
  const messagesElement = document.getElementById("messages")
  const roomId = messagesElement?.dataset?.roomId

  // ページ読み込み時に最下部にスクロール
  if (messagesElement && messagesElement.children.length > 0) {
    scrollToBottom(messagesElement)
  }
  if (roomId) {
    const subscription = consumer.subscriptions.create(
      { channel: "ChatRoomChannel", chat_room_id: roomId },
      {
        connected() {
          console.log("✅ チャットルーム${roomId}に接続しました")
          scrollToBottom(messagesElement)
        },
        disconnected() {
          console.log("❌ チャットルーム${roomId}から切断されました")
          
          const statusDiv = document.getElementById('connection-status')
          if (statusDiv) {
            statusDiv.style.background = 'red'
            statusDiv.textContent = '切断中'
          }
        },
        received(data) {
          try {
            console.log("📨 データ受信:", data)
            
            if (!data || !data.message) {
              console.warn("⚠️ 無効なデータを受信しました:", data)
              return
            }
            const currentUserId = messagesElement.dataset.currentUserId
            let wrapper = document.createElement("div")
            wrapper.innerHTML = data.message
            if (data.sender_id && currentUserId){
              if (data.sender_id.toString() === currentUserId.toString()){
                wrapper.firstElementChild.classList.add("message-right")
              }else{
                wrapper.firstElementChild.classList.add("message-left")
              }
            }
            messagesElement.appendChild(wrapper.firstElementChild)
            scrollToBottom(messages)          
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