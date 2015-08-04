task :badges => :environment do
  puts "Applying badges..."
  user = User.find(4)
  ApplyBadgesJob.perform_now(user)
  puts "done."
end