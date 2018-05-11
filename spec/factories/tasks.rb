FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "タスク名#{n}" }
    deadline_on Date.today
    status         1
    priority       1
    
    trait :with_user do
      association :user, factory: :user
    end

    trait :with_responsible do
      association :responsible, factory: :responsible_user
    end
  end
end
