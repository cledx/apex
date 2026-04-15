require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @password = "password123456"
  end

  test "unconfirmed user is not active for authentication" do
    user = User.new(
      email: "#{SecureRandom.hex(8)}@example.com",
      password: @password,
      password_confirmation: @password,
      role: "customer"
    )
    user.skip_confirmation_notification!
    user.save!

    assert_nil user.confirmed_at
    assert_not user.active_for_authentication?
  end

  test "confirmed user is active for authentication" do
    user = User.create!(
      email: "#{SecureRandom.hex(8)}@example.com",
      password: @password,
      password_confirmation: @password,
      role: "customer",
      confirmed_at: Time.current
    )

    assert user.active_for_authentication?
  end
end
