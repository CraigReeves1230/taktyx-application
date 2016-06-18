#Routes
Rails.application.routes.draw do

  get 'password_resets/new'
  get 'password_resets/edit'
  post 'password_resets/create'
  post 'password_resets/update'
  get 'services/index'
  root 'home#index', as: 'home'

  get '/user/terms-of-service', to: redirect('/terms_of_service.html'), as: 'terms_of_service'
  get '/login' => 'auth#login', as: 'login'
  post '/login' => 'auth#do_login', as: 'do_login'
  get '/logout' => 'auth#logout', as: 'logout'
  get '/user/register' => 'users#register', as: 'user_register'
  post '/user/register' => 'users#do_save_user', as: 'save_user'
  get '/search' => 'search#results', as: 'search_results'
  get '/service' => 'services#create_edit', as: 'create_edit_service'
  post '/service' => 'services#do_create', as: 'do_create_service'
  get '/activations/:id/confirm' => 'activations#confirm', as: 'activation_confirm'
  get '/activation_resend' => 'users#resend_activation', as: 'resend_activation'
  resources :password_resets, only: [:edit]


end
