# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Project.transaction do
  # we self-host tests for this project itself and use that as our seeds
  project = Project.find_or_create_by!(name: "All Cing I")
  test_with_mysql = project.configurations.find_or_create_by!(name: "Self-test")

  allci_repository = Repository.find_or_create_by!(uri: "git@github.com:powershop/allci.git")
  allci_component = test_with_mysql.components.find_or_create_by!(repository: allci_repository, container_name: "allci")

  mysql_repository = Repository.find_or_create_by!(uri: "git@github.com:powershop/allci-test-mysql.git")
  mysql_container = test_with_mysql.components.find_or_create_by!(repository: mysql_repository, container_name: "mysql")

  EnqueueConfigurationBuild.new(test_with_mysql).call({})
end
