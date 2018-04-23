class Task < ApplicationRecord
  validates :title, presence: true
  validates :deadline_on, presence: true
  
  PRIORITIES = { "最優先" => 1, "優先" => 2, "普通" => 3, "お手すき" => 4 }
  STATUSES   = { "完了" => 1, "着手中" => 2, "未着手" => 3 }
  
  enum priority: PRIORITIES
  enum status: STATUSES
end

