class SessionsController < ApplicationController
  before_action :check_session, only: [:new, :create]
  def new
  end

  def create
    RestClient.proxy = ENV["FIXIE_URL"]
    response = RestClient.get("http://welcome.usefixie.com")

    if Superadmin.authenticate(params[:username], params[:password])
      session[:user_id] = params[:username]
      session[:user_type] = "superadmin"

      redirect_to home_path
    else

      ldap = Net::LDAP.new :host => "ldapserv.ait.ac.th",
                          :port => 389,
                          :auth => {
                            :method=> :simple,
                            :username => "uid=#{params[:username]},ou=people,dc=ait,dc=ac,dc=th",
                            :password => "#{params[:password]}"
                            }

      # ldap = Net::LDAP.new :host => "ldapserv.ait.ac.th",
      #                     :port => 636,
      #                     :auth => {
      #                       :method=> :simple,
      #                       :username => "uid=#{params[:username]},ou=people,dc=ait,dc=ac,dc=th",
      #                       :password => "#{params[:password]}"},
      #                       :encryption => { method: :simple_tls,
      #                         tls_options: { :verify_mode => OpenSSL::SSL::VERIFY_NONE}
      #                       }

      if ldap.bind
        @user = User.find_by( :uname => params[:username])
        if !@user.blank?
          if Secretary.exists?( :user_id => @user.id )
            session[:user_id] = params[:username]
            session[:user_type] = 'secretary'

            if(!Secretary.find_by( :user_id => @user.id).gcalendar.nil? && !Secretary.find_by( :user_id => @user.id).token.nil?)
              gcalendar_hash = {
                "access_token" => Secretary.find_by( :user_id => @user.id).token,
                "expires_in" => 3600,
                "refresh_token" => Secretary.find_by( :user_id => @user.id).gcalendar,
                "token_type" => "Bearer"
              }

              session[:gcal_token] = gcalendar_hash
            end

            redirect_to home_path
          elsif Student.exists?( :user_id => @user.id )
            session[:user_id] = params[:username]
            session[:user_type] = 'student'


            redirect_to home_path
          elsif Faculty.exists?( :user_id => @user.id )
            session[:user_id] = params[:username]
            session[:user_type] = 'faculty'

            if(!Faculty.find_by( :user_id => @user.id).gcalendar.nil? && !Faculty.find_by( :user_id => @user.id).token.nil? )
              gcalendar_hash = {
                "access_token" => Faculty.find_by( :user_id => @user.id).token,
                "expires_in" => 3600,
                "refresh_token" => Faculty.find_by( :user_id => @user.id).gcalendar,
                "token_type" => "Bearer"
              }

              session[:gcal_token] = gcalendar_hash
            end

            redirect_to home_path
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

  private
    def check_session
      if session[:user_id]
        redirect_to home_path, :flash => { :notice => "Already logged in" }
      end
    end
end
