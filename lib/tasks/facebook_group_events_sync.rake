task :facebook_group_sync => :environment do
  user = User.find(7)
  FacebookGroupSyncJob.perform_now(user.facebook_token, user)
end
