helpers do

  def current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !!current_user
  end

  def authorize!
    redirect '/sessions/new' unless logged_in?
  end

end
