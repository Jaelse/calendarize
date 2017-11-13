class UserListController < ApplicationController
  def index
    @users = User.order(:uname).where("uname like ?", "%#{params[:term]}%").map(&:uname)

   render json: @users
  end
end
