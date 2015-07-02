enable :sessions
set :session_secret, 'szPmf3.nkL]5$5^<,-D{M&Y-H)=}5j' #randomly generated string

get '/login' do

  numLoginInfo = @database.get_first_value %{SELECT COUNT(*) FROM loginInfo;}

  if numLoginInfo.zero?
    insert = %{INSERT OR IGNORE INTO loginInfo(email,password) VALUES(?,?)}
    email = BCrypt::Password.create("123@gmail.com")
    password = BCrypt::Password.create("123")
    @database.execute insert, email, password
  end

  #puts @database.execute %{SELECT * FROM loginInfo;}

  erb :login
end

post '/login' do
  db_email = @database.execute %{SELECT email FROM loginInfo}
  db_password = @database.execute %{SELECT password FROM loginInfo}

  #execute returns a 2d array, hence why we need [0][0] and not [0]
  #thought this was clearer than using the splat operator and an empty string, although both work.
  #Password is encrypted with BCrypt, the password is still sent to the server in plaintext, but we can't do much about that without an SSL certificate.
  if BCrypt::Password.new(db_email[0][0]) == params[:email] && BCrypt::Password.new(db_password[0][0]) == params[:password]
    session[:logged_in] = true
    redirect '/'
  end
  @error = 'Password or email is incorrect'
  erb :login
end