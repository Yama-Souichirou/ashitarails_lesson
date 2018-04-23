require 'rails_helper'
RSpec.describe Task, type: :model do
  it "is valid with a title, deadline_on, status, and priority" do
    expect(FactoryGirl.build(:task)).to be_valid
  end
  
  it "is invalid without title" do
    task = FactoryGirl.build(:task, title: nil)
    task.valid?
    expect(task.errors[:title]).to include("を入力してください")
  end
  
  it "is invalid without deadline_on" do
    task = FactoryGirl.build(:task, deadline_on: nil)
    task.valid?
    expect(task.errors[:deadline_on]).to include("を入力してください")
  end
  
  it "is invalid without status" do
    task = FactoryGirl.build(:task, status: nil)
    task.valid?
    expect(task.errors[:status]).to include("を入力してください")
  end
  
  it "is invalid without priority" do
    task = FactoryGirl.build(:task, priority: nil)
    task.valid?
    expect(task.errors[:priority]).to include("を入力してください")
  end
  
  it "has a valid factory" do
    expect(FactoryGirl.create(:task)).to be_valid
  end
end
