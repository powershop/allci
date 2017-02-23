class ProjectLabel < ApplicationRecord
  belongs_to :project
  belongs_to :label, counter_cache: true

  validates :label_id, uniqueness: { scope: :project_id }
end
