require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build(:user, 
                  username: "emmvs",
                  first_name: "Emma Anna Agneta",
                  last_name: "Ruenzel",
                  email: "emma@test.com",
                  password: "123456"
                )
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = User.new(username: nil)
    expect(user).not_to be_valid
  end

  # describe "#custom_method" do
  #   it 'does something useful' do
  #     user = User.create(username: 'Emma', email: 'emma@test.com')
  #     expect(user.custom_method).to eq(expected_result)
  #   end
  # end
end
