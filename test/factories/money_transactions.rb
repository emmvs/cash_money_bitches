FactoryBot.define do
  factory :money_transaction do
    external_id { "MyString" }
    date { "2025-10-21" }
    description { "MyText" }
    amount_cents { 1 }
    currency { "MyString" }
    direction { "MyString" }
    source_file { "MyString" }
    raw_tags { "MyString" }
    elster_bucket { "MyString" }
    is_business { false }
    receipt { false }
    eigenbeleg { false }
    reviewed { false }
  end
end
