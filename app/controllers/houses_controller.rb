class HousesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :old_sales]

  def index
    @houses = House.where("end_date > ?", Date.today).where(deleted_at: nil)
  end

  def old_sales
    @houses = House.where("end_date <= ?", Date.today).where(deleted_at: nil)
  end

  def show
    @house = House.find(params[:id])
    @items = @house.items.where(deleted_at: nil)
    @categories = @items.pluck(:category).compact_blank.uniq.sort
  end
end
