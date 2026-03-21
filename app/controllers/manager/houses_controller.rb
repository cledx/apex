module Manager
  class HousesController < BaseController
    before_action :set_house, only: [:show, :edit, :update, :destroy]

    def show
      @items = @house.items.where(deleted_at: nil)
      @categories = @items.pluck(:category).compact_blank.uniq.sort
    end

    def new
      if user_signed_in? && current_user.manager?
        @house = House.new
      else
        redirect_to houses_path, alert: "You are not authorized to access this page."
      end
    end

    def new_from_url
      url = params[:url].to_s.strip
      if url.blank?
        redirect_to new_manager_house_path, alert: "Please enter a URL."
      else
        house = ::HouseImportFromUrl.new(url).call
        redirect_to manager_house_path(house),
                    notice: "Imported sale with #{house.items.count} listing photos."
      end
    rescue StandardError => e
      redirect_to new_manager_house_path(url: url), alert: "Import failed: #{e.message}"
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
      @house = House.find(params[:id])
    end

    def update
      remove_photo_ids = house_params[:remove_photo_ids]
      attributes = house_params.except(:remove_photo_ids)

      if @house.update(attributes)
        purge_removed_photos(remove_photo_ids)
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
      params.require(:house).permit(:address, :name, :owner, :description, :start_date, :end_date, :tags, photos: [], remove_photo_ids: [])
    end

    def purge_removed_photos(remove_photo_ids)
      return if remove_photo_ids.blank?

      @house.photos.attachments.where(id: remove_photo_ids.reject(&:blank?)).find_each(&:purge_later)
    end
  end
end
