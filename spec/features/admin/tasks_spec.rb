require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  let(:admin) { FactoryGirl.create(:admin) }
  before do
    admin
    visit new_session_path
    fill_in 'メールアドレス', with: 's.yama@admin.com'
    fill_in 'パスワード', with: 'password'
    click_on 'Sign In'
    visit admin_tasks_path
  end
  
  describe 'create task', js: true do
    it 'change Task count 1' do
      expect {
        find('#newtask_tab_link').click
        fill_in 'task_title', with: 'this is a test'
        fill_in 'task_deadline_on', with: '2018-04-04'
        find('.main-btn').click
        
        expect(page).to have_content 'タスクを登録しました'
      }.to change(Task, :count).by(1)
    end
  end
  
  describe 'delete task', js: true do
    before do
      FactoryGirl.create(:task, user: admin, responsible: admin)
      visit admin_tasks_path
    end
    
    it 'change Task count -1' do
      expect {
        page.all('tbody tr')[0].find('.btn').click
        find('.delete-task-btn').click
        page.accept_confirm
        
        expect(page).to have_content '削除しました'
      }.to change(Task, :count).by(-1)
    end
  end
  
  describe 'search' do
    before do
      20.times { FactoryGirl.create(:task, user: admin, responsible: admin, status: 1) }
      visit admin_tasks_path
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
    
    context 'select status' do
      before { find('.detail-toggle-btn').click }
      context '完了' do
        before do
          Task.first.update(status: 3)
          select '完了',  from: 'search_status'
          click_button 'search-button'
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
        30.times { FactoryGirl.create(:task, user: admin, responsible: admin) }
        visit admin_tasks_path
      end
      
      it 'return 25 tasks' do
        expect(page.all('tbody tr').size).to eq 25
      end
    end
  end
end
