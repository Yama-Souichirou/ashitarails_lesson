require 'rails_helper'

RSpec.describe GroupUser, type: :model do
  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user) }
  it "is valid with a group, user" do
    group_user = FactoryGirl.build(:group_user, user: user, group: group)
    expect(group_user).to be_valid
  end
  
end
