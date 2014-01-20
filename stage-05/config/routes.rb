Nice::Application.routes.draw do

  get 'compliments/random' => 'compliments#random'

  get 'compliments/new' => 'compliments#new'
  post 'compliments/create' => 'compliments#create'

  post 'compliments/:id/rate' => 'compliments#rate', as: :rate_compliment

  root :to => redirect('compliments/random')

end
