Rails.application.routes.draw do
  get 'ps6/index'
  get 'ps6/user'
  get 'ps6/web9'
  get 'ps6/web7'

  get 'ps5/index'

  get 'ps5/index'

  get 'sessions/new', as: 'log_in'
  get 'sessions/destroy', as: 'log_out'
  get 'calendarize/index', as: 'index'
  get 'calendarize/home', as: 'home'
  get 'calendarize/new', as: 'new'
  post 'calendarize/create', as: 'create'
  get 'calendarize/show', as: 'show', remote: true
  delete 'calendarize/delete' => 'calendarize#delete', as: 'delete'
  patch 'calendarize/edit', as: 'edit'
  get 'calendarize/event' => 'calendarize#event', as: 'event'
  get 'calendarize/google_calendar' => 'calendarize#google_calendar', as: 'google_calendar'
  get 'calendarize/google_calendar_callback' => 'calendarize#google_calendar_callback', as: 'google_calendar_callback'
  post 'calendarize/import_calendar', as: 'import_calendar'
  get 'user_list/index', as: 'user_list'


  resources :sessions
  resources :calendarize do
    resources :delete
  end


  get 'ps4/index'
  get 'ps4/download_pdf'
  get 'ps4/statemodel_pdf'
  get 'ps3/index'
  get 'ps3/fictious_user1' => 'ps3#fictious_user1'
  get 'ps3/fictious_user2' => 'ps3#fictious_user2'
  get 'ps3/fictious_user3' => 'ps3#fictious_user3'
  get 'ps3/jenkins_output' => 'ps3#jenkins_output'
  get 'ps3/dump' => 'ps3#dump'

  get 'ps1/index'
  get 'ps1/dividebyzero' => 'ps1#dividebyzero'
  get 'ps1/nytimesscrapper' => 'ps1#nytimesscrapper'

  get 'ps2/index'
  get 'ps2/quotations' => 'ps2#quotations'
  post 'ps2/create' => 'ps2#create'
  get 'ps2/quotations_search' => 'ps2#quotations_search'
  get 'ps2/quotation_doc' => 'ps2#quotation_doc'
  get 'ps2/sql_problem_set' => 'ps2#sql_problem_set'
  get 'ps2/sql_ps_doc' => 'ps2#sql_ps_doc'
  post 'ps2/import_quotations' => 'ps2#import_quotations'


  get 'problemsets/index'

  root :to => 'calendarize#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
