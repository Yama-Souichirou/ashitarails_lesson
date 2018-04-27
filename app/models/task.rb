class Task < ApplicationRecord
  has_many :task_labels
  has_many :labels, through: :task_labels
  belongs_to :user
  # belongs_to でかけるよ
  accepts_nested_attributes_for :task_labels, allow_destroy: true


  validates :title, presence: true
  validates :deadline_on, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  
  PRIORITIES = { anytime: 1, normal: 2, prior: 3, top_prior: 4 }
  STATUSES   = { not_start: 1, working: 2, complete: 3 }
  
  enum priority: PRIORITIES
  enum status: STATUSES
  
  # コールバック時は注意
  before_create :set_default_status
  before_create :set_default_priority
  
  def self.search(params)
    tasks = Task.all
    return tasks if params.blank?
    
    if params[:title].present?
      tasks = tasks.where("title like ?", "%#{params[:title]}%")
    end
    if params[:status].present?
      tasks = tasks.where(status: params[:status])
    end
    if params[:priority].present?
      tasks = tasks.where(priority: params[:priority])
    end
    if params[:responsible].present?
      tasks = tasks.where(responsible: params[:responsible])
    end
    if params[:user_id].present?
      tasks = tasks.where(user_id: params[:user_id])
    end
    tasks
  end
  
  scope :select_order, -> (request) {
    if request == "deadline"
      order("deadline_on ASC")
    elsif request == "priority"
      order("priority DESC")
    else
      order("created_at DESC")
    end
  }
  
  def human_priority
    I18n.t "enum.tasks.priorities.#{self.priority}"
  end

  def human_status
    I18n.t "enum.tasks.statuses.#{self.status}"
  end
  
  def self.priority_options
    I18n.t 'enum.tasks.priorities'
  end

  def self.status_options
    I18n.t 'enum.tasks.statuses'
  end
  
  def days_left
    days_left = self.deadline_on - Date.today
    days_left.to_i
  end
  
  def display_days_left_format
    if self.days_left.to_i <= -1
      "期限を過ぎています"
    else
      "残り#{days_left.to_i}日"
    end
  end
  
  def priority_color_class
    if self.priority == "anytime" || self.priority == "normal"
      "info"
    elsif self.priority == "prior"
      "warning"
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
  
  def responsible_user
    # responsible_usernameがよい
    user = User.find(self.responsible)
    user.username
  end
  
  private
    def set_default_status
      self.status ||= 1
    end

    def set_default_priority
      self.priority ||= 1
    end
end

