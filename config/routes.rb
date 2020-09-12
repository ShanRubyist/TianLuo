Rails.application.routes.draw do
  get 'home/index'
  root to: "home#index"

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
      sessions: 'users/sessions'
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
end
