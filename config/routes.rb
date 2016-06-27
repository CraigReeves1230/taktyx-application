#Routes
Rails.application.routes.draw do


  root 'home#index', as: 'home'

  get '/user/terms-of-service', to: redirect('/terms_of_service.html'), as: 'terms_of_service'
  get '/login' => 'auth#login', as: 'login'
  post '/login' => 'auth#do_login', as: 'do_login'
  get '/logout' => 'auth#logout', as: 'logout'
  get '/user/register' => 'users#register', as: 'user_register'
  post '/user/register' => 'users#do_save_user', as: 'save_user'
  get '/search' => 'search#results', as: 'search_results'

  get '/service' => 'services#create_edit', as: 'create_edit_service'
  get '/service/json/:id' => 'services#get_data', as: 'service_get_data'
  post '/service' => 'services#do_create', as: 'do_create_service'
  post '/service/delete/:id' => 'services#do_delete', as: 'do_delete_service'
  put '/service/status/:id' => 'services#do_update_status', as: 'do_update_service_status'
  put '/service/:id' => 'services#do_update', as: 'do_update_service'

  get '/password-reset' => 'password_resets#new', as: 'password_resets_new'
  get '/password-reset/recover/:id/:email' => 'password_resets#edit', as: 'password_resets_edit', constraints: {:email => /[^\/]+/}
  post '/password-reset' => 'password_resets#create', as: 'password_resets_create'
  post '/password-reset/complete' => 'password_resets#update', as: 'password_resets_update'
  post '/password-reset/recover/:id/:email' => 'password_resets#verify_reset', as: 'edit_password_reset', constraints: {:email => /[^\/]+/}

  get '/activations/:id/confirm' => 'activations#confirm', as: 'activation_confirm'
  get '/activation_resend' => 'users#resend_activation', as: 'resend_activation'

  post '/messages/create' => 'messages#do_create'
  get '/messages/fetch' => 'messages#fetch'
  post '/messages/delete/:id' => 'messages#do_delete'

end
