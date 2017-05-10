FactoryGirl.define do
  factory :account do
    name { |n| "Account #{n}" }
  end
end
