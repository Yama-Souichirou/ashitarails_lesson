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
  
  describe 'delete' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }
    
    describe 'delete normal user' do
      context 'has no tasks' do
        it 'change count -1' do
          expect { user.destroy }.to change(User, :count).by(-1)
        end
      end

      context 'user has tasks' do
        before do
          FactoryGirl.create(:task, user: user, responsible: admin)
        end
  
        it 'can not delete' do
          user.destroy
          expect(user.errors[:base]).to include('紐付いたタスクがあります')
        end
      end
    end
    
    describe 'delete admin' do
      context 'more 2 admins' do
        before { admin }
    
        it 'can delete' do
          admin2 = FactoryGirl.create(:admin, email: "sample2@admin.com")
          expect { admin2.destroy }.to change(User, :count).by(-1)
        end
      end
  
      context '1 admins' do
        it 'can not delete' do
          admin.destroy
          expect(admin.errors[:base]).to include('少なくとも管理者が１人必要です')
        end
      end
    end
  end
  
  it 'set normal role for default' do
    user = FactoryGirl.create(:user, role: nil)
    expect(user.role).to eq "normal"
  end
end
