module ApplicationHelper
  def consultation_nav_needs_attention?
    return false unless user_signed_in?
    return false if current_user.role == "customer"

    Consultation.awaiting_contact.exists?
  end
end
