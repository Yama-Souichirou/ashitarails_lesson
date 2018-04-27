class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all
 
  has_secure_password validations: true
  
  validates :email, presence: true, uniqueness: true
  
  before_create :set_default_role
  before_destroy :validates_destroy
  
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
      usres = users.where("username like ?", "%#{params[:username]}%")
    end
    users
  end

  def human_roles
    I18n.t "enum.users.roles.#{self.role}"
  end

  def self.role_options
    I18n.t 'enum.users.roles'
  end
  
  def responsible_tasks
    tasks = Task.where(responsible: self.id)
    tasks.size
  end
  
  def admin?
    self.role == "admin" ? true : false
  end
  
  private
    def set_default_role
      self.role ||= 0
    end
  
    def validates_destroy
      errors.add :base, "少なくとも管理者が１人必要です"
      throw :abort
    end
  
    def one_or_more_admin?
      User.all.length <= 1 ? true: false
    end
end
