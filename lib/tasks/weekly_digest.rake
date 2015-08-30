task :weekly_digest => :environment do
  puts "Performing weekly_digest..."
  WeeklyDigestJob.perform_async
  puts "done..."
end