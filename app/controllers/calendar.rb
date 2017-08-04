get '/users/:id/calendar' do
  @user = User.find_by(id: params[:id])
  if @user.refresh.length != nil
    @cal = Google::Calendar.new(:client_id     => ENV['GOOGLE_CLIENT_ID'],
                           :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                           :calendar      => ENV['GOOGLE_CAL_ID'],
                           :refresh_token => @user.refresh,
                           :redirect_url  => "urn:ietf:wg:oauth:2.0:oob"
                           )
  elsif params[:auth_token]
    @cal = Google::Calendar.new(:client_id     => ENV['GOOGLE_CLIENT_ID'],
                           :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                           :calendar      => ENV['GOOGLE_CAL_ID'],
                           :redirect_url  => "urn:ietf:wg:oauth:2.0:oob"
                           )
    refresh_token = @cal.login_with_auth_code(params[:auth_token])
    @user.refresh = refresh_token
    @user.save
  else params[:refresh_token]
    @cal.login_with_refresh_token(params[:refresh_token])
  end
  erb :'/calendars/show', locals: {refresh_token: refresh_token}
end
