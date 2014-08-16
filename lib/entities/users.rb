module WorkoutBuddies
  class User
    attr_accessor :user_id, :display_name, :address, :zip, :email, :phone, :refresh_token, :activities, :activity_ids

    def initialize(data = {})
      @user_id = data['user_id']
      @display_name = data['display_name']
      @address = data['address']
      @zip = data['zip']
      @email = data['email']
      @phone = data['phone']
      @refresh_token = data['refresh_token']
      @activity_ids = []
      @activities = []
    end

  end

end