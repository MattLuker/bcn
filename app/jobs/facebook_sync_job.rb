class FacebookSyncJob < ActiveJob::Base
  queue_as :default

  def perform(token, user)
    @graph = Koala::Facebook::API.new(token)
    events = @graph.get_connections(user.facebook_id, 'events')

    events.each do |event|
      fb_event = @graph.get_object(event['id'])
      community = user.communities.where(name: fb_event['owner']['name']) unless user.communities.blank?
      unless community.blank?
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
                                     communities: [community[0]],
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

    user.event_sync_time = Time.now
    user.save
  end
end
