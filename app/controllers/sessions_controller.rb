class SessionsController < ApplicationController

  def new
  end

  def create
    cart = current_cart
    if user = login(params[:email], params[:password], params[:remember_me])
      successful_login(cart, user)
    else
      session[:cart_id] = cart.id
      invalid_email
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out."
  end

private

  def successful_login(cart, user)
    cart.assign_cart_to_user(user)
    if session[:return_to_url]
      redirect_to session[:return_to_url]
      return
    else
      redirect_to root_url("Logged in!")
      return
    end
  end

  def invalid_email
    flash.now.alert = "Email or password was invalid."
    render :new
  end

end
