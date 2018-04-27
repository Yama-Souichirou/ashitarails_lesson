class TaskLabel < ApplicationRecord
  belongs_to :task, optional: true
  belongs_to :label
end
