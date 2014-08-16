module WorkoutBuddies
  class Event
    attr_accessor :event_id, :event_name, :address, :zip, :user_id

    def initialize(data = {})
      @event_id = data['event_id']
      @event_name = data['event_name']
      @address = data['address']
      @zip = data['zip']
      @user_id = data['user_id']
    end

  end
end