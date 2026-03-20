class ConsultationMailer < ApplicationMailer

    def consultation_email_client(consultation)
        @consultation = consultation
        if @consultation.email.present?
            mail(to: @consultation.email, subject: "Your consultation has been received", layout: "consultation_received_client")
            return true
        else    
            return false
        end
    end

    def consultation_email_manager(consultation)
        @consultation = consultation
        mail(to: "apexestatesales@gmx.com", subject: "New consultation received", layout: "new_consultation_received_manager")
    end
end