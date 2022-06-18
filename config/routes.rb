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
  resources :probe_settings, only: [:index, :create, :destroy]

  resources :web_spider_settings, only: [:create, :destroy]

  resources :rss_feeds, only: [] do
    collection do
      get :unread_count
      put :mark_all_as_read
      get :load_more_rss_feed
      put :toggle_thumbs_up
      get :recommend
      get :favor
      get :recommend_feeds_of_specify_feed
    end
  end
  get 'rss_list' => 'rss_feeds#rss_feeds_of_rss', as: 'rss_feed_rss_list'

  get 'rss' => 'probe_settings#index', as: 'rss'

  scope module: 'goods' do
    resources :goods, only: [] do
      collection do
        get 'comments'
        get 'prices'
        get 'coupons'
        get 'ads'
        get 'names'
      end
    end
  end

  post 'sql' => 'sql#sql'

  get 'running_jobs_count' => 'jobs_management/jobs_management#running_jobs_count', as: 'running_jobs_count'
  post 'start_job' => 'jobs_management/jobs_management#start_job', as: 'start_job'
  post 'start_all_jobs' => 'jobs_management/jobs_management#start_all_jobs', as: 'start_all_jobs'
  delete 'delete_job' => 'jobs_management/jobs_management#delete_job', as: 'delete_job'
  get 'histories' => 'histories/histories#histories', as: 'histories'

  # constraints subdomain: "api" do
    namespace :api, path: nil do
      # namespace :v1 do
        match "*path", to: "api#gone", via: :all
      # end
    end
  # end
end
