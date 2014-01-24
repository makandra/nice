You Look Nice Today
===================

This is the demo application for our [Rails Workshop](http://railsworkshop.makandra.de), a yearly event
held by [makandra](http://www.makandra.com/) to tell students about
the [Ruby on Rails](http://rubyonrails.org/) framework and test-driven development.

The application was inspired by the wonderful [emergency compliment](http://emergencycompliment.com/) service.
You should make that website your homepage and buy [all their prints](http://society6.com/emergencycompliment).

![Screenshot of You Look Nice Today](screenshot.png)


How to explore this repository
------------------------------

This repository contains the **same application multiple times**, in different stages of development.
As we move along the stages, we add more and more functionality:

Below you can find a list of the various stages, with links to the most important files in each stage.


### [stage-01: Hello world](stage-01)

This stage shows a very simple Rails application with a single route, a single controller and no model.


##### [`config/routes.rb`](stage-01/config/routes.rb)

Our routes setup file. This maps incoming browser requests to controller actions.

```ruby
Nice::Application.routes.draw do

  get 'compliments/random' => 'compliments#random'

end
```

##### [`app/controllers/compliments_controller.rb`](stage-01/app/controllers/compliments_controller.rb)

Our one and only controller. It fetches a compliment and puts it into an instance variable `@compliment`.

```ruby
class ComplimentsController < ApplicationController

  def random
    available_compliments = [
      "Your parents are more proud of you than you'll ever know.",
      "You actually looked super graceful that time you tripped in front of everyone.",
      "People at trivia night are terrified by you.",
      "You pick the best radio stations when you're riding shotgun.",
      "Your pet loves you too much to ever run away."
    ]
    @compliment = available_compliments.sample
  end

end
```

##### [`app/views/compliments/random.html.erb`](stage-01/app/views/compliments/random.html.erb)

Our one and only view. It takes the `@compliment` variable that was prepared by the controller and renders it on a HTML page.

```html
<div class="compliment">
  <%= @compliment %>
</div>

<div class="actions">
  <a href="https://www.google.com/">Thanks! I feel better.</a>
  <a href="/compliments/random">I still feel crappy.</a>
</div>
```


### [stage-02: Model / View / Controller interaction](stage-02)

This stage shows MVC-style separation of concerns. The controller no longer does all the work.
Instead the controller merely *orchestrates* the collaboration between view and model.
To do that the code that was previously found in `ComplimentsController` is moved to a Ruby model `Compliment`.


##### [`app/models/compliment.rb`](stage-02/app/models/compliment.rb)

This model takes over the job of drawing a random compliment.

```ruby
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
    Compliment.new(message)
  end

end
```


##### [`app/controllers/compliments_controller.rb`](stage-02/app/controllers/compliments_controller.rb)

Now that the model does most of the work, our controller becomes very short. That's the way it should be!

```ruby
class ComplimentsController < ApplicationController

  def random
    @compliment = Compliment.random
  end

end
```


##### [`app/views/compliments/random.html.erb`](stage-02/app/views/compliments/random.html.erb)

Our view no longer displays `@compliment` (which used to be a string in stage-01), but `@compliment.message`. `message` is a string attribute of our `Compliment` model.

```html
<div class="compliment">
  <%= @compliment.message %>
</div>

<div class="actions">
  <a href="https://www.google.com/">Thanks! I feel better.</a>
  <a href="/compliments/random">I still feel crappy.</a>
</div>
```



### [stage-03: Database access with ActiveRecord](stage-03)

This stage how to persistently store data in a relational database.
Compliments are no longer constants in the `Compliment` model.
Instead we now store compliments in an SQLite database.


##### [`db/migrate/create_compliment.rb`](stage-03/db/migrate/20140120143812_create_compliment.rb)

A short database migration script that creates the `compliments` table and its columns.
This script is part of the project, so other developers, production servers, etc. automatically
receive our database changes together with our other code changes.

```ruby
class CreateCompliment < ActiveRecord::Migration

  def change
    create_table :compliments do |t|
      t.string :message
      t.timestamps
    end
  end

end
```


##### [`app/models/compliment.rb`](stage-03/app/models/compliment.rb)

Our model now inherits from `ActiveRecord::Base` and automatically becomes persistent
in the database (without any further code). We also added some code to populate
the database with default-compliments.

```ruby
class Compliment < ActiveRecord::Base

  def self.random
    Compliment.all.sample or create_default_compliments
  end

  def self.create_default_compliments
    Compliment.create!(message: "Your parents are more proud of you than you'll ever know.")
    Compliment.create!(message: "You actually looked super graceful that time you tripped in front of everyone.")
    Compliment.create!(message: "People at trivia night are terrified by you.")
    Compliment.create!(message: "You pick the best radio stations when you're riding shotgun.")
    Compliment.create!(message: "Your pet loves you too much to ever run away.")
  end

end
```



### [stage-04: ActiveRecord validations and form helpers](stage-04)

This stage shows how to work with forms. Forms are a basic building stone of web UI interaction.
We show how to validate user input and highlight errors in the form.
As an example we now allow users to submit their own compliments using a form. Submissions are stored
in the database (which we prepared in `stage-03`).


##### [`app/models/compliment.rb`](stage-04/app/models/compliment.rb)

Our model now *validates* that compliments have a message, and that we do not have duplicate messages (uniqueness).

```ruby
class Compliment < ActiveRecord::Base

  validates_presence_of :message
  validates_uniqueness_of :message

  def self.random
    Compliment.all.sample or create_default_compliments
  end

  def self.create_default_compliments
    Compliment.create!(message: "Your parents are more proud of you than you'll ever know.")
    Compliment.create!(message: "You actually looked super graceful that time you tripped in front of everyone.")
    Compliment.create!(message: "People at trivia night are terrified by you.")
    Compliment.create!(message: "You pick the best radio stations when you're riding shotgun.")
    Compliment.create!(message: "Your pet loves you too much to ever run away.")
  end

end
```


##### [`config/routes.rb`](stage-04/config/routes.rb)

We map two additional routes to two new controller actions: One to display the "New compliment" form,
one to process the form submisssion (and create the new `Compliment`).

```ruby
Nice::Application.routes.draw do

  get 'compliments/random' => 'compliments#random'

  get 'compliments/new' => 'compliments#new'
  post 'compliments/create' => 'compliments#create'

end
```

  
##### [`app/controllers/compliments_controller.rb`](stage-04/app/controllers/compliments_controller.rb)

Our controller gains two new actions. `#new` simply displays the "New compliment" form.
`#create` processes the form submission, validates the request and creates a new `Compliment`
if it passes validations.

```ruby
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
```


##### [`app/views/compliments/new.html.erb`](stage-04/app/views/compliments/new.html.erb)

The view which renders the "New compliment" form as HTML.

```html
<h1>New compliment</h1>

<%= form_for @compliment, url: '/compliments/create' do |form| %>

  <%= form.label :message %>

  <%= form.error_message_on :message %>

  <%= form.text_area :message, rows: 5 %>

  <%= form.submit 'Submit' %>

<% end %>
```


##### [`app/views/compliments/created.html.erb`](stage-04/app/views/compliments/created.html.erb)

The "thank you" page we render after a compliment was successfully created.

```html
<h1>Thank you!</h1>

<p>
  We received your compliment.
</p>

<div class="actions">
  <a href="/">Go back</a>
</div>
```

 
### [stage-05: ActiveRecord associations](stage-05)

This stage shows how ActiveRecord can be linked to each other using *associations*.
As an example we now allow users to rate compliments on a scale from zero to five stars.
For this we introduce a `Rating` model. A compliment can have many ratings.


##### [`db/migrate/create_rating.rb`](stage-05/db/migrate/20140120155543_create_rating.rb)

The database migration script to create our new `ratings` table and its columns.
Note how it uses a foreign key `compliment_id` to reference its associated compliment.

```ruby
class CreateRating < ActiveRecord::Migration

  def change

    create_table :ratings do |t|
      t.integer :compliment_id
      t.integer :stars
      t.timestamps
    end

    # Always add a database index for foreign keys to improve lookup speed.
    add_index :ratings, :compliment_id

  end

end
```


##### [`app/models/rating.rb`](stage-05/app/models/rating.rb)

We now have a second model `Rating`. It also has some validations.
It is linked to the `Compliment` model by saying `belongs_to :compliment`.

```ruby
class Rating < ActiveRecord::Base

  belongs_to :compliment
  validates_presence_of :compliment_id

  validates_inclusion_of :stars, in: 0..5

end
```


##### [`app/models/compliment.rb`](stage-05/app/models/compliment.rb)

Our `Compliment` model is now linked to the `Ratings` model by saying `has_many :ratings`.
It also gained methods to rate a method and to compute its average rating.

```ruby
class Compliment < ActiveRecord::Base

  validates_presence_of :message
  validates_uniqueness_of :message

  has_many :ratings

  def rate(stars)
    ratings.create!(:stars => stars)
  end

  def average_stars
    if ratings.any?
      stars = ratings.map { |rating| rating.stars }
      average = stars.sum.to_f / stars.size
      average.round(2) # round to 2 decimal places
    end
  end

  def self.random
    Compliment.all.sample or create_default_compliments
  end

  def self.create_default_compliments
    Compliment.create!(message: "Your parents are more proud of you than you'll ever know.")
    Compliment.create!(message: "You actually looked super graceful that time you tripped in front of everyone.")
    Compliment.create!(message: "People at trivia night are terrified by you.")
    Compliment.create!(message: "You pick the best radio stations when you're riding shotgun.")
    Compliment.create!(message: "Your pet loves you too much to ever run away.")
  end

end
```


##### [`config/routes.rb`](stage-05/config/routes.rb)

We added a more complex route to the controller endpoint that stores a new rating.
Note how it has an `:id` variable and a name `rate_compliment_path`.

```ruby
Nice::Application.routes.draw do

  get 'compliments/random' => 'compliments#random'

  get 'compliments/new' => 'compliments#new'
  post 'compliments/create' => 'compliments#create'

  post 'compliments/:id/rate' => 'compliments#rate', as: :rate_compliment

end
```


##### [`app/controllers/compliments_controller.rb`](stage-05/app/controllers/compliments_controller.rb)

Our controller gains a new action `rate` to save a new rating. Note how it processes `params` from the
URL to find the requested compliment in the database, then to store the requested `stars` value.
After it is done, it renders the compliment again.

```ruby
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
```

##### [`app/views/compliments/compliment.html.erb`](stage-05/app/views/compliments/compliment.html.erb)

We have renamed `random.html.erb` to `compliment.html.erb` because we now render
it from controller actions other than `#random`. Also it now contains links to
rate the shown compliment on a scale from zero to five stars. Note how we are using the
`link_to` and `rate_compliment_path` helpers to render a complicated HTML link.

```html
<div class="compliment">
  <%= @compliment.message %>
</div>

<div class="rating">

  <%= link_to '☆☆☆☆☆', rate_compliment_path(@compliment, :stars => 0), method: 'post' %>
  <%= link_to '★☆☆☆☆', rate_compliment_path(@compliment, :stars => 1), method: 'post' %>
  <%= link_to '★★☆☆☆', rate_compliment_path(@compliment, :stars => 2), method: 'post' %>
  <%= link_to '★★★☆☆', rate_compliment_path(@compliment, :stars => 3), method: 'post' %>
  <%= link_to '★★★★☆', rate_compliment_path(@compliment, :stars => 4), method: 'post' %>
  <%= link_to '★★★★★', rate_compliment_path(@compliment, :stars => 5), method: 'post' %>

  <span class="average">
    <%= @compliment.average_stars %>
  </span>

</div>

<div class="actions">
  <a href="https://www.google.com/">Thanks! I feel better.</a>
  <a href="/compliments/random">I still feel crappy.</a>
  <a href="/compliments/new">Add a compliment</a>
</div>
```


### [stage-06: Test-driven development](stage-06)

This stage shows how to verify the *You Look Nice Today* application using
automated software tests. We show two different kinds of tests: Unit tests (using RSpec)
and full-stack integration tests (using Cucumber).

If you have [checked out and installed](#how-to-run-the-example-applications) the example applications
you can run those tests by using these commands from the project directory (`stage-06`):

    rspec
    cucumber


##### [`spec/models/compliment_spec.rb`](stage-06/spec/models/compliment_spec.rb)

A unit test that verifies that the `Compliment` model correctly stores and averages user ratings.

```ruby
require 'spec_helper'

describe Compliment do

  describe '#average_stars' do

    it 'should be nil if there are no ratings' do
      compliment = Compliment.create!(:message => "Your pet loves you too much to ever run away.")
      compliment.average_stars.should be_nil
    end

  end

  describe '#rate' do

    it 'should update the average rating' do
      compliment = Compliment.create!(:message => "Your pet loves you too much to ever run away.")
      compliment.rate(5)
      compliment.average_stars.should == 5.0
      compliment.rate(1)
      compliment.average_stars.should == 3.0
    end

  end

end
```


##### [`features/compliments.feature`](stage-06/features/compliments.feature)

A full-stack integration test that verifies our user interface by *actually using it* with a scripted
Firefox browser. Even though that test reads like natural language, it is executable code.

```cucumber
Feature: Compliments

  Scenario: User draws random compliments until she feels better
    Given my random generator is predictable
    When I go to a random compliment
    Then I should see "Your pet loves you too much to ever run away"
    When I follow "I still feel crappy"
    Then I should see "People at trivia night are terrified by you"
    When I follow "I still feel crappy"
    Then I should see "You pick the best radio stations when you're riding shotgun"

  Scenario: User submits a new compliment
    When I go to a random compliment
    And I follow "Add a compliment"
    Then the screen should be titled "New compliment"
    When I press "Submit"
    Then I should see an error message
    When I fill in "Message" with "You're the best at making cereal."
    And I press "Submit"
    Then I should see "We received your compliment"
```


##### [`features/step_definitions/compliment_steps.rb`](stage-06/features/step_definitions/compliment_steps.rb)

Step definitions like that map the natural language from `compliments.feature` to Ruby code.

```ruby
Given /^my random generator is predictable$/ do
  # Initialize the random generator with a fixed seed.
  # This way we will get a predictable series of random values
  # for this process.
  Compliment.random_generator = Random.new(239842439)
end
```


##### More about tests:
  
For further material on tests check out our [crash course (German)](http://www.makandra.de/malennachzahlen/kurs/) and [TDD talk (English)](http://tdd.talks.makandra.com/).


How to run the example applications
-----------------------------------

1. Install Ruby. See the [official installation instructions](http://www.ruby-lang.org/en/installation#rvm).
   If you're on Linux or OS X we recommend [RVM](http://rvm.io/). If you're on Windows we recommend
   [Ruby Installer](http://rubyinstaller.org/).

2. Copy this repository to your hard drive. You can use Git or simply [download as ZIP](https://github.com/makandra/nice/archive/master.zip).

3. You can now `cd` into each stage folder, install dependencies and start a Rails server:

        cd stage-01
        bundle
        rails server

4. You can now access the application under <http://localhost:3000>.

5. Once you're done (or want to switch to a different stage), press `CTRL+C` inside your server terminal to stop your server.

