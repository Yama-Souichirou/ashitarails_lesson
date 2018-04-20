class Task < ApplicationRecord
  PRIORITIES = { "最優先": 1, "優先": 2, "普通": 3, "お手すき" }
  STATUSES   = { "完了": 1, "着手中": 2, "未着手": 3, "お手すき" }
  
  enum priorities: PRIORITIES
  enum statuses: STATUSES
  
end
