class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = current_user.chat_rooms.includes(:users, :chat_messages)
  end

  def show
    @chat_room = current_user.chat_rooms.find(params[:id])
    @chat_messages = @chat_room.chat_messages.includes(:user).order(created_at: :asc)
    @chat_message = ChatMessage.new
  end

  def create
    opponent = User.find(params[:opponent_id])
    @chat_room = ChatRoom.between(current_user.id, opponent.id).first_or_create!

    if @chat_room.persisted? && @chat_room.chat_room_users.empty?
      ChatRoomUser.create!(chat_room: @chat_room, user: current_user)
      ChatRoomUser.create!(chat_room: @chat_room, user: opponent)
    end
    # @chat_room.persisted?は必ずtrueになるが、可読性のために記載

    redirect_to chat_room_path(@chat_room)
  end
end
