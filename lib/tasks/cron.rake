task :cron => :environment do
  puts "Pulling new posts..."
  IcalSyncJob.perform_now
  puts "done."
end