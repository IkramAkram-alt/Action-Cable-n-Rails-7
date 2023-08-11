class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'RoomChannel'
    # stream_from "room_#{params[:room_id]}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def set_user_data
    user = {
      id: current_user.id,
      email: current_user.email,
      username: current_user.email.split('@')[0],
    }
    ActionCable.server.broadcast 'RoomChannel', { user: user }
  end
end
