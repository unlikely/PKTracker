Pktracker::Application.routes.draw do

  resources :developers do
    member do
      post 'asked_question'
      post 'broke_production'
      post 'add_points'
    end
  end

  root :to => 'developers#index'

  post '/pivotal_activity' => 'pivotal_activity#activity'

end
