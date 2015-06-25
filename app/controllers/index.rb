use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => 'foo.com',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me'

get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/log_in/:error' do
  @error = params['error']
  erb :log_in
end

get '/log_in' do
  erb :log_in
end

post '/create' do
  @new_user = User.new(fullname: params[:new_fullname], email: params[:new_email], password: params[:new_password])
  @new_user.save
  unless @new_user.new_record?
    @create_success = "User created success MESSAGE"
    erb :log_in
  else
    @error = "User did not pass validation MESSAGE"
    erb :index
  end
end

post '/user_account' do
  if @authentication_user = User.find_by_email(params[:email])
    if @authentication_user.password == params[:password]
      session[:user_id] = @authentication_user.id
      redirect to '/protected_page'
    else
      @error = "Wrong password MESSAGE"
      erb :log_in
    end
  else
    @error = "Wrong Email MESSAGE"
    redirect to "/log_in/#{@error}"
  end
end

get '/user' do
 erb :user_log_in
end

get '/log_out' do
  session[:user_id] = nil
  erb :index
end

get '/protected_page' do
  authenticate
  erb :protected_page
end

=begin
Logging in


Logging out
Creating an account
Viewing the secret page
Redirecting a user back to the "log in" screen if they try to view the secret page without being logged in
=end

def authenticate
  if session[:user_id]
    true
  else
    @error = "No session cookies MESSAGE"
    # erb :log_in
    redirect to "/log_in/#{@error}"
  end
end
