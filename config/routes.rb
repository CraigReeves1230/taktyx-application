#Routes
Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'password_resets/create'

  root 'home#index', as: 'home'

  get '/user/terms-of-service', to: redirect('/terms_of_service.html'), as: 'terms_of_service'
  get '/login' => 'auth#login', as: 'login'
  post '/login' => 'auth#do_login', as: 'do_login'
  get '/logout' => 'auth#logout', as: 'logout'
  get '/user/register' => 'users#register', as: 'user_register'
  post '/user/register' => 'users#do_save_user', as: 'save_user'
  get '/search' => 'search#results', as: 'search_results'
  get '/user/password-reset' => 'password_resets#new', as: 'new'
  post 'password_resets/create' => 'password_resets#create', as: 'create'

end
