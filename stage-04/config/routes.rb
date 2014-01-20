Nice::Application.routes.draw do

  get 'compliments/random' => 'compliments#random'
  get 'compliments/new' => 'compliments#new'
  post 'compliments/create' => 'compliments#create'

  root :to => redirect('compliments/random')

end
