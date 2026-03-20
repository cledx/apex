module Manager
    class ConsultationsController < BaseController
        def index
            @consultations = Consultation.all
        end

        def show
            @consultation = Consultation.find(params[:id])
        end

        def destroy
            @consultation = Consultation.find(params[:id])
            if @consultation.soft_delete
                redirect_to manager_consultations_path, notice: "Consultation was successfully deleted."
            else
                redirect_to manager_consultation_path(@consultation), alert: "Failed to delete consultation."
            end
        end

        private

        def consultation_params
            params.require(:consultation).permit(:phone_number, :address, :details, :client_name, :email)
        end
    end
end