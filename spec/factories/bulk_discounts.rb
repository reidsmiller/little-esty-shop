FactoryBot.define do
  factory :bulk_discount do
    discount_percent { rand(0.00..0.99) }
    quantity_threshold { rand(0..30) }
  end
end