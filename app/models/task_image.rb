class TaskImage < ApplicationRecord
  belongs_to :task, optional: true
  attachment :file
end
