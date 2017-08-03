get '/auth' do
  redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri,:scope => SCOPES,:access_type => "offline")
end

get '/oauth2callback' do
  access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
  session[:access_token] = access_token.token
  @message = "Successfully authenticated with the server"
  @access_token = session[:access_token]

  # parsed is a handy method on an OAuth2::Response object that will
  # intelligently try and parse the response.body
  @email = access_token.get('https://www.googleapis.com/userinfo/email?al=json').parsed
  erb :'/sessions/success'
end
