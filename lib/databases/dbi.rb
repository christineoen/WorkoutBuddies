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

    #### USERS ####
 
 
    def build_user(data)
      RPS::User.new(data)
    end


    #####  ACTIVITIES  #####





  # end of dbi class
  end


# singleton creation
  def self.dbi
    @__db_instance ||= DBI.new
  end
end
