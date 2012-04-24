class RetirementsController < ApplicationController

  def create
    retirement = Retirement.new(params[:product_id])
    retirement.retire

    redirect_to admin_products_path
  end

  def update
    Retirement.new(params[:product_id]).activate
    redirect_to admin_products_path
  end

end