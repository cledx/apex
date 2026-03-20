class ConsultationMailer < ApplicationMailer

    def consultation_email(consultation)
        @consultation = consultation
        if @consultation.email.present?
            mail(to: @consultation.email, subject: "Your consultation has been received", layout: "consultation_received_client")
        end
        mail(to: "apexestatesales@gmx.com", subject: "New consultation received", layout: "consultation_received_manager")
    end
end