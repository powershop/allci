# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Project.transaction do
  project = Project.create!(name: "All Cing I")
  standard = project.configurations.create!(name: "Standard")

  repository = Repository.create!(uri: "git@domain.com:somewhere/your_repo.git")
  container = standard.components.create!(repository: repository, container_name: "db")

  memcache_repository = Repository.create!(uri: "git@domain.com:somewhere/your_memcache_repo.git")
  memcache_container = standard.components.create!(repository: memcache_repository, container_name: "memcache")

  EnqueueConfigurationBuild.new(standard).call({})
end
