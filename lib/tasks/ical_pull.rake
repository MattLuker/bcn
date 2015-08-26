task :ical => :environment do
  IcalSyncJob.perform_now
end