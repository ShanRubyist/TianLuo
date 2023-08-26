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

  mount ActionCable.server => '/cable'

  # 自定义路由
  resources :probe_settings, only: [:index, :create, :destroy]

  resources :web_spider_settings, only: [:create, :destroy]

  resources :rss_feeds, only: [:index] do
    collection do
      get :briefly_info
      get :unread_count
      put :mark_all_as_read
      get :load_more_rss_feed
      put :toggle_thumbs_up
      get :recommend
      get :favor
      get :recommend_feeds_of_specify_feed
    end
  end

  resources :probe_settings, only: [:index] do

  end

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

  # scope module: 'jobs_management' do
  #   resources :jobs_management, only: [] do
  #     collection do
  #       get 'running_jobs_count', as: 'running_jobs_count'
  #       post 'start_job', as: 'start_job'
  #       post 'start_all_jobs', as: 'start_all_jobs'
  #       delete 'delete_job', as: 'delete_job'
  #     end
  #   end
  # end

  get 'running_jobs_count' => 'jobs_management/jobs_management#running_jobs_count', as: 'running_jobs_count'
  post 'start_job' => 'jobs_management/jobs_management#start_job', as: 'start_job'
  post 'start_all_jobs' => 'jobs_management/jobs_management#start_all_jobs', as: 'start_all_jobs'
  delete 'delete_job' => 'jobs_management/jobs_management#delete_job', as: 'delete_job'
  get 'histories' => 'histories/histories#histories', as: 'histories'

  post 'sql' => 'sql#sql', as: 'sql'

  # constraints subdomain: "api" do
  #   namespace :api, path: nil do
      # namespace :v1 do
      #   match "*path", to: "api#gone", via: :all
      # end
    # end
  # end
end
