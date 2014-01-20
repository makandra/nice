class ComplimentsController < ApplicationController

  def random
    @compliment = Compliment.random
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

end
