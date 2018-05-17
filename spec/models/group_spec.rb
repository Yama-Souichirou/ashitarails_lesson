require 'rails_helper'

RSpec.describe Group, type: :model do
  it "is valid with a title, deadline_on, status, and priority" do
    group = FactoryGirl.build(:group)
    expect(group).to be_valid
  end
  
  it "is invalid without name" do
    group = FactoryGirl.build(:group, name: nil)
    group.valid?
    expect(group.errors[:name]).to include("を入力してください")
  end
end
