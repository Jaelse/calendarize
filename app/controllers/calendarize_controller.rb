class CalendarizeController < ApplicationController
  helper_method :current_user
  before_action :get_departments, only: [:new]
  before_action :require_login, except: [:index]
  def new
    @add_type = params[:type]
  end

  def index
    if current_user
      redirect_to home_path
    end
  end

  def show
    @show_type = params[:type]
    if @show_type == 'activity'
      @show_data = Activity.find(params[:id])
      @members = Member.where( activity_id: @show_data.id )
    end
  end

  def home
    #for showing activity
    if session[:user_type] == 'student'
      @activities = Activity.where( user_id: User.find_by( uname: session[:user_id]).id)
      puts @activities
    elsif session[:user_type] == 'faculty'
      #do it for faculty ..........asdf.asdf.asdf.asdf.f.f.f.f.f.f.f.f.f.f.f. blah blah blah
    elsif session[:user_type] == 'secretary'
      @activities = Activity.where( secretary_id: Secretary.find_by( user_id: User.find_by( uname: session[:user_id]).id))
    end
  end

  def create
    if params[:add_type] == "secretary" && ( session[:user_type] == 'superadmin' || session[:user_type] == 'secretary' )
      @user = User.new( :uname => params[:username], :uemail => params[:email], :udept => params[:department])
      if @user.save
        @secretary = Secretary.new( :user_id => User.find_by(uname: @user.uname).id )
        if @secretary.save
          redirect_to home_path , :flash => { :error => "Invalid username or password!"}
        end
      end
      #later put an escape out  when user already exists and someone is trying to insert again
    elsif params[:add_type] == "faculty" && ( session[:user_type] == 'superadmin' || session[:user_type] == 'secretary' )
      puts 'faculty'
      #do faculty
    elsif params[:add_type] == "student" && ( session[:user_type] == 'superadmin' || session[:user_type] == 'secretary' )
      @user = User.new( :uname => params[:username], :uemail => params[:email], :udept => params[:department])
      if @user.save
        @student = Student.new( :user_id => User.find_by(uname: @user.uname).id, :fos => params[:field_of_study] )
        if @student.save
          redirect_to home_path , :flash => { :error => "Invalid username or password!" }
        end
      end
      redirect_to home_path
    elsif params[:add_type] == "department" && session[:user_type] == 'superadmin'
      @department = Department.new( :deptname => params[:department_name], :deptschool => params[:school])
      if @department.save
        redirect_to home_path, :flash => { :notice => "Successfully created..." }
      else
        #redirect_to new_path,
      end
    elsif params[:add_type] == "activity" && session[:user_type] == 'secretary'
      if !params[:activity_topic].blank?
        @acttopic = params[:activity_topic]
      else
        @acttopic = 'Topic not given'
      end

      @activity_for = params[:activity_for]

      @sec_user_id = User.find_by(uname: session[:user_id]).id
      @secretary = Secretary.find_by(user_id: @sec_user_id)

      @activity = Activity.new(
                  :acttopic => @acttopic,
                  :acttype => params[:activity_type],
                  :secretary_id => @secretary.id,
                  :user_id => User.find_by( uname: params[:activity_for]).id)

      if @activity.save
        redirect_to home_path, :flash => { :notice => "Successfully created..."}
      else
        #put redirect_to to the same page
      end
    elsif params[:add_type] == "member" && session[:user_type] == 'secretary'
      puts User.find_by( uname: params[:member]).id
      puts params[:activity_id]

      @member = Member.new( :user_id => User.find_by( uname: params[:member]).id, :activity_id => params[:activity_id])

      if @member.save
        puts 'done!!!!'
      end
    end
  end

  def get_departments
    @department = Department.all
  end

  def require_login
    if !current_user
        flash.now.alert = "First Sign in!!!"
        redirect_to index_path
    end
  end

  private
    def current_user
      if Superadmin.exists?( :suadusername => session[:user_id] )
          @current_user ||= Superadmin.find_by( :suadusername => session[:user_id]) if session[:user_id]
      else
          @current_user ||= User.find_by(:uname => session[:user_id]) if session[:user_id]
      end
    end
end
