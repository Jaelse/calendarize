Rails.application.routes.draw do
  get 'ps6/index'

  get 'ps5/index'

  get 'ps5/index'  

  get 'sessions/new', as: 'log_in'
  get 'sessions/destroy', as: 'log_out'
  get 'calendarize/index', as: 'index'
  get 'calendarize/home', as: 'home'
  get 'calendarize/new', as: 'new'
  post 'calendarize/create', as: 'create'
  get 'calendarize/show', as: 'show'
  resources :sessions
  resources :calendarize

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

  root :to => 'problemsets#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
