# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  resource :users do 
    member do
      post :enable_multi_factor_authentication, to: 'users/multi_factor_authentication#verify_enable'
      post :disable_multi_factor_authentication, to: 'users/multi_factor_authentication#verify_disabled'
      post :mfa, to: 'users/sessions#create'
    end
  end
 
  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'
  get 'unlock/show', to: 'unlock#show'

  namespace :api, defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth'
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get '/myaccount/profile',       to: 'myaccount#profile'
      put '/myaccount/profile',       to: 'myaccount#update', as: 'my_account_profile_update'
      get '/myaccount/open_qrcode_mfa', to: 'myaccount#open_qrcode_mfa'

      get '/countries/:name',         to: 'countries#show'
      get '/search_histories',        to: 'search_histories#index'
    end

    # for another features
    scope module: :v2,
          constraints: ApiConstraints.new(version: 2, default: false) do
    end
  end
end
