require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  describe "fill in field and click button" do
    it "create task" do
      visit root_path
  
      expect {
        click_link "新規作成"
        fill_in "タスク名", with: "テストタスク"
        fill_in "説明文", with: "this is a test"
        fill_in "期日", with: "2018-04-04"
    
        click_button "登録"
      }.to change(Task, :count).by(1)
    end
  end
  
  describe "sorted" do
    it "created_at" do
      tasks = []
      1.upto(3) do |i|
        tasks << FactoryGirl.create(:task, created_at: Date.today + i)
      end
      visit root_path
  
      expect(page.all("tbody tr")[0].find(".td-title").text).to match "タスク名3"
      expect(page.all("tbody tr")[1].find(".td-title").text).to match "タスク名2"
      expect(page.all("tbody tr")[2].find(".td-title").text).to match "タスク名1"
    end
    
    context "check '期日' and click button '適応'" do
      it "ordred deadline_on" do
        tasks = []
        1.upto(3) do |i|
          tasks << FactoryGirl.create(:task, deadline_on: Date.today + i)
        end

        visit root_path
        check "deadline_on"
        click_button "適応"

        expect(page.all("tbody tr")[0].find(".td-deadlineon").text).to match "#{(Date.today + 3).strftime("%Y/%m/%d")}"
        expect(page.all("tbody tr")[1].find(".td-deadlineon").text).to match "#{(Date.today + 2).strftime("%Y/%m/%d")}"
        expect(page.all("tbody tr")[2].find(".td-deadlineon").text).to match "#{(Date.today + 1).strftime("%Y/%m/%d")}"
      end
    end
  end
end
