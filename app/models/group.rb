class Group < ApplicationRecord
  has_many :group_users, dependent: :delete_all
  has_many :users, through: :group_users

  accepts_nested_attributes_for :group_users,  allow_destroy: true
end
