class Task < ApplicationRecord
  validates :title, presence: true
  validates :deadline_on, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  
  # 英語にしよう
  PRIORITIES = { anytime: 1, normal: 2, prior: 3, top_prior: 4 }
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
  
  def human_priority
    I18n.t "enum.tasks.priorities.#{self.priority}"
  end
  
  def self.priority_options
    I18n.t 'enum.tasks.priorities'
  end
  
  def days_left
    days_left = self.deadline_on - Date.today
    days_left.to_i
  end
  
  def display_days_left_format
    if self.days_left.to_i <= -1
      "期限を過ぎています"
    else
      return "残り#{days_left.to_i}日"
    end
  end
  
  def display_priority_color_class
    if self.human_priority == "いつでも" || self.human_priority == "普通"
      "info"
    else
      "danger"
    end
  end

  def display_deadline_color_class
    if 6 >= self.days_left
      "danger"
    elsif 7 <= self.days_left && self.days_left  <= 9
      "warning"
    elsif 10 <= self.days_left
      "info"
    end
  end
  
  private
    def set_default_status
      self.status ||= 1
    end

    def set_default_priority
      self.priority ||= 1
    end
end

