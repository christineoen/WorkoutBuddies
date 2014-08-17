module WorkoutBuddies
  class SignUp
    def self.run(params)
      if params['email'].empty? || params['display_name'].empty? || params['password'].empty? || params['password_confirm'].empty?
        return {:success? => false, :error => "Please fill out all input fields."}
      elsif WorkoutBuddies.dbi.email_exists?(params['email'])
        return {:success? => false, :error => "Email address already registered. Please sign in."}
      elsif params['password'] != params['password_confirm']
        return {:success? => false, :error => "Passwords don't match. Please try again."}
      end

      user = WorkoutBuddies::User.new(params)
      user.update_password(params['password'])
      WorkoutBuddies.dbi.persist_user(user)
      user_id = WorkoutBuddies.dbi.get_user_id(user)
      user.update_user_id(user_id)

      {
        :success? => true,
        :session_id => user.user_id
      }
    end
  end
end