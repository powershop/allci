# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :wait_for_database => :environment do
  time_to_sleep = 0.1
  loop do
    begin
      ActiveRecord::Base.connection
      return
    rescue Mysql2::Error
      time_to_sleep *= 2
      raise if time_to_sleep > 15
      puts "database not ready yet: #{$!.message}"
      sleep time_to_sleep
    end
  end
end
