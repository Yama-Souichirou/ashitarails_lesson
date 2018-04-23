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
  
  describe "search" do
    describe "title" do
      context "タスク" do
        it "return all records" do
          expect(Task.search_title("タスク").count).to eq Task.all.size
        end
      end
  
      context "job" do
        it "no return" do
          expect(Task.search_title("job")).to be_empty
        end
      end
    end
    
    describe "status" do
      1.upto(3) { |i| FactoryGirl.create(:task, status: i) }
      context "完了" do
        it "return stauts '完了'"do
          expect(Task.search_status("完了").first.status).to eq "完了"
        end
      end

      context "着手中" do
        it "return stauts '着手中'"do
          expect(Task.search_status("着手中").first.status).to eq "着手中"
        end
      end

      context "未着手" do
        it "return stauts '未着手'"do
          expect(Task.search_status("未着手").first.status).to eq "未着手"
        end
      end
      
      context "empty" do
        it "return all records" do
          expect(Task.search_status("").count).to eq Task.all.size
        end
      end
    end
  end
end
