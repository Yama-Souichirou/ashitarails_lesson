FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "タスク名#{n}" }
    deadline_on Date.today
    status         1
    priority       1
    
    association :user, factory: :create_user
    association :responsible, factory: :responsible_user
  end
end
