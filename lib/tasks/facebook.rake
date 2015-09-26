task :facebook => :environment do
  user = User.find(7)
  FacebookSyncJob.perform_now(user.facebook_token, user)
end
