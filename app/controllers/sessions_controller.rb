class SessionsController < ApplicationController
  def new
  end

  def create
    if Superadmin.authenticate(params[:username], params[:password])
      session[:user_id] = params[:username]
      session[:user_type] = "superadmin"
      redirect_to home_path
    else
      ldap = Net::LDAP.new
      ldap.host = "ldapserv.ait.ac.th"
      ldap.port = 3269
      ldap.auth "uid=#{params[:username]},ou=people,dc=ait,dc=ac,dc=th", "#{params[:password]}"
      if ldap.bind
        if Secretary.exists?( :user_id => User.find_by( :uname => params[:username]).id )
          session[:user_id] = params[:username]
          session[:user_type] = 'secretary'
          redirect_to home_path
        elsif Student.exists?( :user_id => User.find_by( :uname => params[:username]).id )
          session[:user_id] = params[:username]
          session[:user_type] = 'student'
          redirect_to home_path
        elsif Faculty.exists?( :user_id => User.find_by( :uname => params[:username]).id )
          session[:user_id] = params[:username]
          session[:user_type] = 'faculty'
          redirect_to home_path
        else
          redirect_to home_path, :flash => { :error => "You are a good person but not allowed to use this system right now !!!" }
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
