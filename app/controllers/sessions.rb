# get '/auth' do
#   redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri,:scope => SCOPES,:access_type => "offline")
# end

# get '/oauth2callback' do
#   access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
#   session[:access_token] = access_token.token
#   @message = "Successfully authenticated with the server"
#   @access_token = session[:access_token]

#   # parsed is a handy method on an OAuth2::Response object that will
#   # intelligently try and parse the response.body
#   @email = access_token.get('https://www.googleapis.com/userinfo/email?al=json').parsed
#   erb :'/sessions/success'
# end

get '/redirect' do
end

get '/sessions/new' do
  erb :'/sessions/new'
end

post '/sessions' do
  @user = User.find_by(email: params[:user][:email])
  if request.xhr?
    if !logged_in?
      if @user && @user.authenticate(params[:user][:password], params[:user][:email])
        session[:user_id] = @user.id
        redirect '/'
      else
        @errors = ["Password or email is incorrect"]
        erb :'_errors', layout: false
      end
    else
      @errors = ["You need to be logged out to do that"]
      erb :'_errors', layout: false
    end
  else
    if !logged_in?
      if @user && @user.authenticate(params[:user][:password], params[:user][:email])
        session[:user_id] = @user.id
        redirect "/users/#{@user.id}"
      else
        @errors = ["Password or email is incorrect"]
        erb :'/sessions/new'
      end
    else
      @errors = ["You need to be logged out to do that"]
      erb :index
    end
  end
end

delete '/sessions' do
  session.delete(:user_id)
  redirect '/'
end
