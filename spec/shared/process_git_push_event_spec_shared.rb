shared_examples_for "git push event service" do
  it "uses the existing repository if it already exists" do
    repository = Repository.create!(uri: repository_uri)
    service.call
    expect(service.repository).to eq(repository)
  end

  it "creates the repository if it doesn't exist" do
    service.call
    expect(service.repository.uri).to eq(repository_uri)
    expect(service.repository.name).to eq(repository_name)
  end
end