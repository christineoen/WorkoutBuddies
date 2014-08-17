require 'pony'

module RPS
  class SignUp
    def self.run(params)
      if params['email'].empty? || params['password'].empty? || params['password_conf'].empty? || params['screenname'].empty?
        return {:success? => false, :error => "EMPTY FIELDS"}
      elsif RPS::DBI.dbi.user_exists?(params['email'])
        return {:success? => false, :error => "USER ALREADY EXISTS"}
      elsif params['password'] != params['password_conf']
        return {:success? => false, :error => "PASSWORDS DONT MATCH"}
      end

      email = params['email'].downcase.strip #need for Gravatar
      user = RPS::User.new(params['screenname'], email)
      user.update_password(params['password'])
      user.set_profile_pic
      RPS::DBI.dbi.save_user(user)

      Pony.mail(
        :to => user.email,   
        :via => :smtp,
          :via_options => {
            :address              => 'smtp.gmail.com',
            :port                 => '587',
            :enable_starttls_auto => true,
            :user_name            => 'rps.makersquare',
            :password             => 'rockpaperscissors',
            :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
            :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
            },
          :from => 'rps.makersquare@gmail.com', 
          :subject => 'Rock, Paper, Scissors', 
          :body => "Thanks for registering with the Rock, Paper, Scissors game.  We know you'll love it! \n--the RPS team "
          )
      
      {
        :success? => true,
        :session_id => user.user_id
      }
    end
  end
end