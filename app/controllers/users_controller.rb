class UsersController < ApplicationController
  before_filter :is_current_user?, only: [ :show ]
  skip_after_filter :set_last_page, :only => ["new", "create"]

  def new
    @user = User.new
  end

  def create
    last_page = session[:last_page]
    user_info = params[:user]
    @user = User.new(user_info)
    if @user.save && user = login(user_info[:email], user_info[:password])
        successful_login(current_cart, user)
        redirect_to last_page || root_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @orders = current_user.recent_orders.desc
  end

  private
  def is_current_user?
    redirect_to_last_page unless User.find_by_id(params[:id]) == current_user
  end

  def successful_login(cart, user)
    cart.assign_cart_to_user(user)
    flash[:message] = "Sign-up complete! You're now logged in!"
  end
end
