FactoryGirl.define do
  factory :group_user do
    association :user, factory: :user
    association :group, factory: :group
  end
end
