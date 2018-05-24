require 'rails_helper'

RSpec.feature 'Calendar', type: :feature, js: true do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:group_user) { FactoryGirl.create(:group_user, user: user, group: group) }
  let(:today) { Date.today }

  before do
    user
    visit new_session_path
    fill_in 'メールアドレス', with: 's.yama@ashita-team.com'
    fill_in 'パスワード', with: 'password'
    click_on 'Sign In'
    visit calendar_tasks_path
  end

  describe 'calendar is tomonth' do
    before do
      @index = today.beginning_of_month.wday
    end
    it "display today year and month" do
      expect(page).to have_content "#{today.year}年#{today.month}月"
    end

    it '2018/5/1 is Tuesday' do
      expect(find('tbody').all('tr')[0].all('td')[@index]).to have_content "1"
    end
  end

  describe 'click shift link' do
    let(:next_month) { Date.today + 1.month }
    let(:prev_month) { Date.today - 1.month }

    describe 'click back link' do
      it 'display prev month' do
        find('.flex .back').click
        expect(page).to have_content "#{prev_month.year}年#{prev_month.month}月"
      end
    end

    describe 'click next link' do
      it 'display next month' do
        find('.flex .next').click
        expect(page).to have_content "#{next_month.year}年#{next_month.month}月"
      end
    end
  end

  describe 'click day' do
    before do
      FactoryGirl.create(:task, user: user, responsible: user, group: group, deadline_on: today.beginning_of_month, title: "タスク0")
      FactoryGirl.create(:task, user: user, responsible: user, group: group, deadline_on: today.beginning_of_month + 1.day, title: "タスク1")
      FactoryGirl.create(:task, user: user, responsible: user, group: group, deadline_on: today.beginning_of_month + 2.day, title: "タスク2")
      @index = today.beginning_of_month.wday
      visit calendar_tasks_path
    end

    context 'click 1 day' do
      before { find('tbody').all('tr')[0].all('td')[@index].click }

      it 'display task "タスク0"' do
        expect(page.first('.selected-tasks').all('.panel')[0]).to have_content "タスク0"
      end
    end

    context 'click 2 day' do
      before { find('tbody').all('tr')[0].all('td')[@index + 1].click }

      it 'display task "タスク1"' do
        expect(page.first('.selected-tasks').all('.panel')[0]).to have_content "タスク1"
      end
    end

    context 'click 3 day' do
      before { find('tbody').all('tr')[0].all('td')[@index + 2].click }

      it 'display task "タスク2"' do
        expect(page.first('.selected-tasks').all('.panel')[0]).to have_content "タスク2"
      end
    end

    context 'click 4 day' do
      before { find('tbody').all('tr')[0].all('td')[@index + 3].click }

      it 'not task' do
        expect(page).to have_content '期日のタスクはありません'
        expect(page.first('.selected-tasks').all('.panel').empty?).to eq true
      end
    end
  end

end
