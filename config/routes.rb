Rails.application.routes.draw do
  root to: "home#index"

  # 第三方引擎的路由
  use_doorkeeper

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
      sessions: 'users/sessions',
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register' }

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # 自定义路由
  resources :probe_settings

  resources :web_spider_settings

  resources :rss_feeds do
    collection do
      get :unread_count
      put :mark_readed
      get :load_more_rss_feed
    end
  end

  resources :goods do
    collection do
      get 'comments'
      get 'prices'
      get 'coupons'
      get 'ads'
      get 'names'
    end
  end

  post 'sql' => 'sql#sql'

  get 'all' => 'home#all', as: 'all'
  get 'running_jobs_count' => 'home#running_jobs_count', as: 'running_jobs_count'
  post 'start_job' => 'home#start_job', as: 'start_job'
  delete 'delete_job' => 'home#delete_job', as: 'delete_job'
  get 'histories' => 'home#histories', as: 'histories'
end
