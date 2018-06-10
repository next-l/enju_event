Rails.application.routes.draw do
  resources :places
  resources :event_export_files

  resources :event_import_files

  resources :events
  resources :event_categories
  resources :event_import_results, only: [:index, :show, :destroy]
  resources :participates
end
