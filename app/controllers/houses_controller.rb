class HousesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @houses = House.where("end_date > ?", Date.today).where(deleted_at: nil)
  end

  def old_sales
    @houses = House.where("end_date <= ?", Date.today).where(deleted_at: nil)
  end

  def show
    @house = House.find(params[:id])
  end
end
