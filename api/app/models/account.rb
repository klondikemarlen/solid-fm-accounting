class Account < ApplicationRecord
  ACCOUNT_TYPES = {
    cash: "cash",
    chequing: "chequing",
    savings: "savings",
    credit_card: "credit_card"
  }.freeze

  belongs_to :user
  has_many :transactions, dependent: :restrict_with_exception

  enum :account_type, ACCOUNT_TYPES, validate: true

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
