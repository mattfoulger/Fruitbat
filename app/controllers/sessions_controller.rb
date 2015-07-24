class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to movies_path, notice: "Welcome back, #{user.firstname}!"
    else
      flash.now[:alert] = "Log in failed..."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to movies_path, notice: "Adios!"
  end

  def update
    if session[:previous_id]
      session[:user_id] = session[:previous_id]
      session[:previous_id] = nil
      redirect_to admin_users_path
    else
      session[:previous_id] = session[:user_id]
      session[:user_id] = params[:format]
      redirect_to root_path
    end
  end


end