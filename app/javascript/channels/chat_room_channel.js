import consumer from "./consumer"

// DOM読み込み完了を待つ
document.addEventListener('turbo:load', initChat)

function initChat() {
  const messagesElement = document.getElementById("messages")
  if (!messagesElement) return
  const roomId = messagesElement?.dataset?.roomId
  if (!roomId) return
  const currentUserId = messagesElement?.dataset?.currentUserId
  let myLastSentReadId = Number(messagesElement.dataset.lastReadMessageId) || 0
  let isRoomOpen = true // ルーム開閉フラグ
  let lastReadByUser = {} // ユーザーごとの last_read 管理
  document.addEventListener("turbo:before-visit", () => {
  console.log("🚪 チャットルームを退出しました")
    isRoomOpen = false
  })
  window.addEventListener("beforeunload", () => {
    isRoomOpen = false
  })

  // 既存サブスクリプション削除
  consumer.subscriptions.subscriptions.forEach((sub) => {
    if (sub.identifier.includes(`"chat_room_id":"${roomId}"`)) {
      consumer.subscriptions.remove(sub)
      console.log("♻️ 既存サブスクリプションを削除しました")
    }
  })

  // ページ読み込み時に最下部にスクロール,色分け
  if (messagesElement.children.length > 0) {
    scrollToBottom(messagesElement)
    applyMessageAlignment(messagesElement, currentUserId)
  }

  // サーバーから渡された lastReadMessageId を取得
  const initialLastReadId = Number(messagesElement.dataset.lastReadMessageId) || 0

  // 過去メッセージに既読マークを付与（入室時）
  messagesElement.querySelectorAll("[data-message-id]").forEach(msgDiv => {
    const msgId = Number(msgDiv.dataset.messageId)
    const senderId = Number(msgDiv.dataset.senderId)
    if (senderId === Number(currentUserId) && msgId <= initialLastReadId) {
      addReadMark(msgDiv)
    }
  })

  // ActionCable サブスクリプション
  const subscription = consumer.subscriptions.create(
    { channel: "ChatRoomChannel", chat_room_id: roomId },
    {
      // WebSocketが接続した１回だけ呼ばれる。
      connected() {
        console.log("✅ チャットルームに接続しました")
        messagesElement.querySelectorAll("[data-sender-id]").forEach((msg) => {
          applyAlignment(msg,msg.dataset.senderId, currentUserId)
        })
        scrollToBottom(messagesElement)
        // 相手が送信した最新のメッセージIDを探す
        const allMessages = messagesElement.querySelectorAll('[data-message-id]');
        let lastOpponentMessageId = 0;

        // メッセージを後ろから探して、最初に見つかった「相手のメッセージ」のIDを取得
        for (let i = allMessages.length - 1; i >= 0; i--) {
          const message = allMessages[i];
          if (message.dataset.senderId !== currentUserId) {
            lastOpponentMessageId = Number(message.dataset.messageId);
            break; // 見つかったらループを終了
          }
        }

        // 相手のメッセージが1つでもあれば、そのIDを「ここまで読んだ」とサーバーに通知
        if (lastOpponentMessageId > 0) {
          sendReadReceipt(lastOpponentMessageId);
        }
        messagesElement.querySelectorAll("[data-message-id]").forEach(msgDiv => {
          const msgId = Number(msgDiv.dataset.messageId)
          const senderId = Number(msgDiv.dataset.senderId)
          if (senderId === Number(currentUserId) && msgId <= initialLastReadId) {
            addReadMark(msgDiv)  // DOMに既読マークだけ
          }
        })
      },
      disconnected() {
        console.log("❌ チャットルームから切断されました")
      },
      // サーバーがブロードキャストしたイベントがここに届く
      received(data) {
        console.log("📩 received", data);
        try {
          if (!data) return
          // ブロードキャストされたHTMLをDOMに追加
          if (data.type === "message" && data.message) {
            const wrapper = document.createElement("div")
            wrapper.innerHTML = data.message
            const messageDiv = wrapper.firstElementChild
            applyAlignment(messageDiv, data.sender_id, currentUserId)
            messagesElement.appendChild(messageDiv)
            scrollToBottom(messagesElement)
            const messageId = Number(messageDiv.dataset.messageId)
            // 相手のメッセージなら、リアルタイムで既読送信（重複防止）
            if (data.sender_id.toString() !== currentUserId.toString()) {
              if (messageId > myLastSentReadId) {
                sendReadReceipt(messageId)
              }
            }
            console.log("✅ メッセージDOMに追加完了", {
              messageId: messageDiv.dataset.messageId,
              senderId: data.sender_id,
              cachedLastReadByUser: lastReadByUser
            })
            // もし既にその送信者の last-read が届いていて
            // 新しく追加したメッセージが既読条件を満たすなら適用する
            console.log("▶ apply cached lastRead entries:", Object.entries(lastReadByUser))
            setTimeout(() => {
              Object.entries(lastReadByUser).forEach(([userId, lastRead]) => {
              applyReadMarkForReader(messagesElement, currentUserId, userId, lastRead)
              })
            }, 0)
          }
          if (data.type === "read") {
            console.log("📣 received read event:", data)
            lastReadByUser[String(data.user_id)] = Number(data.last_read_message_id) || 0
            console.log("📥 updated lastReadByUser:", lastReadByUser)
            applyReadMarkForReader(messagesElement, currentUserId, data.user_id, data.last_read_message_id)
            console.log(`👀 既読処理 user_id=${data.user_id}, last_read=${data.last_read_message_id}`)
          }
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
  const mutationDebounce = { id: null }
    const mo = new MutationObserver((mutations) => {
      if (mutationDebounce.id) clearTimeout(mutationDebounce.id)
      mutationDebounce.id = setTimeout(() => {
        Object.entries(lastReadByUser).forEach(([userId, lastRead]) => {
          applyReadMarkForReader(messagesElement, currentUserId, userId, lastRead)
        })
      }, 0)
    })
    mo.observe(messagesElement, { childList: true, subtree: true })

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
  //messageDOMに既読を追加する
  function addReadMark(msgDiv) {
    if (!msgDiv) return
    const bubble = msgDiv.querySelector(".message-bubble")
    if (!bubble) return;
    if (msgDiv.querySelector(".read-status")) return
    const span = document.createElement("span")
    span.className = "read-status text-xs text-blue-200"
    span.textContent = "既読"
    bubble.insertAdjacentElement("beforebegin", span)
    console.log("📌 read mark appended:", span, "to msgDiv:", msgDiv)
  }
  // 他の誰かが読んだという情報を受け取ったときに自分の送信メッセージに「既読」を付ける処理
  function applyReadMarkForReader(messagesElement, currentUserId, readerId, lastReadId) {
    console.log("⚡ applyReadMarkForReader start", {readerId, lastReadId})
    const targetMessage = messagesElement.querySelector(`[data-message-id="${lastReadId}"]`);
    console.log("🎯 targetMessage =", targetMessage);
    const meId = Number(currentUserId)
    const rId = Number(readerId)
    const lastIdNum = Number(lastReadId) || 0
    if (rId === meId || lastIdNum <= 0) return
    const myMessages = messagesElement.querySelectorAll(`[data-sender-id="${meId}"]`)
    myMessages.forEach((msgDiv) => {
      const msgId = Number(msgDiv.dataset.messageId)
      const senderId = Number(msgDiv.dataset.senderId)
      if (senderId !== meId) return
      if (msgId > lastIdNum) return
      if (msgDiv.querySelector(".read-status")) return
      addReadMark(msgDiv)
      console.log("👀 既読マーク付与:", msgId, "for reader:", rId)
    })
  }
  // ActionCableのperformを使ってサーバー側のmark_readアクションを呼ぶ
  function sendReadReceipt(lastReadMessageId) {
    if (!lastReadMessageId) return
    if (!isRoomOpen) {
      console.log("🚪 ルームを閉じているため既読送信しません")    
      return
    }
    if (lastReadMessageId <= myLastSentReadId) return
    subscription.perform("mark_read", {
      id: roomId,
      last_read_message_id: lastReadMessageId
    })
    myLastSentReadId = lastReadMessageId
    console.log("😂 sendReadReceipt:", lastReadMessageId)
  }
  // ルーム閉じたら既読送信を停止
  window.chatRoom = { closeRoom: () => { isRoomOpen = false } }
}

