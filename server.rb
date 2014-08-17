require 'sinatra'
require 'rack-flash'
require 'pry-byebug'

require_relative 'lib/workoutbuddies.rb'

set :sessions, true
use Rack::Flash
set :bind, '0.0.0.0' # Vagrant fix
set :port, '4567'

get '/home' do
  @user = WorkoutBuddies::DBI.dbi.get_user_by_id(session['workout_buddies'])
  @user_zip = @user.zip
  zipcode_array = [73301, 73344, 78701, 78702, 78703, 78704, 78705, 78708, 78709, 78710, 78711, 78712, 78713, 78714, 78715, 78716, 78717, 78718, 78719, 78720, 78721, 78722, 78723, 78724, 78725, 78726, 78727, 78728, 78729, 78730, 78731, 78732, 78733, 78734, 78735, 78736, 78737, 78738, 78739, 78741, 78742, 78744, 78745, 78746, 78747, 78748, 78749, 78750, 78751, 78752, 78753, 78754, 78755, 78756, 78757, 78758, 78759, 78760, 78761, 78762, 78763, 78764, 78765, 78766, 78767, 78768, 78769, 78772, 78773, 78774, 78778, 78779, 78780, 78781, 78783, 78785, 78786, 78788, 78789, 78798, 78799]
  activity_array =  WorkoutBuddies::DBI.dbi.get_activity_ids_by_user_id(session['workout_buddies'])
  # @buddies = WorkoutBuddies::DBI.dbi.get_buddy_data(zipcode_array, activity_array)
  # @events = WorkoutBuddies::DBI.dbi.get_events(zipcode_array, activity_array)
  erb :home
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
    zipcode_array = [73301, 73344, 78701, 78702, 78703, 78704, 78705, 78708, 78709, 78710, 78711, 78712, 78713, 78714, 78715, 78716, 78717, 78718, 78719, 78720, 78721, 78722, 78723, 78724, 78725, 78726, 78727, 78728, 78729, 78730, 78731, 78732, 78733, 78734, 78735, 78736, 78737, 78738, 78739, 78741, 78742, 78744, 78745, 78746, 78747, 78748, 78749, 78750, 78751, 78752, 78753, 78754, 78755, 78756, 78757, 78758, 78759, 78760, 78761, 78762, 78763, 78764, 78765, 78766, 78767, 78768, 78769, 78772, 78773, 78774, 78778, 78779, 78780, 78781, 78783, 78785, 78786, 78788, 78789, 78798, 78799]
    activity_array =  WorkoutBuddies::DBI.dbi.get_activity_ids_by_user_id(session['workout_buddies'])
    @buddies = WorkoutBuddies::DBI.dbi.get_buddy_data(zipcode_array, activity_array)
    erb :buddies
  else #not in session
    erb :index
  end
end

get '/create_event' do
  if session['workout_buddies']
    ##SOME STUFF
    # redirect to where?

    erb :create_event
  else #not in session
    erb :index
  end
end

post '/create_event' do

  event = WorkoutBuddies::Event.new(params)
  event.user_id = session['workout_buddies']
  WorkoutBuddies::DBI.dbi.persist_event(event)

  redirect to '/home'
end

get '/events' do
  if session['workout_buddies']
    @user = WorkoutBuddies::DBI.dbi.get_user_by_id(session['workout_buddies'])
    user_zip = @user.zip
    ##run something through google maps api to find nearest zip codes to user_zip
    ## OR this Zip Code Api -- Catherine has a registered API key
    ##FOR NOW THE CHEAT IS A LIST OF AUSTIN ZIP CODES
    zipcode_array = [73301, 73344, 78701, 78702, 78703, 78704, 78705, 78708, 78709, 78710, 78711, 78712, 78713, 78714, 78715, 78716, 78717, 78718, 78719, 78720, 78721, 78722, 78723, 78724, 78725, 78726, 78727, 78728, 78729, 78730, 78731, 78732, 78733, 78734, 78735, 78736, 78737, 78738, 78739, 78741, 78742, 78744, 78745, 78746, 78747, 78748, 78749, 78750, 78751, 78752, 78753, 78754, 78755, 78756, 78757, 78758, 78759, 78760, 78761, 78762, 78763, 78764, 78765, 78766, 78767, 78768, 78769, 78772, 78773, 78774, 78778, 78779, 78780, 78781, 78783, 78785, 78786, 78788, 78789, 78798, 78799]
    activity_array =  WorkoutBuddies::DBI.dbi.get_activity_ids_by_user_id(session['workout_buddies'])
    @events = WorkoutBuddies::DBI.dbi.get_events(zipcode_array, activity_array)
    p @events
    erb :events
  else #not in session
    erb :index
  end
end

get '/signin' do
  if session['workout_buddies']
    redirect to '/home'
  else #not in session
    erb :signin
  end
end

post '/signin' do
  sign_in = WorkoutBuddies::SignIn.run(params)

  if sign_in[:success?]
    session['workout_buddies'] = sign_in[:session_id]
    redirect to '/home'
  else
    flash.now[:alert] = sign_in[:error]
    redirect to '/signin'
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  sign_up = WorkoutBuddies::SignUp.run(params)

  if sign_up[:success?]
    session['workout_buddies'] = sign_up[:session_id]
    redirect to '/home'
  else
    flash.now[:alert] = sign_up[:error]
    redirect to '/signup'
  end
end

get '/signout' do
 session.clear
 redirect to '/'
end






