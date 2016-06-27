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
  get '/user/:id/my_account' => 'users#show', as: 'user_profile'
  get 'user/:id/edit' => 'users#edit', as: 'edit_user'
  post 'user/:id/update' => 'users#update', as: 'update_user'
  get 'user/:id/delete_cancel' => 'users#cancel_delete', as: 'cancel_delete'
  get '/user/:id/delete_account' => 'users#confirm_delete_account', as: 'delete_account'
  get 'user/delete_account_email' => 'users#delete_account_email', as: 'delete_account_email'

  get '/password-reset' => 'password_resets#new', as: 'password_resets_new'
  get '/password-reset/recover/:id/:email' => 'password_resets#edit', as: 'password_resets_edit', constraints: {:email => /[^\/]+/}
  post '/password-reset' => 'password_resets#create', as: 'password_resets_create'
  post '/password-reset/complete' => 'password_resets#update', as: 'password_resets_update'
  post '/password-reset/recover/:id/:email' => 'password_resets#verify_reset', as: 'edit_password_reset', constraints: {:email => /[^\/]+/}
  get 'services/index'

  get 'photos/:id/full' => 'photos#photo_large', as: 'photo_full'
  get 'photos/:id/make_profile' => 'photos#profile_pic', as: 'make_profile_pic'
  get 'photos/:id/reject_profile' => 'photos#reject_profile', as: 'reject_profile'

  get '/activations/:id/confirm' => 'activations#confirm', as: 'activation_confirm'
  get '/activation_resend' => 'users#resend_activation', as: 'resend_activation'

  post '/messages/create' => 'messages#do_create'
  get '/messages/fetch' => 'messages#fetch'
  post '/messages/delete/:id' => 'messages#do_delete'

  resources :users, only: [:destroy]
  resources :photos
end
