class SessionsController < ApplicationController
  def new
    # Login Page - new.html.erb
  end

  def create
    reviewer = Reviewer.find_by(name: params[:reviewer][:name])
    password = params[:reviewer][:password]

    if reviewer && reviewer.authenticate(password)
      session[:reviewer:id] = reviewer.id
      redirect_to rooth_path, notice: "Logged in succesfully"
    else
      redirect_to login_path, alert: "Invalid username/password combination"
    end
  end

  def destroy
    reset_session # wipe out session and everything in it
    redirect_to login_path, notice: "You have been Logged out"
  end
end
