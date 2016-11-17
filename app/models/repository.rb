class Repository < ApplicationRecord
  has_many :components
  has_many :configurations, through: :components
  has_many :projects, through: :configurations

  before_validation :set_default_name, on: :create

  validates_presence_of :name, :uri
  validates_uniqueness_of :uri

protected
  def set_default_name
    if name.blank? && uri && uri =~ /(\w+)(\.git)$/
      self.name = $1.humanize
    end
  end
end
