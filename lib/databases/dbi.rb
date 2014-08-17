require 'pg'
require 'pry-byebug'
 
module WorkoutBuddies
  class DBI
    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'WorkoutBuddies')
      build_tables
    end
 
    def build_tables
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS users(
          user_id serial NOT NULL PRIMARY KEY,
          display_name text,
          password text,
          address text,
          zip integer,
          email text,
          phone varchar(30),
          profile_pic text,
          created_at timestamp NOT NULL DEFAULT current_timestamp
          )])
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS activities(
          activity_id serial NOT NULL PRIMARY KEY,
          activity_name text
          )])
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS matching(
          id serial NOT NULL PRIMARY KEY,
          activity_id integer REFERENCES activities(activity_id),
          user_id integer REFERENCES users(user_id)
          )])
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS events(
          event_id serial NOT NULL PRIMARY KEY,
          event_name text,
          address text,
          zip integer,
          user_id integer REFERENCES users(user_id),
          created_at timestamp NOT NULL DEFAULT current_timestamp
          )])
    end

    ##### USERS #####
 
 
    def build_user(data)
      WorkoutBuddies::User.new(data)
    end

    def persist_user(user)
      @db.exec_params(%q[
        INSERT INTO users (email, display_name, password, profile_pic)
        VALUES ($1, $2, $3, $4);
      ], [user.email, user.display_name, user.password_digest, user.profile_pic])
    end

    def get_user_id(user)
      result = @db.exec_params(%q[
        SELECT user_id from users
        WHERE email = $1;
        ], [user.email])

      return result.first['user_id'].to_i
    end

    def get_user_by_id_and_zip(user_id, zip)
      result = @db.exec_params(%Q[
        SELECT * FROM users
        WHERE user_id = $1
        AND zip = $2;
      ], [user_id, zip])

      return result.first
    
    end

    def get_user_by_email(email)
      result = @db.exec(%q[
        SELECT * FROM users 
        WHERE email = $1;
      ],[email])

      user_data = result.first

      if user_data
        build_user(user_data)
      else
        nil
      end
    end

    def email_exists?(email)
      result = @db.exec(%Q[
        SELECT *
        FROM users
        WHERE email = $1;
      ], [email])
    
      if result.count > 0
        true
      else
        false
      end
    end


    #####  ACTIVITY MATCHING  #####

    def get_users_by_activity_id(activity_id, zip)
      result = @db.exec_params(%q[
        SELECT user_id FROM matching
        WHERE activity_id = $1;
        ], [activity_id])

        result.map{|user_id| get_user_by_id(user_id['user_id'], zip)}
    end



    #####  EVENTS  #####

    def build_event(data)
      WorkoutBuddies::Event.new(data)
    end

    def get_events_by_zip(zip)
      result = @db.exec_params(%q[
        SELECT * FROM events
        WHERE zip = $1;
        ], [zip])

      result.map {|row| build_event(row)}
    end

    ###### BUDDIES #####

    def get_buddy_data(user_id)

    end

  # end of dbi class
  end


# singleton creation
  def self.dbi
    @__db_instance ||= DBI.new
  end
end
