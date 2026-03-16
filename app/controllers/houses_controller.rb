class HousesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @houses = House.where("start_date > ?", Date.today)
  end

  def old_sales
    @houses = House.where("start_date < ?", Date.today)
  end

  def show
    @house = House.find(params[:id])
  end
end
