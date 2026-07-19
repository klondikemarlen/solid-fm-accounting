require "minitest/mock"

require "test_helper"

class Api::PaymentMethodsControllerTest < ActionController::TestCase
  tests Api::PaymentMethodsController

  test "requires authentication" do
    get :index, as: :json

    assert_response :unauthorized
  end

  test "lists active payment methods" do
    user = create_user
    payment_method = PaymentMethod.create!(name: "Credit Card")
    deleted_payment_method = PaymentMethod.create!(name: "Old Payment Method")
    deleted_payment_method.destroy

    with_current_user(user) { get :index, as: :json }

    assert_response :success
    assert_equal [ payment_method.id ], response.parsed_body.map { |entry| entry.fetch("id") }
    assert_equal "Credit Card", response.parsed_body.first.fetch("name")
  end

  private

  def with_current_user(user)
    @controller.stub(:authenticate_user!, nil) do
      @controller.stub(:current_user, user) { yield }
    end
  end

  def create_user
    User.create!(
      auth0_subject: "auth0|#{SecureRandom.uuid}",
      email: "#{SecureRandom.uuid}@example.test",
      first_name: "Test",
      display_name: "Test User"
    )
  end
end
