require 'rails_helper'

RSpec.describe User, type: :model do
  context "with duplicate emails" do
    it "does not allow the second user to sign up" do
      user_1 = User.new(
        email_address: "samson@example.com",
        password: "password"
      )
      user_2 = user_1.dup

      user_1.save
      user_2.save

      expect(User.count).to eq(1)
    end
  end
end
