require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  scenario "creates a new task" do
    visit root_path

    expect {
      click_link "新規作成"
      fill_in "タスク名", with: "テストタスク"
      fill_in "説明文", with: "this is a test"
      fill_in "期日", with: "2018-04-04"
      
      click_button "登録"
    }.to change(Task, :count).by(1)
  end
  
  scenario "tasks are sorted in descending order to created_at" do
    tasks = []
    3.times do |i|
      tasks << Task.create(
        title: "タスク名#{i + 1}",
        description: "",
        deadline_on: "2018-01-10",
        created_at: Date.today + i)
    end
    visit root_path
    
    expect(page.all("tbody tr")[0].find(".td-title").text).to match "タスク名3"
    expect(page.all("tbody tr")[1].find(".td-title").text).to match "タスク名2"
    expect(page.all("tbody tr")[2].find(".td-title").text).to match "タスク名1"
  end
end
