get '/settings' do
  checkLogin
  @active = "settings"
  erb :settings
end

get '/change_password' do
  checkLogin
  erb :change_password
end

get '/change_email' do
  checkLogin
  erb :change_email
end

post '/change_password' do
  @fields_empty = true
  db_password = @database.execute %{SELECT password FROM loginInfo;}
  unless params[:current_password].nil? || params[:current_password] == '' ||
      params[:new_password1].nil? || params[:new_password1] == '' ||
      params[:new_password2].nil? || params[:new_password2] == ''
    @fields_empty = false
    if params[:new_password1] == params[:new_password2] && BCrypt::Password.new(db_password[0][0]) == params[:current_password]
      editPassword = %{UPDATE loginInfo SET password = ?;}
      password = BCrypt::Password.create(params[:new_password1])
      @database.execute editPassword, password
      redirect '/settings'
    end
  end
  if BCrypt::Password.new(db_password[0][0]) != params[:current_password]
    @error = "The password was incorrect"
  end
  if params[:new_password1] != params[:new_password2]
    @error = "The passwords don't match"
  end
  if @fields_empty
    @error = "Please fill in all fields"
  end
  erb :change_password
end

post '/change_email' do
  @fields_empty = true
  unless params[:email].nil? || params[:email] == ''
    editEmail = %{UPDATE loginInfo SET email = ?;}
    email = BCrypt::Password.create(params[:email])
    @database.execute editEmail, email
    redirect '/settings'
  end
  @error = "Please fill in the field"
  erb :change_email
end
