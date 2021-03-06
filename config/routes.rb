Rails.application.routes.draw do
  devise_for :users

  resources :action_points, except: [:show, :destroy]
  resources :attachments, except: [:show, :destroy]
  resources :dayoffs
  resources :events, only: :index
  resources :notes, except: [:show, :destroy]
  resources :people do
    get :autocomplete_person_name, on: :collection
  end
  resources :reports, only: :index do
    collection do
      get :by_status
    end
  end
  resources :tags, only: :index
  resources :users, except: :destroy
  resources :vacancies, except: :destroy

  root 'home#index'
end
