class ChatMessagesController < ApplicationController
  def create
    @chat_room = current_user.chat_rooms.find(params[:chat_room_id])
    @chat_message = @chat_room.chat_messages.build(chat_message_params)
    @chat_message.user = current_user

    if @chat_message.save
      head :ok
    end
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:content, images: [])
  end
end
