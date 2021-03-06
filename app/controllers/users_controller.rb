class UsersController < ApplicationController

  before_filter :is_current_user?, only: [ :show ]

  def new
    @user = User.new
  end

  def create
    user_info = params[:user]
    last_page = params[:last_page] || session[:last_page]
    @user = User.new(user_info)
    if @user.save
      establish_session(@user, params, last_page)
      # cart = current_cart
      # if user = login(user_info[:email], user_info[:password])
      #   session[:last_page] = last_page
      #   successful_first_login(cart, user)
      # end
    else
      render :new
    end
  end

  def establish_session(user, params, last_page)
    cart = current_cart
    if user = login(params[:user][:email], params[:user][:password])
      session[:last_page] = last_page
      successful_first_login(cart, user)
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
end
