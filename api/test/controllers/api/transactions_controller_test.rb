require "minitest/mock"
require "stringio"

require "test_helper"

class Api::TransactionsControllerTest < ActionController::TestCase
  tests Api::TransactionsController

  setup do
    @user = create_user
  end

  test "requires authentication" do
    get :index, as: :json

    assert_response :unauthorized
  end

  test "lists only the current user's transactions with receipt metadata" do
    transaction = create_transaction(@user)
    transaction.receipts.attach(
      io: StringIO.new("receipt"),
      filename: "receipt.pdf",
      content_type: "application/pdf"
    )
    create_transaction(create_user)

    with_current_user(@user) { get :index, as: :json }

    assert_response :success
    assert_equal [ transaction.id ], response.parsed_body.map { |entry| entry.fetch("id") }
    assert_equal "application/pdf", response.parsed_body.first.dig("receipts", 0, "contentType")
  end

  test "creates a transaction with multiple receipts" do
    with_current_user(@user) do
      post :create,
        params: {
          transaction: transaction_params.merge(
            receipts: [
              fixture_file_upload("receipt.pdf", "application/pdf"),
              fixture_file_upload("receipt.pdf", "application/pdf")
            ]
          )
        },
        as: :json
    end

    assert_response :created
    assert_equal "12.34", response.parsed_body.fetch("amount")
    assert_equal 2, response.parsed_body.fetch("receipts").size
    assert_equal @user.id, Transaction.find(response.parsed_body.fetch("id")).user_id
  end

  test "returns validation errors for an unsupported receipt" do
    with_current_user(@user) do
      post :create,
        params: {
          transaction: transaction_params.merge(
            receipts: [ fixture_file_upload("receipt.txt", "text/plain") ]
          )
        },
        as: :json
    end

    assert_response :unprocessable_entity
    assert_includes response.parsed_body.dig("errors", "receipts"), "must be images or PDFs"
  end

  test "updates a transaction" do
    transaction = create_transaction(@user)

    with_current_user(@user) do
      patch :update,
        params: {
          id: transaction.id,
          transaction: { vendor: "Updated vendor", description: "Corrected details" }
        },
        as: :json
    end

    assert_response :success
    assert_equal "Updated vendor", transaction.reload.vendor
    assert_equal "Corrected details", response.parsed_body.fetch("description")
  end

  test "does not expose another user's transaction" do
    transaction = create_transaction(create_user)

    with_current_user(@user) { get :show, params: { id: transaction.id }, as: :json }

    assert_response :not_found
    assert_equal "Transaction not found", response.parsed_body.fetch("message")
  end

  test "rejects an account owned by another user" do
    other_account = create_account(create_user)

    with_current_user(@user) do
      post :create,
        params: { transaction: transaction_params.merge(account_id: other_account.id) },
        as: :json
    end

    assert_response :unprocessable_entity
    assert_includes response.parsed_body.dig("errors", "account"), "must belong to the transaction user"
  end

  test "soft deletes a transaction" do
    transaction = create_transaction(@user)

    with_current_user(@user) { delete :destroy, params: { id: transaction.id }, as: :json }

    assert_response :no_content
    assert_not Transaction.exists?(transaction.id)
    assert Transaction.with_deleted.exists?(transaction.id)
  end

  private

  def with_current_user(user)
    @controller.stub(:authenticate_user!, nil) do
      @controller.stub(:current_user, user) { yield }
    end
  end

  def create_transaction(user)
    Transaction.create!(user:, **transaction_params(user:))
  end

  def transaction_params(user: @user)
    {
      account_id: create_account(user).id,
      amount: "12.34",
      category_id: create_category.id,
      payment_method_id: create_payment_method.id,
      transaction_date: "2026-07-19",
      transaction_type: "expense",
      vendor: "Office Supply Store",
      description: "Printer paper"
    }
  end

  def create_user
    User.create!(
      auth0_subject: "auth0|#{SecureRandom.uuid}",
      email: "#{SecureRandom.uuid}@example.test",
      first_name: "Test",
      display_name: "Test User"
    )
  end

  def create_account(user)
    Account.create!(
      user:,
      name: "Business Chequing #{SecureRandom.uuid}",
      account_type: "chequing"
    )
  end

  def create_category
    Category.create!(
      code: "office-expenses-#{SecureRandom.uuid}",
      name: "Office Expenses #{SecureRandom.uuid}",
      transaction_type: "expense"
    )
  end

  def create_payment_method
    PaymentMethod.create!(name: "Credit Card #{SecureRandom.uuid}")
  end
end
