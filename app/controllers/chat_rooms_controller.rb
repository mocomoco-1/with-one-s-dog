class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = current_user.chat_rooms.includes(:users, :chat_messages).sort_by { |room| room.latest_message&.created_at || Time.zone.at(0) }.reverse
  end

  def show
    @chat_room = current_user.chat_rooms.find(params[:id])
    @chat_messages = @chat_room.chat_messages.includes(:user).order(created_at: :asc)
    @chat_message = ChatMessage.new
    @other_user = @chat_room.other_user(current_user)
    @chat_room_user = @chat_room.chat_room_users.find_by(user: current_user)
    @last_message = @chat_room.chat_messages.where.not(user_id: current_user.id).last
    # if @last_message.present?
    #   @chat_room_user.update(last_read_message_id: @last_message.id)
    # end
  end

  # def mark_read
  #   @chat_room = current_user.chat_rooms.find(params[:id])
  #   chat_room_user = @chat_room.chat_room_users.find_by(user: current_user)
  #   new_id = params[:last_read_message_id].to_i
  #   current_last_id = chat_room_user.last_read_message_id || 0
  #   if new_id > current_last_id
  #     chat_room_user.update_column(:last_read_message_id, new_id)
  #     last_read_message = @chat_room.chat_messages.find_by(id: new_id)
  #     ChatMessageReadBroadcastJob.perform_later(chat_room_user, last_read_message)
  #   end
  #   head :ok
  # end

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
