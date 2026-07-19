require "test_helper"
require "minitest/mock"

class Api::AccountsControllerTest < ActionController::TestCase
  tests Api::AccountsController

  setup do
    @user = create_user
  end

  test "requires authentication" do
    get :index, as: :json

    assert_response :unauthorized
  end

  test "lists only the current user's accounts" do
    account = create_account(@user, name: "Operating Chequing")
    create_account(create_user, name: "Other User Cash")

    with_current_user(@user) { get :index, as: :json }

    assert_response :success
    assert_equal [ account_json(account) ], response.parsed_body
  end

  test "creates an account" do
    with_current_user(@user) do
      post :create,
        params: { account: { name: "Petty Cash", account_type: "cash" } },
        as: :json
    end

    assert_response :created
    account = @user.accounts.find_by!(name: "Petty Cash")
    assert_equal account_json(account), response.parsed_body
  end

  test "returns camelCase validation errors" do
    with_current_user(@user) do
      post :create,
        params: { account: { name: "", account_type: "invalid" } },
        as: :json
    end

    assert_response :unprocessable_entity
    assert_includes response.parsed_body.fetch("errors"), "name"
    assert_includes response.parsed_body.fetch("errors"), "accountType"
  end

  test "updates an account" do
    account = create_account(@user)

    with_current_user(@user) do
      patch :update,
        params: { id: account.id, account: { name: "Business Savings", account_type: "savings" } },
        as: :json
    end

    assert_response :success
    assert_equal "Business Savings", account.reload.name
    assert_equal "savings", account.account_type
  end

  test "does not expose another user's account" do
    account = create_account(create_user)

    with_current_user(@user) do
      patch :update,
        params: { id: account.id, account: { name: "Not Allowed", account_type: "cash" } },
        as: :json
    end

    assert_response :not_found
    assert_equal "Account not found", response.parsed_body.fetch("message")
    assert_equal "Business Chequing", account.reload.name
  end

  test "soft deletes an account without transactions" do
    account = create_account(@user)

    with_current_user(@user) { delete :destroy, params: { id: account.id }, as: :json }

    assert_response :no_content
    assert_not Account.exists?(account.id)
    assert Account.with_deleted.exists?(account.id)
  end

  test "does not delete an account with transactions" do
    account = create_account(@user)
    Transaction.create!(
      user: @user,
      account:,
      category: Category.create!(
        code: "office-expenses-#{SecureRandom.uuid}",
        name: "Office Expenses",
        transaction_type: "expense"
      ),
      payment_method: PaymentMethod.create!(name: "Cash"),
      transaction_type: "expense",
      transaction_date: Date.current,
      amount: 12.34
    )

    with_current_user(@user) { delete :destroy, params: { id: account.id }, as: :json }

    assert_response :unprocessable_entity
    assert_equal [ "cannot be deleted while transactions exist" ], response.parsed_body.dig("errors", "base")
    assert Account.exists?(account.id)
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

  def create_account(user, name: "Business Chequing", account_type: "chequing")
    Account.create!(user:, name:, account_type:)
  end

  def account_json(account)
    {
      "id" => account.id,
      "name" => account.name,
      "accountType" => account.account_type
    }
  end
end
