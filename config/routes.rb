# frozen_string_literal: true

Avatax::Engine.routes.draw do
  root to: 'configuration#index'

  resources :configuration, only: [:index]

  scope '/configuration' do
    get '/tax_code' => 'configuration#set_tax_code', :as => 'set_tax_code_configuration'
    post '/tax_code' => 'configuration#do_set_tax_code', :as => 'do_set_tax_code_configuration'
    delete '/tax_code' => 'configuration#remove_tax_code', :as => 'remove_tax_code_configuration'

    get '/exemption' => 'configuration#set_exemption', :as => 'set_exemption_configuration'
    post '/exemption' => 'configuration#do_set_exemption', :as => 'do_set_exemption_configuration'
    delete '/exemption' => 'configuration#remove_exemption', :as => 'remove_exemption_configuration'

    get '/plugin' => 'configuration#plugin_configuration', :as => 'plugin_configuration'
    post '/plugin' => 'configuration#update_plugin_configuration', :as => 'update_plugin_configuration'
  end
end
