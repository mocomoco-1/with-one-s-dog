class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = current_user.chat_rooms.includes(:users, :chat_messages).sort_by { |room| room.latest_message&.created_at || Time.zone.at(0) }.reverse
  end

  def show
    @chat_room = current_user.chat_rooms.find(params[:id])
    @chat_messages = @chat_room.chat_messages.includes(:user, images_attachments: :blob).order(created_at: :asc)
    @chat_message = ChatMessage.new
    @other_user = @chat_room.other_user(current_user)
    # 相手のChatRoomUserレコードを取得
    @opponent_chat_room_user = @chat_room.chat_room_users.find_by(user: @other_user)
    # 相手の最終既読IDを取得し、ビューに渡す
    @opponent_last_read_id = @opponent_chat_room_user&.last_read_message_id.to_i
  end

  def create
    opponent = User.find(params[:opponent_id])
    @chat_room = ChatRoom.between(current_user.id, opponent.id).first_or_create!

    if @chat_room.persisted? && @chat_room.chat_room_users.empty?
      ChatRoomUser.create!(chat_room: @chat_room, user: current_user)
      ChatRoomUser.create!(chat_room: @chat_room, user: opponent)
    end

    redirect_to chat_room_path(@chat_room)
  end
end
