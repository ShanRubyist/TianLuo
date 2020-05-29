class RssFeedsController < ApplicationController
  def mark_readed
    UserRssFeedShip.where(user_id: params[:user_id])
        .update(unread: false)
  end
end
