class ConsultationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @consultation = Consultation.new
  end

  def create
    @consultation = Consultation.new(consultation_params)
    if @consultation.save
      
      redirect_to root_path, notice: "Thanks — we'll be in touch about your consultation."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def consultation_params
    params.require(:consultation).permit(:client_name, :email, :phone_number, :address, :details)
  end
end
