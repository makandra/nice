Nice::Application.routes.draw do

  get 'compliments/random' => 'compliments#random'

  root :to => redirect('compliments/random')

end
