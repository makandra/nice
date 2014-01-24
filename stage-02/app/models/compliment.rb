class Compliment

  AVAILABLE_MESSAGES = [
    "Your parents are more proud of you than you'll ever know.",
    "You actually looked super graceful that time you tripped in front of everyone.",
    "People at trivia night are terrified by you.",
    "You pick the best radio stations when you're riding shotgun.",
    "Your pet loves you too much to ever run away."
  ]

  def initialize(message)
    @message = message
  end

  def message
    @message
  end

  def self.random
    message = AVAILABLE_MESSAGES.sample
    return Compliment.new(message)
  end

end

