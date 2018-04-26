require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  #  画面ごとにdescribe
  describe "fill in field and click button" do
    it "create task" do
      expect {
        visit new_task_path "新規作成"
        fill_in "タスク名", with: "テストタスク"
        fill_in "説明文", with: "this is a test"
        fill_in "期日", with: "2018-04-04"
        
        click_button "登録"
      }.to change(Task, :count).by(1)
    end
  end
  
  
  describe "sort" do
    context "click link th '期日'" do
      before do
        1.upto(3) do |i|
          FactoryGirl.create(:task, deadline_on: Date.today + i)
        end
        visit root_path
        click_link '期日'
      end
      
      context "click link once" do
        it "ordered deadline_on ASC" do
          # 理想は'2018/04/12'のような形で固定
          expect(page.all("tbody tr")[0].find(".td-deadlineon").text).to match "#{(Date.today + 1.day).strftime("%Y/%m/%d")}"
          expect(page.all("tbody tr")[1].find(".td-deadlineon").text).to match "#{(Date.today + 2.day).strftime("%Y/%m/%d")}"
          expect(page.all("tbody tr")[2].find(".td-deadlineon").text).to match "#{(Date.today + 3.day).strftime("%Y/%m/%d")}"
        end
      end
      
      context "click link twice" do
        it "ordered deadline_on DESC" do
          # 理想は'2018/04/12'のような形で固定
          expect(page.all("tbody tr")[2].find(".td-deadlineon").text).to match "#{(Date.today + 3.day).strftime("%Y/%m/%d")}"
          expect(page.all("tbody tr")[1].find(".td-deadlineon").text).to match "#{(Date.today + 2.day).strftime("%Y/%m/%d")}"
          expect(page.all("tbody tr")[0].find(".td-deadlineon").text).to match "#{(Date.today + 1.day).strftime("%Y/%m/%d")}"
        end
      end
    end
    
    context "click link th '優先度'" do
      before do
        0.upto(3) do |i|
          FactoryGirl.create(:task, priority: Task.priorities.keys[i])
        end
        visit root_path
        click_link "優先度"
      end
      
      context "click link once" do
        it "ordered priority ASC" do
          expect(page.all("tbody tr")[0].find(".td-priority").text).to match "いつでも"
          expect(page.all("tbody tr")[1].find(".td-priority").text).to match "普通"
          expect(page.all("tbody tr")[2].find(".td-priority").text).to match "優先"
          expect(page.all("tbody tr")[3].find(".td-priority").text).to match "最優先"
        end
      end
      
      context "click link twice" do
        it "ordered priority ASC" do
          expect(page.all("tbody tr")[3].find(".td-priority").text).to match "最優先"
          expect(page.all("tbody tr")[2].find(".td-priority").text).to match "優先"
          expect(page.all("tbody tr")[1].find(".td-priority").text).to match "普通"
          expect(page.all("tbody tr")[0].find(".td-priority").text).to match "いつでも"
        end
      end
    end
    
    context "click link th '優先度'" do
      before do
        1.upto(3) do |i|
          FactoryGirl.create(:task, created_at: Date.today + i.day)
        end
        visit root_path
        click_link "作成日"
      end
      
      context "click link once" do
        it "ordered created_at ASC" do
          expect(page.all("tbody tr")[0].find(".td-createdat").text).to match "#{(Date.today + 1.day).strftime("%Y/%m/%d 00:00:00")}"
          expect(page.all("tbody tr")[1].find(".td-createdat").text).to match "#{(Date.today + 2.day).strftime("%Y/%m/%d 00:00:00")}"
          expect(page.all("tbody tr")[2].find(".td-createdat").text).to match "#{(Date.today + 3.day).strftime("%Y/%m/%d 00:00:00")}"
        end
      end

      context "click link twice" do
        it "ordered created_at DESC" do
          expect(page.all("tbody tr")[2].find(".td-createdat").text).to match "#{(Date.today + 3.day).strftime("%Y/%m/%d 00:00:00")}"
          expect(page.all("tbody tr")[1].find(".td-createdat").text).to match "#{(Date.today + 2.day).strftime("%Y/%m/%d 00:00:00")}"
          expect(page.all("tbody tr")[0].find(".td-createdat").text).to match "#{(Date.today + 1.day).strftime("%Y/%m/%d 00:00:00")}"
        end
      end
    end
  end
  
  describe "search" do
    before do
      20.times { FactoryGirl.create(:task) }
      visit root_path
    end
    
    context "fill in title field" do
      before do
        Task.first.update(title: "これはタスク")
        fill_in "search_title", with: "これはタスク"
        click_button "search-button"
      end
      
      it "display result" do
        expect(page.all("tbody tr").size).to eq 1
      end
    end
    
    context "select status" do
      context "完了" do
        before do
          Task.first.update(status: 3)
          select "完了",  from: "search_status"
          click_button "search-button"
        end
        
        it "size 1" do
          expect(page.all("tbody tr").size).to eq 1
        end
      end
      
      context "着手中" do
        before do
          Task.first.update(status: 2)
          select "着手中",  from: "search_status"
          click_button "search-button"
        end
        
        it "size 1" do
          expect(page.all("tbody tr").size).to eq 1
        end
      end
      
      context "未着手" do
        before do
          select "未着手",  from: "search_status"
          click_button "search-button"
        end
        
        it "size 20" do
          expect(page.all("tbody tr").size).to eq 20
        end
      end
    end
  end
  
  describe "paginate" do
    context "create 30 tasks" do
      before do
        30.times { FactoryGirl.create(:task) }
        visit root_path
      end
      
      it "return 25 tasks" do
        expect(page.all("tbody tr").size).to eq 25
      end
    end
  end
end
