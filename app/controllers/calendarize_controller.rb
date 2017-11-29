class CalendarizeController < ApplicationController
  #helper_method :current_user
  before_action :require_login, except: [:index]
  before_action :update_gcal_token, except: [:index]
  before_action :get_departments, only: [:new]

  def new
    Superadmin.create( suadusername: "superman", suadpassword: "superpower5$3@1")
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
    @event = Availabletime.where( activity_id: @activity_id, schedule_id: @meeting_id)
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
      NotificationMailer.notification("st119370@ait.asia").deliver
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
      if !Activity.exists?( id: params[:activity_id], user_id: User.find_by( :uname => params[:member]).id) && !Member.exists?( activity_id: params[:activity_id], user_id: User.find_by( :uname => params[:member]).id)
        @member = Member.new( :user_id => User.find_by( uname: params[:member]).id, :activity_id => params[:activity_id])
        respond_to do |format|
          if @member.save
            @saved = true
            flash[:notice] = " Member added !!! "
            format.js
          end
        end
      else
        respond_to do |format|
          @saved = false
          format.js
        end
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
      if h['(1i)'] == "" && h['(2i)']  == "" && h['(3i)'] == ""
        @schdate = nil
      else
        @schdate = Date.new(h['(1i)'].to_i, h['(2i)'].to_i, h['(3i)'].to_i)
      end
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

      if @tag == "meeting" && session[:user_type] == "secretary"
        @schedule = Schedule.find(params[:meeting_id])
        @schedule.schdate = @start_time

        @schedule.save
      end
      if @tag == "deadline" && session[:user_type] == "secretary"
        @schedule = Schedule.find(params[:meeting_id])
        @schedule.schdeadline = @start_time

        @schedule.save
      end
      case params[:color]
      when "Red"
        @color = "#f45942"
      when "Blue"
        @color = "#09e9f9"
      when "Green"
        @color = "#88ff00"
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
          puts @availabletime.id
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

    elsif  params[:edit_type] == 'availabletime'

      @availabletime = Availabletime.find(params[:event][:id])

      if session[:user_id] == User.find(@availabletime.user_id).uname
        @availabletime.start = params[:event][:start]
        @availabletime.end = params[:event][:end]

        if @availabletime.title == "meeting" && session[:user_type] == "secretary"
          @schedule = Schedule.find(@availabletime.schedule_id)
          @schedule.schdate = params[:event][:start]

          @schedule.save
        end

        if @availabletime.title == "deadline" && session[:user_type] == "secretary"
          @schedule = Schedule.find(@availabletime.schedule_id)
          @schedule.schdeadline = params[:event][:start]

          @schedule.save
        end

        @availabletime.save

        @edit_availabletime = true
      end
    elsif params[:edit_type] == 'edit_availabletime'
      puts params[:availabletime_id]
      @event = Availabletime.find(params[:availabletime_id])
      if session[:user_id] == User.find(@event.user_id).uname

        @event.title = params[:edit_tag]
        @event.start = params[:edit_start_time]
        @event.end = params[:edit_end_time]

        if @event.title == "meeting" && session[:user_type] == "secretary"
          @schedule = Schedule.find(@event.schedule_id)
          @schedule.schdate = params[:edit_start_time]

          @schedule.save
        end

        if @event.title == "deadline" && session[:user_type] == "secretary"
          @schedule = Schedule.find(@event.schedule_id)
          @schedule.schdeadline = params[:edit_start_time]

          @schedule.save
        end

        case params[:edit_color]
        when "Red"
          @event.color = "#f45942"
        when "Blue"
          @event.color = "#09e9f9"
        when "Green"
          @event.color = "#88ff00"
        when "Yellow"
          @event.color = "#dfe21b"
        when "Purple"
          @event.color = "#e21be2"
        when "Orange"
          @event.color = "#ed9034"
        end

        @edit_availabletime = true

        respond_to do |format|
          if @event.save
            format.js
          end
        end
      else
        @edit_availabletime = false
        respond_to do |format|
          format.js
        end
      end
    end
  end
  def delete
    if params[:delete_type] == "comment" && session[:user_id] == User.find( Comment.find(params[:id]).user_id ).uname
      Comment.delete(params[:id])
      respond_to do |format|
        format.js { render :action => 'delete'}
      end
    elsif params[:delete_type] == "delete_availabletime"
      @event = Availabletime.find(params[:availabletime_id])

      if @event.title == "meeting" && session[:user_type] == "secretary"
        @schedule = Schedule.find(@event.schedule_id)
        if @schedule.schdate == @event.start
          @schedule.schdate = nil
          @schedule.save
        end
      end

      if @event.title == "deadline" && session[:user_type] == "secretary"
        @schedule = Schedule.find(@event.schedule_id)
        if @schedule.schdeadline = @event.start
          @schedule.schdeadline = nil
          @schedule.save
        end
      end
      respond_to do |format|
        if session[:user_id] == User.find(@event.user_id).uname
          Availabletime.delete( params[:availabletime_id])
          format.js { render :action => 'delete'}
        end
      end
    end
  end

  def google_calendar
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s
  end

  def google_calendar_callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    if session[:user_type] == 'secretary'
      @secretary = Secretary.find(User.find_by( uname: session[:user_id]).id)

      @secretary.token = response["access_token"]
      @secretary.gcalendar = response["refresh_token"]

      @secretary.save
    elsif session[:user_type] == 'faculty'
      @faculty = Faculty.find(User.find_by( uname: session[:user_id]).id)

      @faculty.token = response["access_token"]
      @faculty.gcalendar = response["refresh_token"]

      @faculty.save
    end

    session[:gcal_token] = response

    redirect_to root_path
  end


  def import_calendar
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:gcal_token])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events('primary',
                          q: params[:event_keyword],
                          single_events: true,
                          order_by: 'startTime',
                          time_min: Time.now.iso8601)


    @event_list.items.each do |event|
      @tag = event.summary

      @start_time = event.start.date_time.utc
      @end_time = event.end.date_time.utc



      case params[:color]
      when "Red"
        @color = "#f45942"
      when "Blue"
        @color = "#09e9f9"
      when "Green"
        @color = "#88ff00"
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
      @availabletime.save
    end

    redirect_to show_path( activity_id: params[:activity_id], meeting_id: params[:meeting_id], show_type: "calendar")
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

  def update_gcal_token
    if( session[:gcal_token].present? )
      begin
        client = Signet::OAuth2::Client.new(client_options)
        client.update!(session[:gcal_token])

        service = Google::Apis::CalendarV3::CalendarService.new
        service.authorization = client

        @calendar_list = service.list_calendar_lists

      rescue Google::Apis::AuthorizationError
        response = client.refresh!

        session[:gcal_token] = session[:gcal_token].merge(response)

        if session[:user_type] == 'secretary'
          @secretary = Secretary.find(User.find_by( uname: session[:user_id]).id)

          @secretary.token = session[:gcal_token]["access_token"]

          @secretary.save
        elsif session[:user_type] == 'faculty'
          @faculty = Faculty.find(User.find_by( uname: session[:user_id]).id)

          @faculty.token = session[:gcal_token]["access_token"]

          @faculty.save
        end
      retry
      end
    end
  end

  def client_options
    {
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: 'http://localhost:3000/calendarize/google_calendar_callback'
    }
  end
end
