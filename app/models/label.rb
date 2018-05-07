class Label < ApplicationRecord
  has_many :task_labels, dependent: :delete_all
  has_many :tasks, through: :task_labels
  
  validates :name, presence: true
  before_destroy :validates_destroy
  
  private
    def validates_destroy
      if self.tasks.length >= 1
        errors.add :base, "登録されているタスクがあります"
        throw :abort
      end
    end
end
