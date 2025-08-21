import consumer from "./consumer"

const messagesElement = document.getElementById("messages")
const roomId = messagesElement?.dataset?.roomId

if (roomId) {
  const subscription = consumer.subscriptions.create(
    { channel: "ChatRoomChannel", chat_room_id: roomId },
    {
      connected() {
        console.log(`✅ チャットルーム${roomId}に接続しました`)
      },

      disconnected() {
        console.log(`❌ チャットルーム${roomId}から切断されました`)
      },

      received(data) {
        try {
          console.log(`📨 データ受信:`, data)
          
          // データの妥当性チェック
          if (!data || !data.message) {
            console.warn("⚠️ 無効なデータを受信しました:", data)
            return
          }

          messagesElement.insertAdjacentHTML("beforeend", data.message)
          messagesElement.scrollTop = messagesElement.scrollHeight
          
          console.log(`✅ メッセージをDOMに追加完了`)
        } catch (error) {
          console.error("❌ メッセージ表示エラー:", error)
        }
      },

      // 接続エラー時の処理
      rejected() {
        console.error("❌ チャンネル接続が拒否されました")
        alert("チャットに接続できませんでした。ページを再読み込みしてください。")
      }
    }
  )
}
