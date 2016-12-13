Rails.application.routes.draw do
  resource :scraps, only: [:new, :create]
  root 'scraps#new'
end
