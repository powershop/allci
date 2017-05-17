class Runner < ApplicationRecord
  has_many :build_task_runs

  validates_presence_of :name
  validates_uniqueness_of :name
end
