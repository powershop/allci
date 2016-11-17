class Project < ApplicationRecord
  has_many :configurations
  has_many :components, through: :configurations
  has_many :repositories, through: :components
  belongs_to :created_by_user, class_name: 'User', optional: true

  validates_presence_of :name
end
