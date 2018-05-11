require 'rails_helper'

RSpec.describe Task, type: :model do
  it "is valid with a title, deadline_on, status, and priority" do
    task = FactoryGirl.build(:task, :with_user, :with_responsible)
    expect(task).to be_valid
  end
  
  it "is invalid without title" do
    task = FactoryGirl.build(:task, :with_user, :with_responsible, title: nil, )
    task.valid?
    expect(task.errors[:title]).to include("を入力してください")
  end
  
  it "is invalid without deadline_on" do
    task = FactoryGirl.build(:task, :with_user, :with_responsible, deadline_on: nil,)
    task.valid?
    expect(task.errors[:deadline_on]).to include("を入力してください")
  end
  
  it "is invalid without status" do
    task = FactoryGirl.build(:task, :with_user, :with_responsible, status: nil,)
    task.valid?
    expect(task.errors[:status]).to include("を入力してください")
  end
  
  it "is invalid without priority" do
    task = FactoryGirl.build(:task, :with_user, :with_responsible, priority: nil,)
    task.valid?
    expect(task.errors[:priority]).to include("を入力してください")
  end

  it "is invalid without user_id" do
    task = FactoryGirl.build(:task, :with_responsible)
    task.valid?
    expect(task.errors[:user]).to include("を入力してください")
  end

  it "is invalid without responsible_id" do
    task = FactoryGirl.build(:task, :with_user)
    task.valid?
    expect(task.errors[:responsible]).to include("を入力してください")
  end
  
  it "has a valid factory" do
    expect(FactoryGirl.create(:task, :with_user, :with_responsible)).to be_valid
  end
  
  describe "search" do
    let(:params) { Hash.new }
    let(:user) { FactoryGirl.create(:user) }
    
    describe "title" do
      context "タスク" do
        before do
          params[:title] = "タスク"
          FactoryGirl.create(:task, user: user, responsible: user, title: 'これはタスク')
          FactoryGirl.create(:task, user: user, responsible: user, title: 'タスクはこれ')
          FactoryGirl.create(:task, user: user, responsible: user, title: 'これはちがう')
          FactoryGirl.create(:task, user: user, responsible: user, title: 'これもちがう')
        end
        it "return 2 records" do
          expect(Task.search(params).count).to eq 2
        end
      end
    end
    
    describe "status" do
      before do
        30.times { FactoryGirl.create(:task, user: user, responsible: user) }
      end
      
      context "完了" do
        before do
          params[:status] = "complete"
          Task.first.update(status: 3)
        end
        it "return status complete"do
          expect(Task.search(params).first.status).to eq "complete"
        end
      end
      
      context "着手中" do
        before do
          params[:status] = "working"
          Task.first.update(status: 2)
        end
        it "return stauts working"do
          expect(Task.search(params).first.status).to eq "working"
        end
      end
      
      context "未着手" do
        before do
          params[:status] = "not_start"
          Task.first.update(status: 1)
        end
        it "return stauts not_start"do
          expect(Task.search(params).first.status).to eq "not_start"
        end
      end
      
      context "empty" do
        it "return all records" do
          expect(Task.search("").count).to eq Task.all.size
        end
      end
    end
  end
end
