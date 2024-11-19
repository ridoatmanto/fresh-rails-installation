Rails.application.routes.draw do
  default_url_options host: ENV['API_HOSTNAME']

  %i[
    cluster
    program
    program_tag
    item
    client
    admin
    user
    order
    role
    authority
    mail_template
    batch
    question
    answer
    tag
    user
    solutioning_answer
    program_property
    property
    journey
    stat
    interest_program
    invited_client
    merchant_member
    testing_tool
    objective
    company
    trans_program_company
    trans_client_company
    trans_client_voucher
  ].each do |resource|
    resources resource
    match "/#{resource}(/(:id))?" => "#{resource}#options", via: :options
    post "/#{resource}/(:id)/picture", to: "#{resource}#upload_picture"
    post "/#{resource}/confirm", to: "#{resource}#confirm"
  end

  get '/solution_builder/start', to: 'solution_builder#start_builder'
  get '/solution_builder/answer_tag', to: 'solution_builder#answer_tag'
  post '/solution_builder/register', to: 'solution_builder#register'
  post '/solution_builder/answer', to: 'solution_builder#answer'
  post '/solution_builder/save', to: 'solution_builder#save_journey'

  get '/account/menu', to: 'account#menu'
  post '/account/signout', to: 'account#signout'
  get '/account', to: 'account#show'
  put '/account', to: 'account#update'
  post '/payment', to: 'payment#update'

  post '/contact', to: 'contact#create'
  get '/contact', to: 'contact#index'
  get '/contact/:id', to: 'contact#show'
  get '/contact/category', to: 'contact#category'
  delete '/contact/:id', to: 'contact#destroy'

  resources :program, only: [:show] do
    resources :item, only: [:index, :show]
    resources :program_property_item, only: [:index, :show]
  end

  get '/internal_access', to: 'internal_access#index'
  get '/cognito_user/(:id)', to: 'complete_cognito_user#show'
  post '/cognito_user', to: 'complete_cognito_user#create'
  patch '/cognito_user/(:id)', to: 'complete_cognito_user#update'

  get '/public_holiday', to: 'public_holiday#index'

  post '/invited_client/invite', to: 'invited_client#invite'
  get '/program_journey_order_list', to: 'order#show_order_by_journey'
  get '/check_webinar_invitation', to: 'webinar_invitation#check_webinar_invitation'
  get '/check_company_client', to: 'company#check_company_client'
  post '/register_company_client', to: 'company#register_company_client'
  get '/register_company_client', to: 'company#register_company_client_in_get'
  get '/company_client_list', to: 'company#company_client_list'
  get '/encrypt', to: 'company#encrypt'
  get '/decrypt', to: 'company#decrypt'
  get '/force_change_password', to: 'company#force_change_password'
  get '/request_access_token', to: 'company#request_access_token'
  get '/detail_client', to: 'company#detail_client'
  get '/lookup_voucher', to: 'trans_client_voucher#lookup_voucher'
  get '/lookup_voucher/calculator', to: 'trans_client_voucher#calculate_voucher'
  get '/lookup_company', to: 'company#lookup_company'

  resources :company, only: [:show] do
    resources :client, only: [:show, :index]
  end

  get '/', to: proc { [200, {}, ['']] }
end
