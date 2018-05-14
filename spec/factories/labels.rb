FactoryGirl.define do
  factory :label, class: "Label" do
    sequence(:name) { |n| "サンプルラベル#{n}" }
  end
end
