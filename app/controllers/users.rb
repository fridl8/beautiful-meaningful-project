get '/users/new' do
  erb :'/users/new'
end

post '/users' do
  @user = User.new(params[:user])
  if request.xhr?
    if @user.save
      redirect '/'
    else
      @errors = @user.errors.full_messages
      erb :'_errors', layout: false
    end
  else
    redirect '/'
  end
end

get '/users/:id' do
  @user = User.find_by(id: params[:id])
  if request.xhr?
    if logged_in?
      if @user
        if @user.id == current_user.id
          erb :'/users/show'
        else
          @errors = ["You can't do that"]
          erb :'_errors', layout: false
        end
      else
        @errors = ["User does not exist"]
        erb :'_errors', layout: false
      end
    else
      @errors = ["You need to be logged in"]
      erb :'_errors', layout: false
    end
  else
    redirect '/'
  end
end
