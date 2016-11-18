# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Project.transaction do
  project = Project.create!(name: "All Cing I")
  standard = project.configurations.create!(name: "Standard")

  repository = Repository.create!(uri: "git@domain.com:somewhere/your_repo.git")
  container = standard.components.create!(repository: repository, container_name: "db")

  EnqueueConfigurationBuild.new(standard).call({})
end
