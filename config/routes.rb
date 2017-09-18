Rails.application.routes.draw do
  get 'ps1/index'
  get 'ps1/dividebyzero' => 'ps1#dividebyzero'
  get 'ps1/nytimesscrapper' => 'ps1#nytimesscrapper'

  get 'ps2/index'

  get 'problemsets/index'

  root :to => 'problemsets#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
