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
          phone varchar(30)
          created_at timestamp NOT NULL DEFAULT current_timestamp
          )])
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS activities(
          activity_id serial NOT NULL PRIMARY KEY,
          activity_name text
          )])
      @db.exec(%q[
        CREATE TABLE IF NOT EXISTS matching(
          id serial NOT NULL PRIMARY KEY
          activity_id integer REFERENCES activities(activity_id),
          user_id integer REFERENCES users(user_id)
          )])
    end

    #### USERS ####
 
    def register_user(user)
        @db.exec_params(%q[
        INSERT INTO users (username, password_digest)
        VALUES ($1, $2);
        ], [user.username, user.password_digest])
    end
 
    def get_user_by_username(username)
      result = @db.exec(%Q[
        SELECT *
        FROM users
        WHERE username = '#{username}';
      ])
 
      user_data = result.first
 
      if user_data
        build_user(user_data)
      else
        nil
      end
    end
 
    def username_exists?(username)
      result = @db.exec(%Q[
        SELECT *
        FROM users
        WHERE username = $1;
      ], [username])
 
      if result.count > 0
        true
      else
        false
      end
    end
 
    def build_user(data)
      RPS::User.new(data['username'], data['password_digest'])
    end


    #####  ACTIVITIES  #####

    



  # end of dbi class
  end


# singleton creation
  def self.dbi
    @__db_instance ||= DBI.new
  end
end
