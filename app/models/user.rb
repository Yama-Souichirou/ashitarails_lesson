class User < ApplicationRecord
  attachment :image
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :tasks, :class_name => 'Task', :foreign_key => 'user_id'
  has_many :responsibles, :class_name => 'Task', :foreign_key => 'responsible_id'
 
  has_secure_password validations: true
  
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
  
  before_create :set_default_role
  before_destroy :validates_must_exist_admin, if: :one_person_following?
  before_destroy :validates_has_tasks
  
  ROLE = { normal: 0, admin: 1 }
  enum role: ROLE
  
  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
  
  def self.search(params)
    users = User.all
    return users if params.blank?
    
    if params[:username].present?
      users = users.where("username like ?", "%#{params[:username]}%")
    end
    users
  end

  def human_roles
    I18n.t "enum.users.roles.#{self.role}"
  end

  def self.role_options
    I18n.t 'enum.users.roles'
  end
  
  def completed_tasks
    self.responsibles.where(status: "complete")
  end
  
  def admin?
    self.role == "admin" ? true : false
  end
  
  private
    def set_default_role
      self.role ||= 0
    end
  
    def validates_must_exist_admin
      errors.add :base, "少なくとも管理者が１人必要です"
      throw :abort
    end
  
    def one_person_following?
      User.where(role: "admin").length <= 1 && self.role == "admin"
    end
  
    def validates_has_tasks
      if self.tasks.present? || self.responsibles.present?
        errors.add :base, "紐付いたタスクがあります"
        throw :abort
      end
    end

end
