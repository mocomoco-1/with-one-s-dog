class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = current_user.chat_rooms.includes(:users, :chat_messages)
  end

  def show
    @chat_room = current_user.chat_rooms.find(params[:id])
    @chat_messages = @chat_room.chat_messages.includes(:user).order(created_at: :asc)
    @chat_message = ChatMessage.new
  end
end
