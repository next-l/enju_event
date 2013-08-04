Rails.application.routes.draw do
  resources :events do
    resources :picture_files
  end
  resources :event_categories
  resources :libraries do
    resources :events
  end
  resources :event_import_files do
    resources :event_import_results, :only => [:index, :show, :destroy]
  end
  resources :event_import_results, :only => [:index, :show, :destroy]
  resources :participates

  get '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  get "/calendar/:year/:month/:day" => "calendar#show"
end
