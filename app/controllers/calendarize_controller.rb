class CalendarizeController < ApplicationController
  #helper_method :current_user
  before_action :require_login, except: [:index]
  before_action :get_departments, only: [:new]

  def new
    @add_type = params[:type]
  end

  def index
    if current_user
      redirect_to home_path
    end
  end

  def event
    @activity_id = params[:activity_id]
    @meeting_id = params[:meeting_id]
    @event = Availabletime.where( activity_id: @activity_id, id: @meeting_id)
    puts @id
    respond_to do |format|
      format.json { render :json => @event.to_json }
    end
  end

  def show
    @show_type = params[:show_type]
    if @show_type == 'activity'
      @show_data = Activity.find(params[:id])
      @m = Member.where( activity_id: @show_data.id )
      @members = User.find(@m.map(&:user_id))

      @comments = Comment.where( activity_id: @show_data.id)

      @meetings = Schedule.where(activity_id: @show_data.id)
    elsif @show_type == 'department'
      @show_data = Department.find( params[:deptid] )
    elsif @show_type == 'student'
      @show_data = User.find_by( uname: params[:uname])
      @student_data = Student.find_by( user_id: @show_data.id)
    elsif @show_type == 'faculty'
      @show_data = User.find_by( uname: params[:uname])
    elsif @show_type == 'secretary'
      @show_data = User.find_by( uname: params[:uname])
    elsif @show_type == "all students" && session[:user_type] == "secretary"
      @secretary_dept ||= User.find_by( :uname => session[:user_id]).udept if session[:user_type] == "secretary"
      @students = Student.joins( :user ).where( :users => {:udept => @secretary_dept})
    elsif @show_type == "all students" && session[:user_type] == "superadmin"
      @students = Student.joins( :user )
    elsif @show_type == "all faculty" && session[:user_type] == "superadmin"
      @faculties = Faculty.joins( :user )
    elsif @show_type == "all faculty"
      @secretary_dept ||= User.find_by( :uname => session[:user_id]).udept if session[:user_type] == "secretary"
      @faculties = Faculty.joins( :user ).where( :users => {:udept => @secretary_dept})
    elsif @show_type = "calendar"
    end
  end

  def home
    #for showing activity
    if session[:user_type] == 'student'
      @activities = Activity.where( user_id: User.find_by( uname: session[:user_id]).id)
    elsif session[:user_type] == 'faculty'
      @get_m = Member.where( user_id: User.find_by( uname: session[:user_id]).id)
      @activities = Activity.where( id:  @get_m.map(&:activity_id))
    elsif session[:user_type] == 'secretary'
      @activities = Activity.where( secretary_id: Secretary.find_by( user_id: User.find_by( uname: session[:user_id]).id))
    end
  end

  def create
    if params[:add_type] == "secretary" && ( session[:user_type] == 'superadmin' )
      @user = User.new( :uname => params[:username], :uemail => params[:email], :udept => params[:department])
      if @user.save
        @secretary = Secretary.new( :user_id => User.find_by(uname: @user.uname).id )
        if @secretary.save
          redirect_to show_path( :show_type => params[:add_type], :uname => params[:username]) , :flash => { :notice => "Successfully created..."}
        end
      elsif User.exists?( :uname => params[:username])
        redirect_to new_path( :type => params[:add_type]), :flash => {:error => "User Already exists"}
      end
    elsif params[:add_type] == "faculty" && ( session[:user_type] == 'superadmin' || session[:user_type] == 'secretary' )
      @user = User.new( :uname => params[:username], :uemail => params[:email], :udept => params[:department])
      if @user.save
        @faculty = Faculty.new( :user_id => User.find_by(uname: @user.uname).id )
        if @faculty.save
          redirect_to show_path( :show_type => params[:add_type], :uname => params[:username]) , :flash => { :notice => "Successfully created..."}
        end
      elsif User.exists?( :uname => params[:username])
        redirect_to new_path( :type => params[:add_type]), :flash => {:error => "User Already exists"}
      end
    elsif params[:add_type] == "student" && ( session[:user_type] == 'superadmin' || session[:user_type] == 'secretary' )
      @user = User.new( :uname => params[:username], :uemail => params[:email], :udept => params[:department])
      if @user.save
        @student = Student.new( :user_id => User.find_by( uname: @user.uname).id, :fos => params[:field_of_study] )
        if @student.save
          redirect_to show_path( :show_type => params[:add_type], :uname => params[:username]) , :flash => { :notice => "Successfully created..." }
        end
      elsif User.exists?( :uname => params[:username])
        redirect_to new_path( :type => params[:add_type]), :flash => {:error => "User Already exists"}
      end
    elsif params[:add_type] == "department" && session[:user_type] == 'superadmin'
      @department = Department.new( :deptname => params[:department_name].downcase, :deptschool => params[:school].downcase)

      if @department.save
        redirect_to show_path( :show_type => params[:add_type], :deptid =>  @department.id), :flash => { :notice => "Successfully created..." }
      elsif Department.exists?( :deptname => params[:department_name].downcase)
        redirect_to new_path( :type => params[:add_type]), :flash => { :error => "department already exsits..." }
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

      ActivityType.find_or_create_by( acttypename: params[:activity_type].downcase) if params[:activity_type].present?

      @activity = Activity.new(
                  :acttopic => @acttopic,
                  :acttype => params[:activity_type],
                  :secretary_id => @secretary.id,
                  :user_id => User.find_by( uname: params[:activity_for]).id)

      if @activity.save
        redirect_to home_path, :flash => { :notice => "Successfully created..."}
      else
        redirect_to new_path( :type => params[:add_type])
      end
    elsif params[:add_type] == "member" && session[:user_type] == 'secretary'
      if !Activity.exists?( id: params[:activity_id], user_id: User.find_by( :uname => params[:member]).id)
        @member = Member.new( :user_id => User.find_by( uname: params[:member]).id, :activity_id => params[:activity_id])
        respond_to do |format|
          if @member.save
            format.js
          else
            #alert that member already exists
          end
        end
      else
      end
    elsif params[:add_type] == "comment" && session[:user_id].present?
      @comment = Comment.new( :user_id => User.find_by( uname: session[:user_id]).id, :comment => params[:comment], :activity_id => params[:activity_id])
      respond_to do |format|
        if @comment.save
          format.js
        end
      end
    elsif params[:add_type] == "meeting" && Activity.exists?( id: params[:activity_id], secretary_id: Secretary.find_by( user_id: User.find_by( uname: session[:user_id]).id).id)
      h=params[:schdate]
      @schdate=Date.new(h['(1i)'].to_i, h['(2i)'].to_i, h['(3i)'].to_i)
      @schedule = Schedule.new( :schname => params[:meeting_name], :schdate => @schdate, :schstart => false, :schfinished => false, :activity_id => params[:activity_id])
      respond_to do |format|
        if @schedule.save
          format.js
        end
      end
    elsif params[:add_type] == "freetime"
      @tag = params[:tag]
      @stime = Time.zone.parse(params[:start_time]).utc
      @start_time = DateTime.new(@stime.year.to_i,@stime.month.to_i,@stime.day.to_i,@stime.hour.to_i,@stime.min.to_i,@stime.sec.to_i)
      @etime = Time.zone.parse(params[:end_time]).utc
      @end_time = DateTime.new(@etime.year.to_i,@etime.month.to_i,@etime.day.to_i,@etime.hour.to_i,@etime.min.to_i,@etime.sec.to_i)
      case params[:color]
      when "Red"
        @color = "#f45942"
      when "Blue"
        @color = "#4156f4"
      when "Green"
        @color = "#41f485"
      when "Yellow"
        @color = "#dfe21b"
      when "Purple"
        @color = "#e21be2"
      when "Orange"
        @color = "#ed9034"
      end
      @activity_id = params[:activity_id]
      @member_id = Member.find_by( user_id: User.find_by( uname: session[:user_id]).id).id
      @schedule_id = params[:meeting_id]
      @user_id = User.find_by( uname: session[:user_id]).id

      @event = []
      @event << { id:"1",title:"#{@tag}", allDay: false, start:"#{@start_time}", end:"#{@end_time}", color:"#{@color}"  }

      @availabletime = Availabletime.new( title: @tag,
                                          start: @start_time,
                                          end: @end_time,
                                          color: @color,
                                          activity_id: @activity_id,
                                          member_id: @member_id,
                                          user_id: @user_id,
                                          schedule_id: @schedule_id)

      respond_to do |format|
        if @availabletime.save
         format.js
       else
         puts @availabletime.errors.full_messages
        end
      end
    end
  end

  def edit
    if params[:edit_type] == 'start_meeting'
      @meeting = Schedule.find(params[:meeting_id])
      @meeting.schstart = true
      respond_to do |format|
        if @meeting.save
          format.js
        end
      end
    elsif params[:edit_type] == 'student'

    elsif params[:edit_type] == 'faculty'

    elsif params[:edit_type] == 'secretary'

    elsif params[:edit_type] == 'student'

    elsif params[:edit_type] == 'department'

    elsif  params[:edit_type] = 'availabletime'
      @availabletime = Availabletime.find(params[:event][:id])
      @availabletime.start = params[:event][:start]
      @availabletime.end = params[:event][:end]
      @availabletime.save

    end
  end
  def delete
    if params[:delete_type] == "comment" && session[:user_id] == User.find( Comment.find(params[:id]).user_id ).uname
      Comment.delete(params[:id])
      respond_to do |format|
        format.js { render :action => 'delete'}
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
end
