RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # 验证是否已经登录，未登录跳转登录，已登录再用Pundit判断是否有权限
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # 验证是否有权限进行相关操作
  config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  # config.excluded_models = ["User"]

    config.navigation_static_links = {
      'Sidekiq' => '/sidekiq',
    }

    config.actions do
      root :sql, :dashboard do
        route_fragment '/sql'
      end
    end
end
