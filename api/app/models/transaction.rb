class Transaction < ApplicationRecord
  TRANSACTION_TYPES = {
    income: "income",
    expense: "expense"
  }.freeze

  MAX_RECEIPT_SIZE = 10.megabytes

  belongs_to :user
  belongs_to :category, -> { with_deleted }
  belongs_to :payment_method, -> { with_deleted }
  belongs_to :account, -> { with_deleted }
  has_many_attached :receipts

  enum :transaction_type, TRANSACTION_TYPES, validate: true

  validates :transaction_date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validate :account_belongs_to_user
  validate :category_supports_transaction_type
  validate :receipts_are_images_or_pdfs
  validate :receipts_are_within_size_limit

  private

  def account_belongs_to_user
    return if account.blank? || user.blank? || account.user_id == user.id

    errors.add(:account, "must belong to the transaction user")
  end

  def receipts_are_images_or_pdfs
    return if receipts.all? { |receipt| receipt.content_type == "application/pdf" || receipt.content_type&.start_with?("image/") }

    errors.add(:receipts, "must be images or PDFs")
  end

  def receipts_are_within_size_limit
    return if receipts.all? { |receipt| receipt.byte_size <= MAX_RECEIPT_SIZE }

    errors.add(:receipts, "must be 10 MB or smaller")
  end

  def category_supports_transaction_type
    return if category.blank? || transaction_type.blank?
    return if category.both? || category.transaction_type == transaction_type

    errors.add(:category, "must support the transaction type")
  end
end
