require 'sinatra'
require "sinatra/json"
require 'rack-flash'
require 'pry-byebug'
require_relative 'lib/workoutbuddies.rb'

set :bind, '0.0.0.0' # Vagrant fix
set :port, '4567'
set :sessions, true
use Rack::Flash