Rails.application.routes.draw do
  
  
  
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ , defaults: {format: :json} do
      
    resources :sessions, only: [:create]
    match 'sessions/logout'              => 'sessions#destroy',       via: :delete
    match 'sessions/check'               => 'sessions#check',         via: :get    

    resources :users
    resources :companies
    resources :loans do
      member do
        put :pay
      end
    end
    match 'loans/project/get' => 'loans#project', via: :post
    resources :people
    resources :monetary_transactions
    match 'monetary_transactions/resume/get' => 'monetary_transactions#resume', via: :get
  
  end

end
