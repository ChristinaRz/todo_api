Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  #διαδρομές για Authentication
  post '/signup',       to: 'auth#signup'
  post '/auth/login',   to: 'auth#login'
  get  '/auth/logout',  to: 'auth#logout'

  #διαδρομές για Todos
  get    '/todos',          to: 'todos#index'
  post   '/todos',          to: 'todos#create'
  get    '/todos/:id',      to: 'todos#show'
  put    '/todos/:id',      to: 'todos#update'
  delete '/todos/:id',      to: 'todos#destroy'

  #διαδρομές για Todo Items
  get    '/todos/:id/items/:iid',  to: 'todo_items#show'
  post   '/todos/:id/items',       to: 'todo_items#create'
  put    '/todos/:id/items/:iid',  to: 'todo_items#update'
  delete '/todos/:id/items/:iid',  to: 'todo_items#destroy'
end