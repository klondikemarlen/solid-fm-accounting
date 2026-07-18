require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "requires a supported transaction type" do
    category = Category.new(
      code: "advertising",
      name: "Advertising",
      transaction_type: "other"
    )

    assert_not category.valid?
    assert_includes category.errors[:transaction_type], "is not included in the list"
  end

  test "does not duplicate an active category code" do
    Category.create!(
      code: "advertising",
      name: "Advertising",
      transaction_type: "expense"
    )
    duplicate_category = Category.new(
      code: "advertising",
      name: "Marketing",
      transaction_type: "expense"
    )

    assert_not duplicate_category.valid?
  end
end
