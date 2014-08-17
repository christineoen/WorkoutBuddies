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
          event_description text,
          address text,
          zip integer,
          user_id integer REFERENCES users(user_id),
          activity_id integer REFERENCES activities(activity_id),
          created_at timestamp NOT NULL DEFAULT current_timestamp
          )])
    end

    ##### USERS #####
 
 
    def build_user(data)
      WorkoutBuddies::User.new(data)
    end

    def persist_user(user)
      @db.exec_params(%q[
        INSERT INTO users (email, display_name, password, profile_pic, address, zip)
        VALUES ($1, $2, $3, $4, $5, $6);
      ], [user.email, user.display_name, user.password_digest, user.profile_pic, user.address, user.zip])
    end

    def get_user_id(user)
      result = @db.exec_params(%q[
        SELECT user_id from users
        WHERE email = $1;
        ], [user.email])

      return result.first['user_id'].to_i
    end

    def get_user_by_id(user_id)
      result = @db.exec_params(%Q[
        SELECT * FROM users
        WHERE user_id = $1;
      ], [user_id])

      return result.first
    end

    def get_user_name_by_id(user_id)
      result = @db.exec_params(%Q[
        SELECT display_name FROM users
        WHERE user_id = $1;
      ], [user_id])

      return result.first
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
        SELECT * FROM matching
        WHERE activity_id = $1;
        ], [activity_id])

        result.map{|user_id| get_user_by_id_and_zip(user_id['user_id'], zip)}
    end

    def get_activity_ids_by_user_id(user_id)
      result = @db.exec_params(%q[
        SELECT activity_id FROM matching
        WHERE user_id = $1;
        ], [user_id])

      result.map{|row| row['activity_id']}
    end

    def get_activity_name_by_id(activity_id)
        result = @db.exec_params(%Q[
        SELECT activity_name FROM activities
        WHERE activity_id = $1;
      ], [activity_id])

      return result.first    
    end


    #####  EVENTS  #####

    def build_event(data)
      WorkoutBuddies::Event.new(data)
    end

    def persist_event(event)
      @db.exec_params(%q[
        INSERT INTO events (event_name, event_description, address, zip, activity_id)
        VALUES ($1, $2, $3, $4, $5);
      ], [event.event_name, event.event_description, event.address, event.zip, event.activity_id])
    end

    def get_events(zip_array, activity_array)
      zip_string = "(#{zip_array.join(", ")})"
      activity_string = "(#{activity_array.join(", ")})" 
      result = @db.exec(
        "SELECT * FROM events 
        WHERE activity_id IN #{activity_string} AND zip IN #{zip_string}")
      result.map do |row|
        name = get_user_name_by_id(row['user_id'])
        activity = get_activity_name_by_id(row['activity_id'])
        {event_id: row['event_id'], event_name: row['event_name'], address: row['address'], zip: row['zip'], creator: name, activity: activity, description: row['event_description']}
      end
    end

    ###### BUDDIES #####

    def get_buddy_data(zip_array, activity_array)
      zip_string = "(#{zip_array.join(", ")})"
      activity_string = "(#{activity_array.join(", ")})"
      result = @db.exec(
        "SELECT * FROM users
        WHERE activity_id IN #{activity_string} AND zip IN #{zip_string}")
      result.map do |row|
        this_user_id = row["user_id"].to_i
        {user_id: this_user_id, display_name: row['displayname'], profile_pic: row['profile_pic'], zip: row['zip']}
      end
    end
  
  # singleton creation
    def self.dbi
      @__db_instance ||= DBI.new
    end

  # end of dbi class
  end


end
