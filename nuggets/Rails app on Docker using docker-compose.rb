mkdir ~/projects/noteapp
cd ~/projects/noteapp
# Create Gemfile
# Create empty Gemfile.lock file
# Create Dockerfile
# Create docker-compose.yml

# will create rails application directoty structure in current directory, we have db and app in container
docker-compose run app rails new . --force --database=mysql --skip-bundle 
#"app" is the service defined in docker-compose, followed by command to create rails 

# update config/database.yml file  - set env variables for database access by app


docker-compose build  --> build an image for app
docker-compose up
# http://localhost:3001
dcoker-compose ps --> to check staus of services
docker-compose run --rm app rails g scaffold note title body:text
docker-compose run --rm app rake db:migrate
# http://localhost:3001/notes

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Create Gemfile
vi Gemfile
source 'https://rubygems.org'
gem 'rails', '~> 5.0.0'default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  database: <%= ENV['DB_NAME'] %>
  username: <%= ENV['DB_USER'] %>
  password: <%= ENV['DB_PASSWORD'] %>
  host: <%= ENV['DB_HOST'] %>

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default

# Create empty Gemfile.lock --> need  to run bundle inside docker
touch Gemfile.lock

# Create Dockerfile
vi Dockerfile
FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /railsapp
WORKDIR /railsapp
ADD Gemfile /railsapp/Gemfile
ADD Gemfile.lock /railsapp/Gemfile.lock
RUN bundle install
ADD . /railsapp

# Create docker-compose.yml
version: '2'
services:
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: railsapp
      MYSQL_USER: appuser
      MYSQL_PASSWORD: password
    ports:
      - "3307:3306"
  app:
    build: . 
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - ".:/railsapp" # map in host where i make changes, to where it executes in container
    ports:
      - "3001:3000"
    depends_on:
      - db  # when you have app service , db service should also run
    links:
      - db  # app application can connect to db using "db" hostname
    environment:
      DB_USER: root
      DB_NAME: railsapp
      DB_PASSWORD: password
      DB_HOST: db

#config/database.yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  database: <%= ENV['DB_NAME'] %>
  username: <%= ENV['DB_USER'] %>
  password: <%= ENV['DB_PASSWORD'] %>
  host: <%= ENV['DB_HOST'] %>

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default

