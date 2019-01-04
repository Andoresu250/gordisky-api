Rails.application.routes.draw do
  
  
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ , defaults: {format: :json} do
      
    resources :sessions, only: [:create]
    match 'sessions/logout'              => 'sessions#destroy',       via: :delete
    match 'sessions/check'               => 'sessions#check',         via: :get    

    resources :users
    resources :companies
    resources :loans
    resources :people
  
  end

end
