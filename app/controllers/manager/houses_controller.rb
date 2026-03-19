module Manager
  class HousesController < BaseController
    before_action :set_house, only: [:show, :edit, :update, :destroy]

    def show
    end

    def new
      if user_signed_in? && current_user.manager?
        @house = House.new
      else
        redirect_to houses_path, alert: "You are not authorized to access this page."
      end
    end

    def create
      @house = House.new(house_params)
      if @house.save
        redirect_to manager_house_path(@house), notice: "House was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @house.update(house_params)
        redirect_to manager_house_path(@house), notice: "House was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @house.soft_delete
        redirect_to manager_houses_path, notice: "House was successfully deleted."
      else
        redirect_to manager_house_path(@house), alert: "Failed to delete house."
      end
    end

    private

    def set_house
      @house = House.find(params[:id])
    end

    def house_params
      params.require(:house).permit(:address, :name, :owner, :description, :start_date, :end_date, :tags, photos: [])
    end
  end
end
