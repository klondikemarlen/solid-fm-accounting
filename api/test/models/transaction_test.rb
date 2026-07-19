require "stringio"
require "tempfile"

require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "accepts a complete positive transaction" do
    user = create_user
    transaction = Transaction.new(
      user:,
      category: create_category,
      payment_method: PaymentMethod.create!(name: "Credit Card"),
      account: create_account(user),
      transaction_type: "expense",
      transaction_date: Date.current,
      amount: 12.34,
      vendor: "Office Supply Store"
    )

    assert_predicate transaction, :valid?
  end

  test "rejects a zero amount" do
    user = create_user
    transaction = Transaction.new(
      user:,
      category: create_category,
      payment_method: PaymentMethod.create!(name: "Credit Card"),
      account: create_account(user),
      transaction_type: "expense",
      transaction_date: Date.current,
      amount: 0
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:amount], "must be greater than 0"
  end

  test "requires an account owned by the transaction user" do
    user = create_user
    transaction = Transaction.new(
      user:,
      category: create_category,
      payment_method: PaymentMethod.create!(name: "Credit Card"),
      account: create_account(create_user),
      transaction_type: "expense",
      transaction_date: Date.current,
      amount: 12.34
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:account], "must belong to the transaction user"
  end

  test "requires a category that supports the transaction type" do
    user = create_user
    transaction = Transaction.new(
      user:,
      category: Category.create!(
        code: "business-income-#{SecureRandom.uuid}",
        name: "Business Income",
        transaction_type: "income"
      ),
      payment_method: PaymentMethod.create!(name: "Credit Card"),
      account: create_account(user),
      transaction_type: "expense",
      transaction_date: Date.current,
      amount: 12.34
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:category], "must support the transaction type"
  end

  test "rejects receipts other than images and PDFs" do
    user = create_user
    transaction = Transaction.new(
      user:,
      category: create_category,
      payment_method: PaymentMethod.create!(name: "Credit Card"),
      account: create_account(user),
      transaction_type: "expense",
      transaction_date: Date.current,
      amount: 12.34
    )
    transaction.receipts.attach(
      io: StringIO.new("not a receipt"),
      filename: "receipt.txt",
      content_type: "text/plain"
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:receipts], "must be images or PDFs"
  end

  test "rejects receipts larger than 10 MB" do
    file = nil
    user = create_user
    transaction = Transaction.new(
      user:,
      category: create_category,
      payment_method: PaymentMethod.create!(name: "Credit Card"),
      account: create_account(user),
      transaction_type: "expense",
      transaction_date: Date.current,
      amount: 12.34
    )
    file = Tempfile.new("receipt")
    file.truncate(Transaction::MAX_RECEIPT_SIZE + 1)
    file.rewind
    transaction.receipts.attach(
      io: file,
      filename: "receipt.pdf",
      content_type: "application/pdf"
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:receipts], "must be 10 MB or smaller"
  ensure
    file&.close!
  end

  test "attaches multiple receipts" do
    user = create_user
    transaction = Transaction.create!(
      user:,
      category: create_category,
      payment_method: PaymentMethod.create!(name: "Credit Card"),
      account: create_account(user),
      transaction_type: "expense",
      transaction_date: Date.current,
      amount: 12.34
    )

    transaction.receipts.attach(
      [
        {
          io: StringIO.new("first receipt"),
          filename: "receipt.pdf",
          content_type: "application/pdf"
        },
        {
          io: StringIO.new("second receipt"),
          filename: "receipt.jpg",
          content_type: "image/jpeg"
        }
      ]
    )

    assert_equal 2, transaction.receipts.count
    assert_predicate transaction.receipts, :attached?
  end

  private

  def create_user
    User.create!(
      auth0_subject: "auth0|#{SecureRandom.uuid}",
      email: "#{SecureRandom.uuid}@example.test",
      first_name: "Test",
      display_name: "Test User"
    )
  end

  def create_category
    Category.create!(
      code: "advertising-#{SecureRandom.uuid}",
      name: "Advertising",
      transaction_type: "expense"
    )
  end

  def create_account(user)
    Account.create!(
      user:,
      name: "Business Chequing",
      account_type: "chequing"
    )
  end
end
