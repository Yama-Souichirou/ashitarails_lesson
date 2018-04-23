FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "タスク名#{n}" }
    deadline_on Date.today
    status    1
    priority  1
  end
end
