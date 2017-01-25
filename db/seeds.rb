# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Project.transaction do
  # we self-host tests for this project itself and use that as our seeds
  project = Project.find_or_create_by!(name: "All Cing I")

  allci_repository = Repository.find_or_create_by!(uri: "git@github.com:powershop/allci.git")
  mysql_repository = Repository.find_or_create_by!(uri: "git@github.com:powershop/allci-test-mysql.git")
  mariadb_repository = Repository.find_or_create_by!(uri: "git@github.com:powershop/allci-test-mariadb.git")

  test_with_mysql = project.configurations.find_or_create_by!(name: "Self-test with mysql")
  test_with_mariadb = project.configurations.find_or_create_by!(name: "Self-test with mariadb")

  mysql_container = test_with_mysql.components.find_or_create_by!(repository: mysql_repository, container_name: "db")
  allci_with_mysql_component = test_with_mysql.components.find_or_create_by!(repository: allci_repository, container_name: "allci")
  allci_with_mysql_component.component_variables.find_or_create_by!(name: "ALLCI_DATABASE_SERVER", value: "db")

  mariadb_container = test_with_mariadb.components.find_or_create_by!(repository: mariadb_repository, container_name: "db")
  allci_with_mysql_component = test_with_mariadb.components.find_or_create_by!(repository: allci_repository, container_name: "allci")
  allci_with_mysql_component.component_variables.find_or_create_by!(name: "ALLCI_DATABASE_SERVER", value: "db")

  EnqueueConfigurationBuild.new(test_with_mysql).call({})
  EnqueueConfigurationBuild.new(test_with_mariadb).call({})
end
