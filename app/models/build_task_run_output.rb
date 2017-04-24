class BuildTaskRunOutput < ApplicationRecord
  scope :failed, -> { where("exit_code <> 0") }

  def failed?
    exit_code.nonzero?
  end
end
