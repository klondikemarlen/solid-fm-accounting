# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# These categories use CRA's published operating-expense names. Tax calculations are out of scope.

category_attributes = [
  {
    code: "business-income",
    name: "Business Income",
    transaction_type: "income"
  },
  {
    code: "accounting-and-legal-fees",
    name: "Accounting and Legal Fees",
    transaction_type: "expense"
  },
  {
    code: "advertising",
    name: "Advertising",
    transaction_type: "expense"
  },
  {
    code: "business-taxes-fees-licences-and-dues",
    name: "Business Taxes, Fees, Licences and Dues",
    transaction_type: "expense"
  },
  {
    code: "insurance",
    name: "Insurance",
    transaction_type: "expense"
  },
  {
    code: "interest-and-bank-charges",
    name: "Interest and Bank Charges",
    transaction_type: "expense"
  },
  {
    code: "maintenance-and-repairs",
    name: "Maintenance and Repairs",
    transaction_type: "expense"
  },
  {
    code: "meals-and-entertainment",
    name: "Meals and Entertainment",
    transaction_type: "expense"
  },
  {
    code: "office-expenses",
    name: "Office Expenses",
    transaction_type: "expense"
  },
  {
    code: "salaries-and-employer-contributions",
    name: "Salaries and Employer Contributions",
    transaction_type: "expense"
  },
  {
    code: "business-start-up-costs",
    name: "Business Start-up Costs",
    transaction_type: "expense"
  },
  {
    code: "motor-vehicle-expenses",
    name: "Motor Vehicle Expenses",
    transaction_type: "expense"
  }
]

category_attributes.each do |attributes|
  category = Category.find_or_initialize_by(code: attributes.fetch(:code))
  category.assign_attributes(attributes)
  category.save!
end

[ "Cash", "Cheque", "Debit Card", "Credit Card", "Bank Transfer" ].each do |name|
  PaymentMethod.find_or_create_by!(name:)
end
