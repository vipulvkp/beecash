# README

This README would normally document whatever steps are necessary to get the
application up and running. Please take a fork of the Application or clone it and run the below commands to play around.

Things you may want to cover:

* Ruby version

ruby-2.6.3


* System dependencies
Rails version: Rails 6.0.3.2

* Configuration

* Database creation

Please have a local database ready and update your config/database.yml to point to a database(mysql). 
As of now Gemfile has mysql. 

* App initialization

bundle install
rails db:migrate
rails db:seed
rails s

Once the above puma server is started, Check out the api documentation at http://localhost:3000/api-docs
