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
            messagesElement.insertAdjacentHTML("beforeend", data.message)
            messagesElement.scrollTop = messagesElement.scrollHeight          
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