You Look Nice Today
===================

A sample application for our Rails workshop
-------------------------------------------

This is the demo application for our [Rails Workshop](http://railsworkshop.makandra.de), a yearly event
held by [makandra](http://www.makandra.com/) to tell students about
the [Ruby on Rails](http://rubyonrails.org/) framework and test-driven development.

The application was inspired by the wonderful [emergency compliment](http://emergencycompliment.com/) service.
You should make that website your homepage and buy [all their prints](http://society6.com/emergencycompliment).


How to explore this repository
------------------------------

This repository contains the **same application multiple times**, in different stages of development.
As we move along the stages, we add more and more functionality:

Below you can find a list of the various stages, with links to the most important files in each stage.


### [stage-01: Hello world](stage-01)

This stage shows a very simple Rails application with a single route, a single controller and no model.

#### Noteworthy files:

[`routes.rb`](stage-01/config/routes.rb)
: Our routes setup file. This maps incoming browser requests to controller actions.

[`compliments_controller.rb`](stage-01/app/controllers/compliments_controller.rb)
: Our one and only controller. It fetches a compliment and puts it into an instance variable `@compliment`.

[`random.html.erb`](stage-01/app/views/compliments/random.html.erb)
: Our one and only view. It takes the `@compliment` variable that was prepared by the controller and renders it on a HTML page.


### [stage-02: Model / View / Controller interaction](stage-02)

This stage shows MVC-style separation of concerns. The controller no longer does all the work.
Instead the controller merely *orchestrates* the collaboration between view and model.
To do that the code that was previously found in `ComplimentsController` is moved to a Ruby model `Compliment`.

##### Noteworthy files:

[`compliment.rb`](stage-02/app/models/compliment.rb)
: This model takes over the job of drawing a random compliment.

[`compliments_controller.rb`](stage-02/app/controllers/compliments_controller.rb)
: Now that the model does most of the work, our controller becomes very short. That's the way it should be!

[`random.html.erb`](stage-02/app/views/compliments/random.html.erb)
: Our view no longer displays `@compliment` (which used to be a string in stage-01), but `@compliment.message`. `message` is a string attribute of our `Compliment` model.


### [stage-03: Database access with ActiveRecord](stage-03)

This stage how to persistently store data in a relational database.
Compliments are no longer constants in the `Compliment` model.
Instead we now store compliments in an SQLite database.

##### Noteworthy files:

[`create_compliment.rb`](stage-03/db/migrate/20140120143812_create_compliment.rb)
: A short database migration script that creates the `compliments` table and its columns.
  This script is part of the project, so other developers, production servers, etc. automatically
  receive our database changes together with our other code changes.

[`compliment.rb`](stage-03/app/models/compliment.rb)
: Our model now inherits from `ActiveRecord::Base` and automatically becomes persistent in the database without
  any further code. We also added some code to populate the database with default-compliments.


### [stage-04: ActiveRecord validations and form helpers](stage-04)

This stage shows how to work with forms. Forms are a basic building stone of web UI interaction.
We show how to validate user input and highlight errors in the form.
As an example we now allow users to submit their own compliments using a form. Submissions are stored
in the database (which we prepared in `stage-03`).

##### Noteworthy files:

[`compliment.rb`](stage-04/app/models/compliment.rb)
: Our model now *validates* that compliments have a message, and that we do not have duplicate messages (uniqueness).

[`routes.rb`](stage-04/config/routes.rb)
: We map two additional routes to two new controller actions: One to display the "New compliment" form,
  one to process the form submisssion (and create the new `Compliment`).
  
[`compliments_controller.rb`](stage-04/app/controllers/compliments_controller.rb)
: Our controller gains two new actions. `#new` simply displays the "New compliment" form.
  `#create` processes the form submission, validates the request and creates a new `Compliment`
  if it passes validations.

[`new.html.erb`](stage-04/app/views/compliments/new.html.erb)
: The view which renders the "New compliment" form as HTML.

[`created.html.erb`](stage-04/app/views/compliments/created.html.erb)
: The "thank you" page we render after a compliment was successfully created.

 
### [stage-05: ActiveRecord associations](stage-05)

This stage shows how ActiveRecord can be linked to each other using *associations*.
As an example we now allow users to rate compliments on a scale from zero to five stars.
For this we introduce a `Rating` model. A compliment can have many ratings.

##### Noteworthy files:

[`create_rating.rb`](stage-05/db/migrate/20140120155543_create_rating.rb)
: The database migration script to create our new `ratings` table and its columns.
  Note how it uses a foreign key `compliment_id` to reference its associated compliment.

[`rating.rb`](stage-05/app/models/rating.rb)
: We now have a second model `Rating`. It also has some validations. It is linked to the
  `Compliment` model by saying `belongs_to :compliment`.

[`compliment.rb`](stage-05/app/models/compliment.rb)
: Our `Compliment` model is now linked to the `Ratings` model by saying `has_many :ratings`.
  It also gained methods to rate a method and to compute its average rating.

[`routes.rb`](stage-05/config/routes.rb)
: We added a more complex route to the controller endpoint that stores a new rating.
  Note how it has an `:id` variable and a name `rate_compliment_path`.

[`compliments_controller.rb`](stage-05/app/controllers/compliments_controller.rb)
: Our controller gains a new action to save a new rating. Note how it processes `params` from the
  URL to find the requested compliment in the database, then to store the requested `stars` value.
  After it is done, it renders the compliment again.
  
[`compliment.html.erb`](stage-05/app/views/compliments/compliment.html.erb)
: We have renamed `random.html.erb` to `compliment.html.erb` because we now render
  it from controller actions other than `#random`. Also it now contains links to
  rate the shown compliment on a scale from zero to five stars. Note how we are using the `link_to` and
  `rate_compliment_path` helpers to render a complicated HTML link.


### [stage-06: Test-driven development](stage-06)

This stage shows how to verify the *You Look Nice Today* application using
automated software tests. We show two different kinds of tests: Unit tests (using RSpec)
and full-stack integration tests (using Cucumber).

If you have [checked out and installed](#how-to-run-the-example-applications) the example applications
you can run those tests by using these commands from the project directory (`stage-06`):

    rspec
    cucumber


##### Noteworthy files:

[`compliment_spec.rb`](stage-06/spec/models/compliment_spec.rb)
: A unit test that verifies that the `Compliment` model correctly stores and averages user ratings.

[`compliments.feature`](stage-06/features/compliments.feature)
: A full-stack integration test that verifies our user interface by *actually using it* with a scripted
  Firefox browser. Even though that test reads like natural language, it is executable code.
  
[`compliment_steps.rb`](stage-06/features/step_definitions/compliment_steps.rb)
: Step definitions like that map the natural language from `compliments.feature` to Ruby code.


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

