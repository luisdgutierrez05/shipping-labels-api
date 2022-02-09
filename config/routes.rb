# frozen_string_literal: true

require 'resque/server'

Rails.application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  namespace :api do
    namespace :v1 do
      namespace :shipment_labels do
        resources :requests, only: %i[create show]
        resources :files, only: %i[show]
      end
    end
  end
end
