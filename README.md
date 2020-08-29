# README

This README would normally document whatever steps are necessary to get the
application up and running. Please take a fork of the Application or clone it and run the below commands to play around.

Things you may want to cover:

* Ruby version

ruby-2.6.3

Rails version: Rails 6.0.3.2

* Configuration

* Database creation

Please have a local database ready and update your config/database.yml to point to a database(mysql). 
As of now Gemfile has mysql. 

Stpes for App initialization

* bundle install

* rails db:migrate

* rails db:seed

* rails s

Once the above puma server is started, Check out the REST api documentation at http://localhost:3000/api-docs

I have also exposed graphql api (only query) to get a user its contacts and its transactions(pagination supported). Do check out the graphql signature of 
"user" query in a graphql Client. I have been using Altair graphql Client which is pretty easy to use and play around. 
This rails app does not have graphiql as I created the rails app in only --api Mode. 
