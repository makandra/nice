class Compliment < ActiveRecord::Base

  def self.random
    compliment = Compliment.all.sample
    if compliment.nil?
      create_default_compliments
      random
    else
      compliment
    end
  end

  def self.create_default_compliments
    Compliment.create!(message: "Your parents are more proud of you than you'll ever know.")
    Compliment.create!(message: "You actually looked super graceful that time you tripped in front of everyone.")
    Compliment.create!(message: "People at trivia night are terrified by you.")
    Compliment.create!(message: "You pick the best radio stations when you're riding shotgun.")
    Compliment.create!(message: "Your pet loves you too much to ever run away.")
  end

end
