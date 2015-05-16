class FacebookSyncJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Community.where(events_sync_type: 'facebook').each do |community|
      user = User.find(community.created_by)
      events = args[0].get_connections(user.facebook_id, 'events')

      events.each do |event|
        fb_event = args[0].get_object(event['id'])
        if fb_event['owner']['name'] == community.name
          start_date = Date.parse(event['start_time']) unless event['start_time'].nil?
          start_time = Time.parse(event['start_time']) unless event['start_time'].nil?
          end_date = Date.parse(event['end_time']) unless event['end_time'].nil?
          end_time = Time.parse(event['end_time']) unless event['end_time'].nil?

          post = Post.find_by(title: event['name'])

          if post.nil?
            new_post = Post.create({
                            title: event['name'],
                            description: fb_event['description'],
                            start_date: start_date,
                            start_time: start_time,
                            end_date: end_date,
                            end_time: end_time,
                            user: user
                        })
          else
            post.description = fb_event['description']
            post.start_date = start_date
            post.start_time = start_time
            post.end_date = end_date
            post.end_time = end_time
            post.save
          end
        end
      end
    end
  end
end
