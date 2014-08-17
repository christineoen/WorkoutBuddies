module WorkoutBuddies
  class User
    attr_accessor :user_id, :display_name, :address, :zip, :email, :phone, :refresh_token, :activities, :activity_ids, :password_digest, :profile_pic

    def initialize(data = {})
      @user_id = data['user_id']
      @display_name = data['display_name']
      @address = data['address']
      @zip = data['zip']
      @email = data['email']
      @phone = data['phone']
      @profile_pic = data['profile_pic']
      @password_digest = data['password_digest']
      @activity_ids = []
      @activities = []
    end

    def update_password(password)
      @password_digest = Digest::SHA1.hexdigest(password)
    end

    def has_password?(password)
      Digest::SHA1.hexdigest(password) == @password_digest
    end

    def update_user_id(user_id)
      @user_id = user_id
    end

    def set_profile_pic
      hash = Digest::MD5.hexdigest(@email)
      @profile_pic = "http://www.gravatar.com/avatar/#{hash}"
    end


  end

end