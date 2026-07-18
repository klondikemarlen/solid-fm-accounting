require "test_helper"

class PaymentMethodTest < ActiveSupport::TestCase
  test "requires a unique name" do
    PaymentMethod.create!(name: "Credit Card")
    duplicate_payment_method = PaymentMethod.new(name: "Credit Card")

    assert_not duplicate_payment_method.valid?
  end
end
