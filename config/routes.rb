Rails.application.routes.draw do
  devise_for :users

  root to: "pages#dashboard"

  # My Companies
  resources :companies, only: [:new, :create, :show, :index]

  # My expanses & Reciepts
  resources :expenses do
    resource :receipt, only: [:show, :create, :destroy]
  end

  # My Clients & Projects
  resources :clients, only: [:new, :create, :show, :index]
  resources :projects, only: [:new, :create, :show, :index]

  # My invoices
  resources :invoices, only: [:new, :create, :show, :index] do
    resources :invoice_items, only: [:create, :update, :destroy]
  end
end
