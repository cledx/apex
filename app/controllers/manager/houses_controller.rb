module Manager
  class HousesController < BaseController
    before_action :set_house, only: [:show, :edit, :update, :destroy]

    def index
      @houses = House.all
    end

    def show
    end

    def new
      @house = House.new
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
      @house.destroy
      redirect_to manager_houses_path, notice: "House was successfully destroyed."
    end

    private

    def set_house
      @house = House.find(params[:id])
    end

    def house_params
      params.require(:house).permit(:address, :name, :owner, :description, :start_date, :end_date, :tags, images: [])
    end
  end
end
