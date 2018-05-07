FactoryGirl.define do
  factory :user, class: "User" do
    username "yamasou"
    password "password"
    password_confirmation "password"
    email "s.yama@ashita-team.com"
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
end
