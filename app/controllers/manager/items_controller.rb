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
      remove_photo_ids = item_params[:remove_photo_ids]
      attributes = item_params.except(:remove_photo_ids)

      if @item.update(attributes)
        purge_removed_photos(remove_photo_ids)
        redirect_to item_path(@item), notice: "Item was successfully updated."
      else
        @house = @item.house
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      house = @item.house
      if @item.soft_delete
        redirect_to house_path(house), notice: "Item was successfully deleted."
      else
        redirect_to item_path(@item), alert: "Failed to delete item."
      end
    end

    private
    

    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:house_id, :name, :price, :description, :age, :category, :condition, :tags, photos: [], remove_photo_ids: [])
    end

    def purge_removed_photos(remove_photo_ids)
      return if remove_photo_ids.blank?

      @item.photos.attachments.where(id: remove_photo_ids.reject(&:blank?)).find_each(&:purge_later)
    end
  end
end
