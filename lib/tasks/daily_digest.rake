task :daily_digest => :environment do
  puts "Performing daily_diget..."
  DailyDigestJob.perform_now
  puts "done..."
end