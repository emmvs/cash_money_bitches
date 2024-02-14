FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    first_name { Faker::TvShows::RuPaul.queen }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { '123456' }
  end
end
