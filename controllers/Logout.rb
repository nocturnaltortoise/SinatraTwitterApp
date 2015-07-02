get '/logout' do
  @active = 'logout'
  session.clear
  erb :logout
end