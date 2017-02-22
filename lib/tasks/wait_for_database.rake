task :wait_for_database => :environment do
  time_to_sleep = 0.1
  loop do
    begin
      ActiveRecord::Base.connection
      break
    rescue Mysql2::Error
      time_to_sleep *= 2
      raise if time_to_sleep > 15
      puts "database not ready yet: #{$!.message}"
      sleep time_to_sleep
    rescue ActiveRecord::NoDatabaseError
      break
    end
  end
end
