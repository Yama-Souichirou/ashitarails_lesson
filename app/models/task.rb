class Task < ApplicationRecord
  validates :title, presence: true
  validates :deadline_on, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  
  # 英語にしよう
  PRIORITIES = { 'お手すき' => 1, '普通' => 2, '優先' => 3, '最優先' => 4 }
  STATUSES   = { '未着手' => 1, '着手中' => 2, '完了' => 3 }
  
  enum priority: PRIORITIES
  enum status: STATUSES
  #  くっつけるenum
  
  before_create :set_default_status
  before_create :set_default_priority
  
  scope :search_title, -> (title) {
    where("title like ?", "%#{title}%") if title.present?
  }
  
  scope :search_status, -> (status) {
    where(status: status) if status.present?
  }
  
  scope :search_priority, -> (priority) {
    where(priority: priority) if priority.present?
  }

  scope :select_order, -> (request) {
    if request == "deadline"
      order("deadline_on ASC")
    elsif request == "priority"
      order("priority ASC")
    else
      order("created_at DESC")
    end
  }
  
  private
    def set_default_status
      self.status ||= 1
    end

    def set_default_priority
      self.priority ||= 1
    end
end

