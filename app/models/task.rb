class Task < ApplicationRecord
  validates :title, presence: true
  validates :dead, presence: true
  validates :priority, presence: true
  
  PRIORiTIES = {"最優先": 1, "優先": 2, "普通": 3, "お手すき": 4, "暇な日": 5}
  enum priorities: PRIORiTIES
end
