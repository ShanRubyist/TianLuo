# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  def weibo
    # TODO: 新授权用户需要处理绑定帐号（注册新帐号绑定或登陆已有帐号绑定）
    # render plain: request.env['omniauth.auth']

    user = User.where(auth_hash.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth_hash.provider
      user.uid = auth_hash.uid
      # user.name = auth_hash.info.nickname
      # user.image = auth_hash.info.image
    end

    if user.persisted?
      sign_in(:user, user)
      redirect_to root_path, notice: 'Signed in!'
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_path, notice: 'Weibo授权登陆成功，请先注册帐号或绑定帐号'
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
