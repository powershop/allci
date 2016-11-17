class Repository < ApplicationRecord
  before_validation :default_name, on: :create
  validates_presence_of :name, :uri
  validates_uniqueness_of :uri

protected
  def default_name
    if name.blank? && uri && uri =~ /(\w+)(\.git)$/
      self.name = $1.humanize
    end
  end
end
