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
  
  scenario "tasks are ordered descending created_at" do
    tasks = []
    3.times do |i|
      tasks << Task.create(title: "#{i + 1}", description: "", deadline_on: "2018-04-12")
    end
    
    ordered_careated_at_tasks = tasks.sort_by { |task| task.created_at }.reverse
    visit root_path
    p page.all("tbody tr")[0]
  end
  # pending "add some scenarios (or delete) #{__FILE__}"
end
