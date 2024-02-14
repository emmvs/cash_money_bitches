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
end
