Rails.application.routes.draw do
  resources :events do
    resources :picture_files
  end
  resources :event_categories
  resources :event_import_files
  resources :libraries do
    resources :events
  end
end
