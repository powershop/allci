require 'rails_helper'

RSpec.describe Repository, type: :model do
  it "infers the name from the repository URI" do
    repository = Repository.new(uri: "git@github.com:willbryant/demo_project.git")
    expect(repository).to be_valid
    expect(repository.name).to eq("Demo project")
  end
end
