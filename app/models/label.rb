class Label < ApplicationRecord
  has_many :project_labels
  has_many :projects, through: :project_labels

  validates :name, uniqueness: { case_sensitive: false }

  scope :alphabetically, -> { order(name: :asc) }
end
