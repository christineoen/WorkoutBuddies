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

get '/profile1' do
  erb :profile
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
    @user = WorkoutBuddies::DBI.dbi.get_user_by_id(session['workout_buddies'])
    user_zip = @user.zip
    ##run something through google maps api to find nearest zip codes to user_zip
    ## OR this Zip Code Api -- Catherine has a registered API key
    ##FOR NOW THE CHEAT IS A LIST OF AUSTIN ZIP CODES
    zipcode_array = [73301, 73344, 78701, 78702, 78703, 78704, 78705, 78708, 78709, 78710, 78711, 78712, 78713, 78714, 78715, 78716, 78717, 78718, 78719, 78720, 78721, 78722, 78723, 78724, 78725, 78726, 78727, 78728, 78729, 78730, 78731, 78732, 78733, 78734, 78735, 78736, 78737, 78738, 78739, 78741, 78742, 78744, 78745, 78746, 78747, 78748, 78749, 78750, 78751, 78752, 78753, 78754, 78755, 78756, 78757, 78758, 78759, 78760, 78761, 78762, 78763, 78764, 78765, 78766, 78767, 78768, 78769, 78772, 78773, 78774, 78778, 78779, 78780, 78781, 78783, 78785, 78786, 78788, 78789, 78798, 78799]
    activity_array =  get_activity_ids_by_user_id(session['workout_buddies'])
    @buddies = get_buddy_data(zipcode_array, activity_array)
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
    ## OR this Zip Code Api -- Catherine has a registered API key
    ##FOR NOW THE CHEAT IS A LIST OF AUSTIN ZIP CODES
    zipcode_array = [73301, 73344, 78701, 78702, 78703, 78704, 78705, 78708, 78709, 78710, 78711, 78712, 78713, 78714, 78715, 78716, 78717, 78718, 78719, 78720, 78721, 78722, 78723, 78724, 78725, 78726, 78727, 78728, 78729, 78730, 78731, 78732, 78733, 78734, 78735, 78736, 78737, 78738, 78739, 78741, 78742, 78744, 78745, 78746, 78747, 78748, 78749, 78750, 78751, 78752, 78753, 78754, 78755, 78756, 78757, 78758, 78759, 78760, 78761, 78762, 78763, 78764, 78765, 78766, 78767, 78768, 78769, 78772, 78773, 78774, 78778, 78779, 78780, 78781, 78783, 78785, 78786, 78788, 78789, 78798, 78799]
    activity_array =  get_activity_ids_by_user_id(session['workout_buddies'])
    get_events(zipcode_array, activity_array) 
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







