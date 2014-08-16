module WorkoutBuddies
  class User
    attr_accessor :user_id, :displayname, :address, :zip, :email, :phone, :gogole_info, :activities, :activity_ids

    def initialize(data = {})
      @user_id = data['user_id']
      @displayname = data['username']
      @address = data['address']
      @zip = data['zip']
      @email = data['email']
      @phone = data['phone']
      @google_info = data['google_info']
      @activity_ids = []
      @activities = []
    end

  end
end