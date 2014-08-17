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

get '/home' do
  erb :home
  @user = WorkoutBuddies::DBI.dbi.get_user_by_id(session['workout_buddies'])
  @buddies = WorkoutBuddies::DBI.dbi.get_buddy_data(session['workout_buddies'])    
  ##NEED to WRITE THIS AND the table for buddy matches and the  method in the DBI
  user_zip = @user.zip
    ##run something through google maps api to find nearest zip codes to user_zip
    ##then run the get events by zip for each zip
  @events = []
  zipcodes.each do |zip|
    events_by_zip = WorkoutBuddies::DBI.dbi.get_events_by_zip(zip)
    events = events + events_by_zip
  end
end

get '/' do
  if session['workout_buddies']
    @user = WorkoutBuddies::DBI.dbi.get_user_by_id(session['workout_buddies'])
    erb :home
  else #not in session
    erb :index
  end
end

get '/buddies' do
  if session['workout_buddies']
    @buddies = WorkoutBuddies::DBI.dbi.get_buddy_data(session['workout_buddies'])    
    ##NEED to WRITE THIS AND the table for buddy matches and the  method in the DBI
    erb :buddies
  else #not in session
    erb :index
  end
end

get '/create_event' do
  if session['workout_buddies']
    ##SOME STUFF
    # redirect to where?
  else #not in session
    erb :index
  end
end

get '/events' do
  if session['workout_buddies']
    @user = WorkoutBuddies::DBI.dbi.get_user_by_id(session['workout_buddies'])
    user_zip = @user.zip
    ##run something through google maps api to find nearest zip codes to user_zip
    ##then run the get events by zip for each zip
    @events = []
    zipcodes.each do |zip|
      events_by_zip = WorkoutBuddies::DBI.dbi.get_events_by_zip(zip)
      events = events + events_by_zip
    end
    erb :events
  else #not in session
    erb :index
  end
end

get '/login' do
  if session['workout_buddies']
    erb :home
  else #not in session
    erb :login
  end
end

post '/login' do
  sign_in = WorkoutBuddies::SignIn.run(params)

  if sign_in[:success?]
    session['workout_buddies'] = sign_in[:session_id]
    redirect to '/'
  else
    flash.now[:alert] = sign_in[:error]
    redirect to '/login'
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  sign_up = WorkoutBuddies::SignUp.run(params)

  if sign_up[:success?]
    session['workout_buddies'] = sign_up[:session_id]
    redirect to '/'
  else
    flash.now[:alert] = sign_up[:error]
    redirect to '/sign_up'
  end
end







