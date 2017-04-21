class ComponentVariable < ApplicationRecord
  belongs_to :component

  validates_presence_of  :variable_type, :name
  validates_inclusion_of :variable_type, in: %w(runtime_env build_arg)

  scope :runtime_env, -> { where(variable_type: 'runtime_env') }
  scope :build_arg, -> { where(variable_type: 'build_arg') }

  def runtime_env?
    variable_type == 'runtime_env'
  end

  def build_arg?
    variable_type == 'build_arg'
  end
end
