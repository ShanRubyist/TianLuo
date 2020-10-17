Rails.application.routes.draw do
  use_doorkeeper
  get 'home/index'
  root to: "home#index"

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

  put 'mark_readed' => 'rss_feeds#mark_readed'
  get 'load_more_rss_feed' => 'rss_feeds#load_more_rss_feed'

  post 'sql' => 'sql#sql'
  get 'comments/' => 'goods#comments'
  get 'prices/' => 'goods#prices'
  get 'coupons/' => 'goods#coupons'
  get 'ads/' => 'goods#ads'
  get 'names/' => 'goods#names'

  resources :probe_settings
  resources :web_spider_settings

  get 'all' => 'home#all', as: 'all'
  get 'running_jobs_count' => 'home#running_jobs_count', as: 'running_jobs_count'
  post 'start_job' => 'home#start_job', as: 'start_job'
  delete 'delete_job' => 'home#delete_job', as: 'delete_job'
  get 'histories' => 'home#histories', as: 'histories'

  resources :rss_feeds do
    member do
      get :unread_count
    end
  end
end
