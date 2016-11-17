class ComponentVariable < ApplicationRecord
  belongs_to :component

  validates_presence_of :name
end
