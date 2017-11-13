class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception 
  helper_method :current_user

  private
    def current_user
      if Superadmin.exists?( :suadusername => session[:user_id] )
          @current_user ||= Superadmin.find_by( :suadusername => session[:user_id]) if session[:user_id]
      else
          @current_user ||= User.find_by(:uname => session[:user_id]) if session[:user_id]
      end
    end
end
