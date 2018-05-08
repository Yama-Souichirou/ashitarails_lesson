class Task < ApplicationRecord
  has_many :task_labels, dependent: :delete_all
  has_many :labels, through: :task_labels
  belongs_to :user
  belongs_to :responsible, :class_name => 'User'
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
  
  def left_days
    left_days = self.deadline_on - Date.today
    left_days.to_i
  end
  
  def display_left_days_format
    if self.left_days.to_i <= -1
      "期限を過ぎています"
    else
      "残り#{left_days.to_i}日"
    end
  end
  
  def priority_color_class
    priority = self.priority
    if priority == "anytime" || priority == "normal"
      "info"
    elsif priority == "prior"
      "warning"
    else
      "danger"
    end
  end

  def deadline_color_class
    if 6 >= self.left_days
      "danger"
    elsif 7 <= self.left_days && self.left_days  <= 9
      "warning"
    elsif 10 <= self.left_days
      "info"
    end
  end

  def status_color_class
    status = self.status
    if status == "not_start"
      "warning"
    elsif status == "working"
      "success"
    else
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

