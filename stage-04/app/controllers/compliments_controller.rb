class ComplimentsController < ApplicationController

  def random
    @compliment = Compliment.random
  end

  def new
    @compliment = Compliment.new
    render 'new'
  end

  def create
    @compliment = Compliment.new
    @compliment.message = params['compliment']['message']

    if @compliment.save
      render 'created'
    else
      render 'new'
    end
  end

end
