class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pundit

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "你暂无权限进行此操作!"
    redirect_to(request.referer || root_path)
  end
end
