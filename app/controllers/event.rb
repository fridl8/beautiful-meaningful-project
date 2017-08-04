put '/users/:id/calendar/events' do
  @user = User.find_by(id: params[:id])
  @cal = Google::Calendar.new(:client_id     => ENV['GOOGLE_CLIENT_ID'],
                           :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                           :calendar      => ENV['GOOGLE_CAL_ID'],
                           :refresh_token => @user.refresh,
                           :redirect_url  => "urn:ietf:wg:oauth:2.0:oob"
                           )
  @event = Google::Event.new(:calendar => @cal,
                             :title => params[:event][:title],
                             :start_time => Time.now
                            )
  @event.save
  redirect "/users/#{params[:id]}/calendar"
end
