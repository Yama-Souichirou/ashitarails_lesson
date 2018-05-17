FactoryGirl.define do
  factory :user, class: "User" do
    username "yamasou"
    password "password"
    password_confirmation "password"
    email "s.yama@ashita-team.com"

    trait :with_group do
      association :group, factory: :group
    end
  end

  factory :create_user, class: User do
    username "yamasou"
    password "password"
    password_confirmation "password"
    sequence(:email) { |n| "creater#{n}@ashita-team.com" }
  end

  factory :responsible_user, class: User do
    username "yamaguti"
    password "password"
    password_confirmation "password"
    sequence(:email) { |n| "responsibler#{n}@ashita-team.com" }
  end
  
  factory :admin, class: "User" do
    username "yamasou"
    password "password"
    password_confirmation "password"
    role 1
    email "s.yama@admin.com"

    trait :with_group do
      association :group, factory: :group
    end
  end
end
