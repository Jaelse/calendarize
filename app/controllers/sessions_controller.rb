class SessionsController < ApplicationController
  def new
  end

  def create
    if Superadmin.authenticate(params[:username], params[:password])
      session[:user_id] = params[:username]
      session[:user_type] = "superadmin"
      redirect_to home_path
    else

      ldap = Net::LDAP.new :host => "ldapserv.ait.ac.th",
                          :port => 636,
                          :auth => {
                            :method=> :simple,
                            :username => "uid=#{params[:username]},ou=people,dc=ait,dc=ac,dc=th",
                            :password => "#{params[:password]}"},
                            :encryption => { method: :simple_tls,
                              tls_options: { :verify_mode => OpenSSL::SSL::VERIFY_NONE}
                            }
      if ldap.bind
        @user = User.find_by( :uname => params[:username])
        if !@user.blank?
          if Secretary.exists?( :user_id => @user.id )
            session[:user_id] = params[:username]
            session[:user_type] = 'secretary'
            redirect_to home_path
          elsif Student.exists?( :user_id => @user.id )
            session[:user_id] = params[:username]
            session[:user_type] = 'student'
            redirect_to home_path
          elsif Faculty.exists?( :user_id => @user.id )
            session[:user_id] = params[:username]
            session[:user_type] = 'faculty'
            redirect_to home_path
          else
            redirect_to home_path, :flash => { :error => "You are a good person but not allowed to use this system right now !!!" }
          end
        else
          redirect_to log_in_path, :flash => { :error => "You are a good person but not allowed to use this system right now !!!" }
        end
      else
        redirect_to log_in_path, :flash => { :error => "Invalid username or password!" }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    redirect_to index_path
  end
end
