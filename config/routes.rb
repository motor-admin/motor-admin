# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, class_name: 'Motor::AdminUser', path: '/'

  scope ENV.fetch('BASE_PATH', '/'), as: :admin do
    with_options controller: 'ui' do
      resource :setup, only: %i[show]

      resource :settings, only: %i[show] do
        resource :general, only: %i[show]
        resources :users, only: %i[index]
        resources :roles, only: %i[index]
        resource :database, only: %i[show]
        resource :email, only: %i[show]
        resource :other, only: %i[show]
      end
    end

    namespace :api do
      resource :setup, only: %i[create]
      resource :session, only: %i[destroy]
      resources :roles, only: %i[index]
      resources :verify_db_connection, only: %i[create]
      resources :encrypted_configs, only: %i[show index create], param: 'key', constraints: { key: /.+/ }
      resources :admin_users, only: %i[index show create update destroy] do
        post :reset_password
      end
    end
  end

  authenticate :admin_user do
    mount Motor::Admin => ENV.fetch('BASE_PATH', '/')
  end
end
