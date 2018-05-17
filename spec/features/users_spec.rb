require 'rails_helper'

RSpec.feature "Users", type: :feature, js: true do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  
  before do
    user
    visit new_session_path
    fill_in 'メールアドレス', with: "s.yama@ashita-team.com"
    fill_in 'パスワード', with: "password"
    click_on 'Sign In'
    visit user_path(user)
  end
  
  context "task count 0" do
    it "should have content 担当しているタスクはありません" do
      expect(page).to have_content '担当しているタスクはありません'
    end
  end
  
  describe "click '完了にする'" do
    before do
      FactoryGirl.create(:task, user: user, responsible: user, group: group)
      visit current_path
    end
    
    it "change Task count 0" do
      page.first('.data-submit').click
      expect(page).to have_content "更新しました"
      page.all('.users-tasks').count eq 0
    end
  end
end
