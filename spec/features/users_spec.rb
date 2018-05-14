require 'rails_helper'

RSpec.feature "Tasks", type: :feature, js: true do
  let(:user) { FactoryGirl.create(:user) }
  before do
    user
    visit new_session_path
    fill_in 'メールアドレス', with: "s.yama@ashita-team.com"
    fill_in 'パスワード', with: "password"
    click_on 'Sign In'
  end
  
  context "task count 0" do
    it "should have content 担当しているタスクはありません" do
      visit user_path(user)
      expect(page).to have_content '担当しているタスクはありません'
    end
  end
  
  describe "click '完了にする'" do
    before { FactoryGirl.create(:task, user: user, responsible: user) }
    it "change Task count 0" do
      visit user_path(user)
      
      page.first('.data-submit').click
      expect(page).to have_content "タスクを登録しました"
      page.all('.users-tasks').count eq 0
    end
  end
end
