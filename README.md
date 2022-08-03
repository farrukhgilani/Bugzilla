# README

## Bugzilla is a bug tracking project

Prerequisites

Setups following tools on the system
* Github
* Ruby 2.7.2
* Rails 5.2.8.1

### Run Following commands

* bundle install
(to install all gems all groups in your Gemfile)

Run the following commands to create and setup the database.
* rails db:setup

After database setup you can start the rails server using the following command
* rails s

In this project following gems that are add:

* gem 'bootstrap', '~> 4.0.0'
* gem 'devise'
* gem 'jquery-rails'
* gem 'kaminari'
* gem 'pg'
* gem 'pundit'

We added Devise gem into Project
* rails g devise:install
* rails g devise User
* rails g devise:views

Pundit gem is used for authorization policies
* rails g pundit:install

Activestorage is used for image upload

Added User types and edit model and view of the devise

Created Project Model, view and controller
Created Bug Model and controller

Add Bug as Project has many Bugs make
Authorize the user based on the roles, we used pundit for this and made policies for roles
