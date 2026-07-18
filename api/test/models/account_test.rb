require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "requires a supported account type" do
    account = Account.new(
      user: create_user,
      name: "Business Chequing",
      account_type: "investment"
    )

    assert_not account.valid?
    assert_includes account.errors[:account_type], "is not included in the list"
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
end
