class IcalSyncJob < ActiveJob::Base

  queue_as :default

  def perform
    organizations = Organization.where("events_url <> ''")
    organizations.each do |organization|
      events_feed = open(organization.events_url) {|f| f.read }

      cals = Icalendar.parse(events_feed)
      cal = cals.first
      cal.events.each do |event|

        if event.dtstart >= Date.today

          post = Post.find_by(title: event.summary.to_s)
          #user = User.find(organization.created_by)

          if event.dtend
            end_date = event.dtend
            end_time = event.dtend.to_s(:time)
          else
            end_date = nil
            end_time = nil
          end

          if post.nil?
            new_post = Post.create({
                                       title: event.summary,
                                       description: "#{event.description}",
                                       start_date: event.dtstart,
                                       start_time: event.dtstart.to_s(:time),
                                       end_date: end_date,
                                       end_time: end_time,
                                       organization: organization,
                                       #user: user,
                                       og_url: event.url.to_s,
                                       og_title: event.summary,
                                       og_image: event.attach[0].to_s,
                                       image_url: event.attach[0].to_s
                                   })

            # Add Locations and Communities to the new Post.
            if organization.location
              new_post.locations << organization.location
            end
            unless organization.communities.blank?
              new_post.communities << new_post.organization.communities
            end
            new_post.save
          else
            post.description = "#{event.description}"
            post.start_date = event.dtstart
            post.start_time = event.dtstart.to_s(:time)
            post.end_date = end_date
            post.end_time = end_time
            post.og_url = event.url.to_s
            post.og_title = event.summary
            post.og_image = event.attach[0].to_s
            post.image_url = event.attach[0].to_s

            unless post.locations.include?(organization.location)
              post.locations << organization.location
            end

            post.save

          end
        end
      end

    end
  end

end