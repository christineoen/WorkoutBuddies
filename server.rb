require 'sinatra'
require 'rack-flash'
require 'pry-byebug'

require_relative 'lib/workoutbuddies.rb'

set :bind, '0.0.0.0' # Vagrant fix
set :port, '4567'


get '/index1' do
  erb :index
end

get '/create_event1' do
  erb :create_event
end

get '/buddies1' do
  erb :buddies
end

get '/events1' do
  erb :events
end

get '/home1' do
  erb :home
end


