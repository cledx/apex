module Manager
  class ItemsController < BaseController
    before_action :set_item, only: [:edit, :update, :destroy]

    def new
      @item = Item.new(house_id: params[:house_id])
      @house = @item.house || House.find_by(id: params[:house_id])
    end

    def create
      @item = Item.new(item_params)
      if @item.save
        redirect_to item_path(@item), notice: "Item was successfully created."
      else
        @house = @item.house
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @house = @item.house
    end

    def update
      if @item.update(item_params)
        redirect_to item_path(@item), notice: "Item was successfully updated."
      else
        @house = @item.house
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      house = @item.house
      @item.destroy
      redirect_to house_path(house), notice: "Item was successfully destroyed."
    end

    private

    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:house_id, :name, :price, :description, :age, :category, :condition, :tags, images: [])
    end
  end
end
