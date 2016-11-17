class Configuration < ApplicationRecord
  belongs_to :project
  has_many :components
  has_many :repositories, through: :components
  has_many :configuration_builds

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :project

  scope :build_by_default, -> { where.not(build_priority: nil) }
  scope :in_build_priority_order, -> { order(:build_priority, :id) }

  def build_by_default?
    !build_priority.nil?
  end
end
