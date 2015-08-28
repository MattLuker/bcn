task :daily_digest => :environment do
  puts "Performing weekly_digest..."
  WeeklyDigestJob.perform_now
  puts "done..."
end