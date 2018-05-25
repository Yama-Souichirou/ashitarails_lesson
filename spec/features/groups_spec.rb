require 'rails_helper'

RSpec.feature 'groups', type: :feature, js: true do
  let(:user) { FactoryGirl.create(:user) }
  
  before do
    login(user)
  end
  
  describe 'groups new' do
    before { visit new_group_path }
    
    describe 'create group' do
      it 'groups count 1' do
        expect {
          fill_in 'group[name]', with: 'あしたのチーム'
          find('.data-submit').click
      
          expect(page).to have_content '作成しました'
        }.to change(Group, :count).by(1)
      end
    end
    
    describe 'select user' do
      it 'groups users count 1' do
        expect {
          fill_in 'group[name]', with: 'あしたのチーム'
          page.find('.ms-elem-selectable', text: 'yamasou').click
          find('.data-submit').click

          expect(page).to have_content '作成しました'
        }.to change(GroupUser, :count).by(1)
      end
    end
  end
  
  describe 'groups index' do
    describe 'user click another groups' do
      before do
        different_group = FactoryGirl.create(:group)
        different_user = FactoryGirl.create(:user, email: "different_user@sample")
        FactoryGirl.create(:group_user, group: different_group, user: different_user)
        visit groups_path
      end
  
      it 'redirect groups_path'do
        page.all('tbody tr')[0].click
        expect(current_path).to eq groups_path
        expect(page).to have_content 'このプロジェクトに参加しておりません'
      end
    end

    describe 'user click my groups' do
      let(:group) { FactoryGirl.create(:group) }
      before do
        FactoryGirl.create(:group_user, group: group, user: user)
        visit groups_path
      end
  
      it 'redirect groups_path'do
        page.all('tbody tr')[0].click
        expect(current_path).to eq group_path(group.id)
      end
    end
  end
end
