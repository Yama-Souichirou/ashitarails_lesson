require 'rails_helper'

RSpec.feature "Session new", type: :feature, js: true do
  
  describe "login" do
    before do
      FactoryGirl.create(:user)
    end
    
    it "should have content 'ログインしました'" do
      visit new_session_path
      fill_in 'メールアドレス', with: "s.yama@ashita-team.com"
      fill_in 'パスワード', with: "password"
      click_on 'Sign In'

      expect(page).to have_content "ログインしました"
    end
  end


end
