module WorkoutBuddies
  class Event
    attr_accessor :event_id, :event_name, :address, :zip, :user_id, :event_description, :activity_id

    def initialize(data = {})
      @event_id = data['event_id']
      @event_name = data['event_name']
      @event_description = data['event_description']
      @address = data['address']
      @zip = data['zip']
      @user_id = data['user_id']
      @activity_id = data['activity_id']
    end

  end
end