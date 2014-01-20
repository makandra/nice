class Compliment < ActiveRecord::Base

  def self.random
    Compliment.all.sample or create_default_compliments
  end

  def self.create_default_compliments
    Compliment.create!(message: "Your parents are more proud of you than you'll ever know.")
    Compliment.create!(message: "You actually looked super graceful that time you tripped in front of everyone.")
    Compliment.create!(message: "People at trivia night are terrified of you.")
    Compliment.create!(message: "You pick the best radio stations when you're riding shotgun.")
    Compliment.create!(message: "Your pet loves you too much to ever run away.")
  end

end
