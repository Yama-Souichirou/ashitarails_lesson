require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  let(:admin) { FactoryGirl.create(:admin) }
  before do
    admin
    visit new_session_path
    fill_in 'メールアドレス', with: 's.yama@admin.com'
    fill_in 'パスワード', with: 'password'
    click_on 'Sign In'
    visit admin_labels_path
  end
  
  describe 'create label' do
    it 'change label count 1' do
      expect {
        fill_in 'label_name', with: "ラベル1"
        click_button '登録'
      }.to change(Label, :count).by(1)
    end
  end
  
  describe 'delete label', js: true do
    let(:label) { FactoryGirl.create(:label) }
    
    describe 'have no tasks' do
      before do
        label
        visit admin_labels_path
      end
      
      it 'change label count 0' do
        expect {
          page.all('tbody tr')[0].find('.delete-label-btn').click
          page.accept_confirm
      
          expect(page).to have_content '削除しました'
        }.to change(Label, :count).by(-1)
      end
    end
    
    context 'have tasks' do
      before do
        task = FactoryGirl.create(:task, :with_user, :with_responsible, :with_group)
        TaskLabel.create(task_id: task.id, label_id: label.id)
        visit admin_labels_path
      end
      
      it 'can not delete' do
        expect {
          page.all('tbody tr')[0].find('.delete-label-btn').click
          page.accept_confirm
          expect(page).to have_content '削除できませんでした'
        }.to change(Label, :count).by(0)
      end
    end
  end
  
end
