class User < ApplicationRecord
  has_many :tasks
 
  has_secure_password validations: true
  
  validates :email, presence: true, uniqueness: true
  
  before_create :set_default_role
  
  ROLE = { normal: 0, admin: 1 }
  enum role: ROLE
  
  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def human_roles
    I18n.t "enum.users.roles.#{self.role}"
  end

  def self.roles_options
    I18n.t 'enum.users.roles'
  end
  
  private
    def set_default_role
      self.role ||= 0
    end
end
