Feature: Compliments

  @javascript @slow
  Scenario: User draws random compliments until she feels better
    Given my random generator is predictable
    When I go to a random compliment
    Then I should see "Your pet loves you too much to ever run away"
    When I follow "I still feel crappy"
    Then I should see "People at trivia night are terrified by you"
    When I follow "I still feel crappy"
    Then I should see "You pick the best radio stations when you're riding shotgun"

  @javascript @slow
  Scenario: User submits a new compliment
    When I go to a random compliment
    And I follow "Add a compliment"
    Then the screen should be titled "New compliment"
    When I press "Submit"
    Then I should see an error message
    When I fill in "Message" with "You're the best at making cereal."
    And I press "Submit"
    Then I should see "We received your compliment"

