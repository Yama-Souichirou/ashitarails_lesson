require 'rails_helper'

RSpec.describe Label, type: :model do
  it 'is valid with a name' do
    label = FactoryGirl.build(:label)
    expect(label).to be_valid
  end
  
  describe 'validate' do
    it 'is invalid without name' do
      label = FactoryGirl.build(:label, name: nil)
      label.valid?
      expect(label.errors[:name]).to include("を入力してください")
    end
  end
end
