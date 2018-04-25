require 'rails_helper'

RSpec.describe Task, type: :model do
  it "is valid with a title, deadline_on, status, and priority" do
    # いきなりすぎ
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
        before do
          FactoryGirl.create(:task, title: 'これはタスク')
          FactoryGirl.create(:task, title: 'タスクはこれ')
          FactoryGirl.create(:task, title: 'これはちがう')
          FactoryGirl.create(:task, title: 'これもちがう')
        end
        
        it "return all records" do
          expect(Task.search_title("タスク").count).to eq 2
        end
      end
    end
    
    describe "status" do
      before do
        30.times { FactoryGirl.create(:task) }
      end
      
      context "完了" do
        before do
          Task.first.update(status: 3)
        end
        it "return stauts complete"do
          expect(Task.search_status("complete").first.status).to eq "complete"
        end
      end

      context "着手中" do
        before do
          Task.first.update(status: 2)
        end
        it "return stauts working"do
          expect(Task.search_status("working").first.status).to eq "working"
        end
      end

      context "未着手" do
        before do
          Task.first.update(status: 1)
        end
        it "return stauts not_start"do
          expect(Task.search_status("not_start").first.status).to eq "not_start"
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
