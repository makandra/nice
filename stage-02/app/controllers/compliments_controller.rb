class ComplimentsController < ApplicationController

  def random
    @compliment = Compliment.random
  end

end
