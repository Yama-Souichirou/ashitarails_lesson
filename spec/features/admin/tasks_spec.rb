require 'rails_helper'

RSpec.feature 'Tasks', type: :feature, js: true do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:group) { FactoryGirl.create(:group) }
  let(:group_user) { FactoryGirl.create(:group_user, user: admin, group: group) }

  before do
    admin
    visit new_session_path
    fill_in 'メールアドレス', with: 's.yama@admin.com'
    fill_in 'パスワード', with: 'password'
    click_on 'Sign In'
    visit root_path
  end
  
  describe 'delete task'do
    before do
      group_user
      task = FactoryGirl.create(:task, user: admin, responsible: admin, group: group)
      visit admin_task_path(task)
    end
    
    it 'change Task count -1' do
      expect {
        find('.btn-danger').click
        page.accept_confirm
        
        expect(page).to have_content '削除しました'
      }.to change(Task, :count).by(-1)
    end
  end
  
  describe 'sort'do
    context 'click thead "期日"' do
      before do
        1.upto(3) do |i|
          FactoryGirl.create(:task, user: admin, responsible: admin, group: group, deadline_on: Date.today + i.day)
        end
        visit root_path
      end
      
      context 'click link once' do
        before do
          click_link '期日'
          click_link '全タスク'
          sleep 1
        end
        it 'ordered deadline_on ASC' do
          expect(page.all('tbody tr')[0].find('.td-deadlineon').text).to match "#{(Date.today + 1.day).strftime('%Y/%m/%d')}"
          expect(page.all('tbody tr')[1].find('.td-deadlineon').text).to match "#{(Date.today + 2.day).strftime('%Y/%m/%d')}"
          expect(page.all('tbody tr')[2].find('.td-deadlineon').text).to match "#{(Date.today + 3.day).strftime('%Y/%m/%d')}"
        end
      end
      
      context 'click link twice' do
        before do
          click_link '期日'
          click_link '期日'
          find('#all_tasks_tab_link').click
          sleep 1
        end
        it 'ordered deadline_on DESC' do
          expect(page.all('tbody tr')[0].find('.td-deadlineon').text).to match "#{(Date.today + 3.day).strftime('%Y/%m/%d')}"
          expect(page.all('tbody tr')[1].find('.td-deadlineon').text).to match "#{(Date.today + 2.day).strftime('%Y/%m/%d')}"
          expect(page.all('tbody tr')[2].find('.td-deadlineon').text).to match "#{(Date.today + 1.day).strftime('%Y/%m/%d')}"
        end
      end
    end
    
    context 'click link thead "優先度"' do
      before do
        0.upto(3) do |i|
          FactoryGirl.create(:task, user: admin, responsible: admin, group: group, priority: Task.priorities.keys[i])
        end
        visit root_path
      end
      
      context 'click link once' do
        before do
          click_link '優先度'
        end
        it 'ordered priority ASC' do
          expect(page.all('tbody tr')[0].find('.td-priority').text).to match 'いつでも'
          expect(page.all('tbody tr')[1].find('.td-priority').text).to match '普通'
          expect(page.all('tbody tr')[2].find('.td-priority').text).to match '優先'
          expect(page.all('tbody tr')[3].find('.td-priority').text).to match '最優先'
        end
      end
      
      context 'click link twice' do
        before do
          click_link '優先度'
          click_link '優先度'
        end
        it 'ordered priority ASC' do
          expect(page.all('tbody tr')[0].find('.td-priority').text).to match '最優先'
          expect(page.all('tbody tr')[1].find('.td-priority').text).to match '優先'
          expect(page.all('tbody tr')[2].find('.td-priority').text).to match '普通'
          expect(page.all('tbody tr')[3].find('.td-priority').text).to match 'いつでも'
        end
      end
    end

  end
  
  describe 'search'do
    before do
      20.times { FactoryGirl.create(:task, user: admin, responsible: admin, group: group, status: 1) }
      visit root_path
    end
    
    context 'fill in title field' do
      before do
        Task.first.update(title: 'これはタスク')
        fill_in 'search_title', with: 'これはタスク'
        click_button 'search-button'
      end
      
      it 'display result' do
        expect(page.all('tbody tr').size).to eq 1
      end
    end
    
    context 'select status' do
      before { find('.detail-toggle-btn').click }
      context '完了' do
        before do
          Task.first.update(status: 3)
          select '完了',  from: 'search_status'
          click_button 'search-button'
          click_link '全タスク'
          sleep 1
        end
        
        it 'size 1' do
          expect(page.all('tbody tr').size).to eq 1
        end
      end
      
      context '着手中' do
        before do
          Task.first.update(status: 2)
          select '着手中',  from: 'search_status'
          click_button 'search-button'
        end
        
        it 'size 1' do
          expect(page.all('tbody tr').size).to eq 1
        end
      end
      
      context '未着手' do
        before do
          select '未着手',  from: 'search_status'
          click_button 'search-button'
        end
        
        it 'return 20' do
          expect(page.all('tbody tr').size).to eq 20
        end
      end
    end
  end
  
  describe 'paginate' do
    context 'create 30 tasks' do
      before do
        30.times { FactoryGirl.create(:task, user: admin, responsible: admin, group: group) }
        visit root_path
      end
      
      it 'return 25 tasks' do
        expect(page.all('tbody tr').size).to eq 25
      end
    end
  end
end
