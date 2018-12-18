Rails.application.routes.draw do
  root "home#index"
  devise_for :users, controllers: {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords"
  }

  devise_scope :user do
    #松田変更ここから
    get   'change_mode', to: 'users/registrations#change_mode', as: 'change_mode'
    #松田変更ここまで
    get   'profile_edit', to: 'users/registrations#profile_edit', as: 'profile_edit'
    patch 'profile_update', to: 'users/registrations#profile_update', as: 'profile_update'
  end

  resources :users, only: [:index, :show]
end
