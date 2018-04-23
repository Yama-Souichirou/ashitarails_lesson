class Task < ApplicationRecord
  validates :title, presence: true
  validates :deadline_on, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  
  PRIORITIES = { "最優先" => 1, "優先" => 2, "普通" => 3, "お手すき" => 4 }
  STATUSES   = { "完了" => 1, "着手中" => 2, "未着手" => 3 }
  
  enum priority: PRIORITIES
  enum status: STATUSES
  
  scope :search_title, -> (title) {
    where("title like ?", "%#{title}%") if title.present?
  }
  
  scope :search_status, -> (status) {
    where(status: status) if status.present?
  }
  
  scope :select_order, -> (request) {
    if request == "deadline"
      order("deadline_on DESC")
    elsif request == "priority"
      order("priority ASC")
    else
      order("created_at DESC")
    end
  }
end

