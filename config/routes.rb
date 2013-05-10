Story::Application.routes.draw do

  resources :narratives, only: [:index, :show, :update, :new] do
    get :events
  end

  root to: 'narratives#index'

end
