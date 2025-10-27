class ChangeChatMessagesContentNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :chat_messages, :content, true
  end
end
