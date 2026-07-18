class Category < ApplicationRecord
  TRANSACTION_TYPES = {
    income: "income",
    expense: "expense",
    both: "both"
  }.freeze

  has_many :transactions, dependent: :restrict_with_exception

  enum :transaction_type, TRANSACTION_TYPES, validate: true

  validates :code, :name, presence: true
  validates :code, :name, uniqueness: true
end
