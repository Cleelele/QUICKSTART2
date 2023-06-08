class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    @user = current_user
    authorize(@chatroom)
  end
end
