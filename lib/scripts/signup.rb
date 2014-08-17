require 'pony'

module WorkoutBuddies
  class SignUp
    def self.run(params)
      if params['email'].empty? || params['display_name'].empty? || params['password'].empty? || params['password_confirm'].empty? || params['address'].empty? || params['zip'].empty?
        return {:success? => false, :error => "Please fill out all input fields."}
      elsif WorkoutBuddies::DBI.dbi.email_exists?(params['email'])
        return {:success? => false, :error => "Email address already registered. Please sign in."}
      elsif params['password'] != params['password_confirm']
        return {:success? => false, :error => "Passwords don't match. Please try again."}
      end

      user = WorkoutBuddies::User.new(params)
      user.update_password(params['password'])
      user.set_profile_pic
      WorkoutBuddies::DBI.dbi.persist_user(user)
      user_id = WorkoutBuddies::DBI.dbi.get_user_id(user)
      user.update_user_id(user_id)


      # Pony.mail(
      #   :to => user.email,   
      #   :via => :smtp,
      #     :via_options => {
      #       :address              => 'smtp.gmail.com',
      #       :port                 => '587',
      #       :enable_starttls_auto => true,
      #       :user_name            => 'workoutbuddiesatx',
      #       :password             => 'wbATXpw1',
      #       :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      #       :domain               => "localhost.localdomain", # the HELO domain provided by the client to the server
      #       :ssl                  => true
      #       },
      #     :from => 'workoutbuddiesatx@gmail.com', 
      #     :subject => 'Workout Buddies Registration', 
      #     :body => "Thanks for registering with Workout Buddies.  We know you'll love it! \n--the Workout Buddies team "
      #     )

      {
        :success? => true,
        :session_id => user.user_id
      }
    end
  end
end