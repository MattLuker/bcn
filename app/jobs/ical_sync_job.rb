class IcalSyncJob < ActiveJob::Base

  queue_as :default

  def perform
    communities = Community.where("events_url <> ''")
    communities.each do |community|
      events_feed = open(community.events_url) {|f| f.read }

      cals = Icalendar.parse(events_feed)
      cal = cals.first
      cal.events.each do |event|


        post = Post.find_by(title: event.summary.to_s)
        user = User.find(community.created_by)

        if post.nil?
          new_post = Post.create({
                                     title: event.summary,
                                     description: "#{event.description}",
                                     start_date: event.dtstart,
                                     start_time: event.dtstart.to_s(:time),
                                     end_date: event.dtend,
                                     end_time: event.dtend.to_s(:time),
                                     communities: [community],
                                     user: user,
                                     og_url: event.url.to_s,
                                     og_title: event.summary,
                                     og_image: event.attach[0].to_s,
                                     image_url: event.attach[0].to_s
                                 })
          #new_post.create_location({lat: lat, lon: lon})
          #new_post.save
        else
          post.description = "#{event.description}"
          post.start_date = event.dtstart
          post.start_time = event.dtstart.to_s(:time)
          post.end_date = event.dtend
          post.end_time = event.dtend.to_s(:time)
          post.og_url = event.url.to_s
          post.og_title = event.summary
          post.og_image = event.attach[0].to_s
          post.image_url = event.attach[0].to_s
          #post.create_location({lat: lat, lon: lon}) if lat && lon
          post.save
        end
      end

    end
  end

end