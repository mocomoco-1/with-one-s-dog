import consumer from "./consumer"
// DOM読み込み完了を待つ
document.addEventListener('turbo:load', initChat)
document.addEventListener("turbo:before-cache", () => {
  consumer.subscriptions.subscriptions.forEach((sub) => {
    if (sub.identifier.includes("ChatRoomChannel")) {
      consumer.subscriptions.remove(sub)
      console.log("🧹 before-cacheでサブスクリプション削除:", sub.identifier)
    }
  })
})
function initChat() {
  const messagesElement = document.getElementById("messages")
  if (!messagesElement) return
  const roomId = messagesElement?.dataset?.roomId
  if (!roomId) return
  const currentUserId = messagesElement?.dataset?.currentUserId
  // 自分が読んだ既読通知をサーバーに送った最後の位置（変わる）
  let myLastSentReadId = Number(messagesElement.dataset.lastReadMessageId) || 0
  let isRoomOpen = true // ルーム開閉フラグ
  let lastReadByUser = {} // 相手がどこまで読んだかをブラウザでキャッシュする。相手の既読を覚えておくもの
  // document.addEventListener("turbo:before-visit", () => {
  // console.log("🚪 チャットルームを退出しました")
  //   isRoomOpen = false
  // })
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

  // 最初にサーバーから渡された lastReadMessageId を取得(変わらない)
  const initialLastReadId = Number(messagesElement.dataset.lastReadMessageId) || 0

  // 過去の自分のメッセージに既読マークを付与（入室時）
  messagesElement.querySelectorAll("[data-message-id]").forEach(msgDiv => {
    const { msgId, senderId } = extractMessageData(msgDiv)
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
        messagesElement.querySelectorAll("[data-sender-id]").forEach((msgDiv) => {
          const { msgId, senderId } = extractMessageData(msgDiv)
          applyAlignment(msgDiv, senderId, currentUserId)
        })
        scrollToBottom(messagesElement)

        // 自分はどこまで読んだか（相手が送信した最新のメッセージIDを探す
        const allMessages = messagesElement.querySelectorAll('[data-message-id]')
        let lastOpponentMessageId = 0
        // メッセージを後ろから探して、最初に見つかった「相手のメッセージ」のIDを取得
        for (let i = allMessages.length - 1; i >= 0; i--) {
          const { msgId, senderId } = extractMessageData(allMessages[i])
          if (senderId !== Number(currentUserId)) {
            lastOpponentMessageId = msgId
            break
          }
        }
        // 自分が今どこまで相手のメッセージを読んだか、IDを「ここまで読んだ」とサーバーに保存
        if (lastOpponentMessageId > 0) {
          sendReadReceipt(lastOpponentMessageId)
          console.log("😶‍🌫️呼ばれました", lastOpponentMessageId)
        }else{
          console.log("😶‍🌫️０です")
        }
        // 相手はどこまで読んだか（自分のメッセージに既読を付ける
        messagesElement.querySelectorAll("[data-message-id]").forEach(msgDiv => {
          const { msgId, senderId } = extractMessageData(msgDiv)
          if (senderId === Number(currentUserId) && msgId <= initialLastReadId) {
            addReadMark(msgDiv)
          }
        })
        Object.entries(lastReadByUser).forEach(([userId, lastRead]) => {
          applyReadMarkForReader(messagesElement, currentUserId, userId, lastRead)
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
            const { msgId, senderId } = extractMessageData(messageDiv)
            applyAlignment(messageDiv, senderId, currentUserId)
            // メッセージ一覧に新しいメッセージを追加する
            messagesElement.appendChild(messageDiv)
            scrollToBottom(messagesElement)
            // 相手のメッセージなら、自分がどこまで読んだか既読送信
            if (senderId !== Number(currentUserId)) {
              if (msgId > myLastSentReadId) {
                sendReadReceipt(msgId)
              }else{
                console.log("sendReadReceiptには入れませんでした")
              }
            }
            console.log("✅ メッセージDOMに追加完了", {
              msgId,
              senderId,
              cachedLastReadByUser: lastReadByUser
            })
            if (isRoomOpen && messageDiv && senderId == Number(currentUserId)) {
              addReadMark(messageDiv)
            }

            // 相手がどこまで読んだかを取り出して、既読を付ける関数を呼ぶ
            // 新しく追加したメッセージが既読条件を満たすなら適用する
            console.log("▶ apply cached lastRead entries:", Object.entries(lastReadByUser))
            setTimeout(() => {
              Object.entries(lastReadByUser).forEach(([userId, lastRead]) => {
              applyReadMarkForReader(messagesElement, currentUserId, userId, lastRead)
              })
            }, 0)
          }
          if (data.type === "read") {
            // const readerId = Number(data.user_id)
            // const lastReadId = Number(data.last_read_message_id)
            // console.log("📘 read event received", {
            //   readerId, currentUserId, lastReadId
            // })
            // if (Number(readerId) === Number(currentUserId)) {
            //   console.log("🙈 自分のreadイベントなのでスキップ")
            //   return
            // }
            console.log("📣 received read event:", data)
            // lastReadByUser["相手ID"] = 25(最後に読んだId)or0
            lastReadByUser[String(data.user_id)] = Number(data.last_read_message_id) || 0
            console.log("📥 updated lastReadByUser:", lastReadByUser)
            applyReadMarkForReader(messagesElement, currentUserId, data.user_id, data.last_read_message_id)
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
  // DOMが変わったときに既読マークを再適応する
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

  function extractMessageData(msgDiv) {
    return{
      msgId: Number(msgDiv.dataset.messageId),
      senderId: Number(msgDiv.dataset.senderId)
    }
  }
  // スクロール処理を関数化
  function scrollToBottom(element) {
    element.scrollTop = element.scrollHeight
  }
  // 新着１件の左右分け・色分けの処理
  function applyAlignment(messageDiv, senderId, currentUserId) {
    if (!messageDiv || !senderId || !currentUserId) return

    if (senderId === Number(currentUserId)) {
      messageDiv.classList.add("justify-end")
      messageDiv.querySelector(".message-bubble")?.classList.add("bg-base-200")
    } else {
      messageDiv.classList.add("justify-start")
      messageDiv.querySelector(".message-bubble")?.classList.add("bg-accent")
    }
  }
  // 既存メッセージ全体に左右・色分けの処理
  function applyMessageAlignment(messagesElement, currentUserId) {
    messagesElement.querySelectorAll("[data-sender-id]").forEach((msg) => {
      const { msgId, senderId } = extractMessageData(msg)
      applyAlignment(msg, senderId, currentUserId)
    })
  }
  //１つのmessageDOMに既読を追加する
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
  // 相手が読んだ→自分の送信メッセージでかつ相手が読んだID以下のものすべてに「既読」を付ける処理
  function applyReadMarkForReader(messagesElement, currentUserId, readerId, lastReadId) {
    console.log("⚡ applyReadMarkForReader start", {readerId, lastReadId})
    const targetMessage = messagesElement.querySelector(`[data-message-id="${lastReadId}"]`);
    console.log("🎯 targetMessage =", targetMessage);
    const lastIdNum = Number(lastReadId) || 0
    if (lastIdNum <= 0){
      console.log("🧀最後に読んだIDが0より小さいskip")
      return
    }
    const myMessages = messagesElement.querySelectorAll(`[data-sender-id="${Number(currentUserId)}"]`)
    myMessages.forEach((msgDiv) => {
      const { msgId, senderId } = extractMessageData(msgDiv)
      if (senderId !== Number(currentUserId)) {
        console.log("自分じゃないかチェック")
        return
      }
      if (msgId > lastIdNum) {
        console.log("まだ読んでないスキップ")
        return
      }
      if (msgDiv.querySelector(".read-status")) {
        console.log("すでに既読ついてるスキップ")
        return
      }
      addReadMark(msgDiv)
      console.log("👀 既読マーク付与:", msgId, "for reader:", Number(readerId))
    })
  }
  // 自分がここまで読んだという情報をサーバーに送る。ActionCableのperformを使ってサーバー側のmark_readアクションを呼ぶ
  function sendReadReceipt(lastReadMessageId) {
    console.log("📮 sendReadReceipt呼び出し開始", lastReadMessageId, "isRoomOpen=", isRoomOpen)
    if (!lastReadMessageId) {
      console.log("ない", lastReadMessageId)
      return
    }
    if (!isRoomOpen) {
      console.log("🚪 ルームを閉じているため既読送信しません")    
      return
    }
    if (lastReadMessageId < myLastSentReadId) {
      console.log("自分が最後に読んだ方が大きい", lastReadMessageId, myLastSentReadId)
      return
    }
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

