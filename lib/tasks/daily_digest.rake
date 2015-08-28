task :daily_digest => :environment do
  puts "Performing daily_digest..."
  DailyDigestJob.perform_now
  puts "done..."
end