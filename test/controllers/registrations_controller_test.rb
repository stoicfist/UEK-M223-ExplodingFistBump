require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_registration_url
    assert_response :success
  end

  test "should create" do
    assert_difference("User.count") do
      post registrations_url, params: {
        user: {
          email_address: "t#{SecureRandom.hex(4)}@example.com",
          password: "secret123",
          password_confirmation: "secret123"
        }
      }
    end
    assert_response :redirect
  end
end
