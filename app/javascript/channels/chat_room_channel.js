import consumer from "./consumer"

// サブスクリプションのインスタンスを管理する変数を定義
let chatRoomSubscription = null;

// turbo:load はページが描画されるたびに呼ばれる
document.addEventListener('turbo:load', initChat);

// ページを離れる（キャッシュされる）直前に呼ばれる
document.addEventListener("turbo:before-cache", () => {
  if (chatRoomSubscription) {
    chatRoomSubscription.unsubscribe();
    chatRoomSubscription = null;
    console.log("🧹 before-cache: サブスクリプションを削除しました");
  }
});

function initChat() {
  const messagesElement = document.getElementById("messages");

  // チャットルーム以外のページでは、残っている可能性のある接続を切り、処理を終了
  if (!messagesElement) {
    if (chatRoomSubscription) {
      chatRoomSubscription.unsubscribe();
      chatRoomSubscription = null;
      console.log("🧹 チャットルーム外に遷移: サブスクリプションを削除しました");
    }
    return;
  }

  const roomId = messagesElement.dataset.roomId;
  const currentUserId = messagesElement.dataset.currentUserId;
  if (!roomId || !currentUserId) return;

  // すでに同じルームのサブスクリプションが存在する場合は、重複作成を防ぐ
  if (chatRoomSubscription && JSON.parse(chatRoomSubscription.identifier).chat_room_id == roomId) {
    console.log("♻️ 同じルームのサブスクリプションが既に存在します。");
    scrollToBottom(messagesElement); // スクロール位置の調整だけ行う
    return;
  }
  
  // もし違うルームのサブスクリプションが残っていたら削除
  if (chatRoomSubscription) {
    chatRoomSubscription.unsubscribe();
  }

  // --- 変数定義 ---
  let myLastSentReadId = 0; // 自分がサーバーに「ここまで読んだ」と通知した最新ID
  let isRoomOpen = !document.hidden; // ユーザーが現在画面を見ているかどうかのフラグ

  // ブラウザのタブがアクティブになったかどうかの判定
  document.addEventListener("visibilitychange", () => {
    isRoomOpen = !document.hidden;
    if (isRoomOpen) {
      console.log("タブがアクティブになりました。未読メッセージを確認します。");
      sendLatestReadReceipt(); // 画面に戻ってきたら、最新の未読を読んだことにする
    }
  });


  // --- ActionCable サブスクリプション作成 ---
  chatRoomSubscription = consumer.subscriptions.create(
    { channel: "ChatRoomChannel", chat_room_id: roomId },
    {
      connected() {
        console.log(`✅ チャットルーム(ID: ${roomId})に接続しました`);
        applyMessageAlignment(messagesElement, currentUserId);
        scrollToBottom(messagesElement);

        // 相手がどこまで読んだかに基づいて、自分の過去メッセージに既読マークを付ける
        const initialLastReadIdByOpponent = Number(messagesElement.dataset.lastReadMessageId) || 0;
        applyInitialReadMarks(initialLastReadIdByOpponent);
        
        // 自分がどこまで読んだかをサーバーに通知する
        sendLatestReadReceipt();
      },

      disconnected() {
        console.log("❌ チャットルームから切断されました");
      },

      received(data) {
        console.log("📩 received", data);
        if (!data || !data.type) return;

        switch (data.type) {
          case "message":
            handleNewMessage(data);
            break
          case "read":
            handleReadReceipt(data);
            break
        }
      },
      rejected() {
        console.error("❌ チャンネル接続が拒否されました");
        alert("チャットに接続できませんでした。ページを再読み込みしてください。");
      }
    }
  );
  // --- スクロールで既読を送る処理 ---
  // messagesElement.addEventListener("scroll", () => {
  //   // scrollTop + clientHeight = 現在見えている高さ
  //   // scrollHeight = 全体の高さ
  //   const isAtBottom = messagesElement.scrollTop + messagesElement.clientHeight >= messagesElement.scrollHeight - 10;
  //   if (isAtBottom) {
  //     console.log("📚 スクロール最下部に到達しました。既読を送信します。");
  //     sendLatestReadReceipt();
  //   }
  // });
  // ★メッセージ受信時の処理
  function handleNewMessage(data) {
    if (!data.message) return;
    
    // 自分のメッセージが重複して表示されるのを防ぐ（念のため）
    if (document.querySelector(`[data-message-id="${data.message_id}"]`)) {
        console.log(`メッセージID ${data.message_id} はすでに存在します。`);
        return;
    }
    const wrapper = document.createElement("div");
    wrapper.innerHTML = data.message;
    const messageDiv = wrapper.firstElementChild;
    if (!messageDiv) {
        console.error("メッセージDOMの作成に失敗しました", data.message);
        return;
    }
    messagesElement.appendChild(messageDiv);
    const { senderId, msgId } = extractMessageData(messageDiv);
    applyAlignment(messageDiv, senderId, currentUserId);
    scrollToBottom(messagesElement);
    // デバッグ用ログを追加
    console.log("📝 新メッセージ処理:", {
        messageId: msgId,
        senderId: senderId,
        currentUserId: Number(currentUserId),
        isRoomOpen: isRoomOpen,
        shouldSendReceipt: senderId !== Number(currentUserId) && isRoomOpen
    });
    // 相手からのメッセージを受信し、かつ画面を開いているなら既読通知を送る
    const isAtBottom = messagesElement.scrollTop + messagesElement.clientHeight >= messagesElement.scrollHeight - 10;
    if (isAtBottom && senderId !== Number(currentUserId)&& isRoomOpen) {
      sendReadReceipt(msgId);
    }
  }

  // ★既読通知受信時の処理
  function handleReadReceipt(data) {
    const readerId = Number(data.reader_id);
    const lastReadId = Number(data.last_read_message_id);
    // デバッグ用ログを追加
    console.log("📘 既読通知処理:", {
      readerId: readerId,
      lastReadId: lastReadId,
      currentUserId: Number(currentUserId),
      shouldApplyMark: readerId !== Number(currentUserId)
    });
    // 自分の既読通知は画面に反映する必要はないので無視
    if (readerId === Number(currentUserId)) return;
    console.log(`📣 相手(${readerId})がメッセージ(${lastReadId})まで読みました`);
    // 自分の送信したメッセージ（かつ、相手が読んだID以下のもの）に既読マークを付ける
    messagesElement.querySelectorAll(`[data-sender-id="${currentUserId}"]`).forEach(msgDiv => {
      const { msgId } = extractMessageData(msgDiv);
      if (msgId <= lastReadId) {
        addReadMark(msgDiv);
      }else{
        console.log("相手が読んだID以下じゃない", msgId <= lastReadId)
      }
    });
  }

  // --- ヘルパー関数群 ---
  
  function extractMessageData(msgDiv) {
    return {
      msgId: Number(msgDiv.dataset.messageId),
      senderId: Number(msgDiv.dataset.senderId)
    }
  }
  
  function scrollToBottom(element) {
    element.scrollTop = element.scrollHeight;
  }
  
  function applyAlignment(messageDiv, senderId, currentUserId) {
    if (senderId === Number(currentUserId)) {
      messageDiv.classList.add("justify-end");
      messageDiv.querySelector(".message-bubble")?.classList.add("bg-base-200");
    } else {
      messageDiv.classList.add("justify-start");
      messageDiv.querySelector(".message-bubble")?.classList.add("bg-accent");
    }
  }

  function applyMessageAlignment(messagesElement, currentUserId) {
    messagesElement.querySelectorAll("[data-sender-id]").forEach((msg) => {
      const { senderId } = extractMessageData(msg);
      applyAlignment(msg, senderId, currentUserId);
    });
  }

  function addReadMark(msgDiv) {
    // 既に既読マークがあれば何もしない（冪等性）
    if (!msgDiv || msgDiv.querySelector(".read-status")) return;
    
    const readStatusSpan = document.createElement("span");
    readStatusSpan.className = "read-status text-xs mr-2 text-blue-200";
    readStatusSpan.textContent = "既読";

    // メッセージバブルの前に既読を追加
    const bubble = msgDiv.querySelector(".message-bubble");
    bubble?.parentNode.insertBefore(readStatusSpan, bubble);
  }

  function applyInitialReadMarks(lastReadId) {
    messagesElement.querySelectorAll(`[data-sender-id="${currentUserId}"]`).forEach(msgDiv => {
      const { msgId } = extractMessageData(msgDiv);
      if (msgId <= lastReadId) {
        addReadMark(msgDiv);
      }
    });
  }

  // 自分が「ここまで読んだ」とサーバーに通知する関数
  function sendReadReceipt(messageId) {
    // 最後に通知したIDより新しくなければ送信しない
    if (!messageId || messageId <= myLastSentReadId) {
      console.log("最後に通知したIDより新しくない", messageId, myLastSentReadId)
      return;
    }

    console.log(`📮 既読通知を送信: messageId=${messageId}`);
    chatRoomSubscription.perform("mark_read", {
      last_read_message_id: messageId
    });
    myLastSentReadId = messageId;
  }
  
  // 画面に見えている相手の最新メッセージを探して、そのIDで既読通知を送る
  function sendLatestReadReceipt() {
    const allMessages = messagesElement.querySelectorAll('[data-message-id]');
    let lastOpponentMessageId = 0;
    // 後ろから探して最初に見つかった相手のメッセージIDを取得
    for (let i = allMessages.length - 1; i >= 0; i--) {
      const { msgId, senderId } = extractMessageData(allMessages[i]);
      if (senderId !== Number(currentUserId)) {
        lastOpponentMessageId = msgId;
        break;
      }
    }
    if (lastOpponentMessageId > 0) {
      sendReadReceipt(lastOpponentMessageId);
    }
  }
}