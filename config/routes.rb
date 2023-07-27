require_relative '../app/api/base.rb'
Rails.application.routes.draw do

  get '/swagger', to: 'swagger#index'
  mount API::Base => API::Base::PREFIX
end
