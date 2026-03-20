class ConsultationMailer < ApplicationMailer
  def consultation_email_client(consultation)
    @consultation = consultation
    mail(to: @consultation.email, subject: "Your consultation has been received")
  end

  def consultation_email_manager(consultation)
    @consultation = consultation
    mail(to: "apexestatesales@gmx.com", subject: "New consultation received")
  end
end
