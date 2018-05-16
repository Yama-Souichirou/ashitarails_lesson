class Group < ApplicationRecord
  has_many :group_users, dependent: :delete_all
  has_many :users, through: :group_users
  has_many :tasks

  accepts_nested_attributes_for :group_users,  allow_destroy: true
  
  validates :name, presence: true
end
