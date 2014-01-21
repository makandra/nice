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
As we move along the stages, we add more and more functionality.

### [stage-01: Hello world](stage-01)
This stage shows a very simple Rails application with a single route, a single controller and no model.

#### Noteworthy files:

[`routes.rb`](stage-01/config/routes.rb)
: Our routes setup file. This maps incoming browser requests to controller actions.
[`compliments_controller.rb`](stage-01/app/controllers/compliments_controller.rb)
: Our one and only controller. It fetches a compliment and puts it into an instance variable `@compliment`.



[stage-02: Model / View / Controller interaction](stage-02)
: Moves controller code into a Ruby model `Compliment`

[stage-03: Database access with ActiveRecord](stage-03)
: Moves compliments into the database.

[stage-04: ActiveRecord validations and form helpers](stage-04)
: You can now submit your own compliments.

[stage-05: ActiveRecord associations](stage-05)
: Introduces ratings for compliments.

[stage-06: Test-driven development](stage-06)
: Introduces Cucumber tests and RSpec tests for the functionality above.


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

