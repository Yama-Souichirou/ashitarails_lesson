FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "あしたのチーム#{n}" }
  end
end
