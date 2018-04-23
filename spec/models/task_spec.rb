require 'rails_helper'
RSpec.describe Task, type: :model do
  let(:task) { Task.new }
  it "is valid with a title, deadline_on, status, and priority" do
    task = Task.new(
      title: "タスク名",
      deadline_on: Date.today,
      status: 1,
      priority: 1
    )
    expect(task).to be_valid
  end
  
  it "is invalid without title" do
    task.title = nil
    task.valid?
    expect(task.errors[:title]).to include("を入力してください")
  end
  
  it "is invalid without deadline_on" do
    task.deadline_on = nil
    task.valid?
    expect(task.errors[:deadline_on]).to include("を入力してください")
  end
  
  it "is invalid without status" do
    task.status = nil
    task.valid?
    expect(task.errors[:status]).to include("を入力してください")
  end
  
  it "is invalid without priority" do
    task.priority = nil
    task.valid?
    expect(task.errors[:priority]).to include("を入力してください")
  end
end
