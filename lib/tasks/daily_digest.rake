task :daily_digest => :environment do
  puts "Performing daily_digest..."
  DailyDigestJob.perform_async
  puts "done..."
end