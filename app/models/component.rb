class Component < ApplicationRecord
  belongs_to :configuration
  belongs_to :repository
  has_many :component_variables

  before_validation :set_default_container_name

  validates_presence_of :branch, :container_name, :dockerfile
  validates_uniqueness_of :container_name, scope: :configuration

  scope :for_branch, -> (branch_name) { where(branch: branch_name.sub(/^refs\/\w+\//, '')) }
  scope :triggers_builds, -> { where(triggers_builds: true) }

protected
  def set_default_container_name
    self.container_name ||= repository.name.gsub(/[^a-zA-Z0-9]/, '_').downcase
  end
end
