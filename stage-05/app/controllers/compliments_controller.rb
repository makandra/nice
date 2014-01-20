class ComplimentsController < ApplicationController

  def random
    @compliment = Compliment.random
    render 'compliment'
  end

  def new
    @compliment = Compliment.new
  end

  def create
    @compliment = Compliment.new(params[:compliment])
    if @compliment.save
      render 'created'
    else
      render 'new'
    end
  end

  def rate
    stars = params[:stars]
    @compliment = Compliment.find(params[:id])
    @compliment.rate(stars)
    render 'compliment'
  end

end
