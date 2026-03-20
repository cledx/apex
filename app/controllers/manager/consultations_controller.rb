module Manager
  class ConsultationsController < BaseController
    def index
      @consultations = Consultation.open.order(created_at: :desc)
    end

    def update
      @consultation = Consultation.open.find(params[:id])
      contacted = ActiveModel::Type::Boolean.new.cast(params.dig(:consultation, :contacted))
      contacted_at = contacted ? (@consultation.contacted_at || Time.current) : nil
      @consultation.assign_attributes(consultation_update_params)
      @consultation.contacted_at = contacted_at

      if @consultation.save
        redirect_to manager_consultations_path, notice: "Consultation updated."
      else
        @consultations = Consultation.open.order(created_at: :desc)
        flash.now[:alert] = @consultation.errors.full_messages.to_sentence
        render :index, status: :unprocessable_entity
      end
    end

    def close
      @consultation = Consultation.open.find(params[:id])
      if @consultation.update(closed_at: Time.current)
        redirect_to manager_consultations_path, notice: "Consultation closed."
      else
        redirect_to manager_consultations_path, alert: "Could not close consultation."
      end
    end

    def closed
      @consultations = Consultation.visible.where.not(closed_at: nil).order(closed_at: :desc)
    end

    def destroy
      @consultation = Consultation.visible.find(params[:id])
      if @consultation.soft_delete
        redirect_to manager_consultations_path, notice: "Consultation was successfully deleted."
      else
        redirect_to manager_consultations_path, alert: "Failed to delete consultation."
      end
    end

    private

    def consultation_update_params
      params.require(:consultation).permit(:details)
    end
  end
end