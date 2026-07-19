require "minitest/mock"

require "test_helper"

class Api::CategoriesControllerTest < ActionController::TestCase
  tests Api::CategoriesController

  test "requires authentication" do
    get :index, as: :json

    assert_response :unauthorized
  end

  test "lists active categories with camelCase fields" do
    user = create_user
    category = Category.create!(
      code: "office-expenses-#{SecureRandom.uuid}",
      name: "Office Expenses",
      transaction_type: "expense"
    )
    deleted_category = Category.create!(
      code: "old-category-#{SecureRandom.uuid}",
      name: "Old Category",
      transaction_type: "expense"
    )
    deleted_category.destroy

    with_current_user(user) { get :index, as: :json }

    assert_response :success
    assert_equal [ category.id ], response.parsed_body.map { |entry| entry.fetch("id") }
    assert_equal "expense", response.parsed_body.first.fetch("transactionType")
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
