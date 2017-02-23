class Project < ApplicationRecord
  has_many :configurations
  has_many :components, through: :configurations
  has_many :repositories, through: :components
  has_many :project_labels
  has_many :labels, through: :project_labels
  belongs_to :created_by_user, class_name: 'User', optional: true

  validates_presence_of :name

  scope :with_labels, -> { includes(:labels) }
end
