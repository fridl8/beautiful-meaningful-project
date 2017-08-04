get '/users/:id/calendar' do
  @user = User.find_by(id: params[:id])
  @cal = Google::Calendar.new(:client_id     => ENV['GOOGLE_CLIENT_ID'],
                           :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                           :calendar      => ENV['GOOGLE_CAL_ID'],
                           :redirect_url  => "urn:ietf:wg:oauth:2.0:oob" # this is what Google uses for 'applications'
                           )
  if params[:auth_token]
    refresh_token = @cal.login_with_auth_code(params[:auth_token])
  elsif params[:refresh_token] || @cal.refresh_token != nil
    @cal.login_with_refresh_token(params[:refresh_token])
  end
  erb :'/calendars/show', locals: {refresh_token: refresh_token}
end
