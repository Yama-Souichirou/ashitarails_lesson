require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a username, email, password, password_confirmation' do
    user = FactoryGirl.build(:user)
    expect(user).to be_valid
  end
  
  describe 'validate' do
    it 'is invalid without username' do
      user = FactoryGirl.build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include("を入力してください")
    end
  
    it 'is invalid without email' do
      user = FactoryGirl.build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end
  
    it 'is invalid uniqueness email' do
      FactoryGirl.create(:user, email: "sample@sample.com")
      user = FactoryGirl.build(:user, email: "sample@sample.com")
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end
    
    it 'is invalid not match passworfd and password_confirmatiomn' do
      user = FactoryGirl.build(:user, password: "password", password_confirmation: "passwdwd")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end
  
  it 'is default set normal to role' do
    user = FactoryGirl.create(:user, role: nil)
    expect(user.role).to eq "normal"
  end
end
