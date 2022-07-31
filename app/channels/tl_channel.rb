class TlChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tl_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def hello(data)
    ActionCable.server.broadcast "tl_channel", message: data['message']
  end
end
