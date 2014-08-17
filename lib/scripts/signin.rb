module WorkoutBuddies
  class SignIn
    def self.run(params)
      if params['email'].empty? || params['password'].empty?
        return {:success? => false, :error => "Please fill out all input fields."}
      end

      user = WorkoutBuddies::DBI.dbi.get_user_by_email(params['email'])
      p user
      return {:success? => false, :error => "Username not found. Please try again."} if !user

      if !user.has_password?(params['password'])
        return {:success? => false, :error => "Incorrect password. Please try again."}
      end

      {
        :success? => true,
        :session_id => user.user_id
      }
    end
  end
end