Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :voice_generations, only: [:create, :index, :show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
