Simpler.application.routes do
  get '/tests/1', 'tests#show'
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
end
