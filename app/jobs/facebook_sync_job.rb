class FacebookSyncJob < ActiveJob::Base
  queue_as :default
  include Sidekiq::Worker

  def perform(token, user)

    @graph = Koala::Facebook::API.new(token)
    puts "@graph:..."
    events = @graph.get_connections(user.facebook_id, 'events')

    events.each do |event|
      #fb_event = @graph.get_object(event['id']
      fb_event = @graph.get_connection(event['id'], nil,
                                       {'fields' => 'name,owner,start_time,end_time,cover,place,description'})
      organization = user.organizations.find_by(name: fb_event['owner']['name']) unless user.organizations.blank?
      puts "organization: #{organization.inspect}"
      unless organization.blank?
        start_date = Date.parse(event['start_time']) unless event['start_time'].nil?
        start_time = Time.parse(event['start_time']) unless event['start_time'].nil?
        end_date = Date.parse(event['end_time']) unless event['end_time'].nil?
        end_time = Time.parse(event['end_time']) unless event['end_time'].nil?
        image = fb_event['cover']['source'] unless fb_event['cover'].nil?
        #puts "fb_event: #{fb_event.inspect}"
        lat = fb_event['place']['location']['latitude'] if fb_event['place'] && fb_event['place']['location']
        lon = fb_event['place']['location']['longitude'] if fb_event['place'] && fb_event['place']['location']

        post = Post.find_by(title: event['name'])

        if post.nil?
          new_post = Post.create({
                                     title: event['name'],
                                     description: fb_event['description'],
                                     start_date: start_date,
                                     start_time: start_time,
                                     end_date: end_date,
                                     end_time: end_time,
                                     organization_id: organization.id,
                                     user: user,
                                     og_url: "https://www.facebook.com/events/#{event['id']}",
                                     og_title: event['name'],
                                     og_image: ActionController::Base.helpers.asset_path('facebook-social.svg'),
                                     image_url: image,
                                     communities: organization.communities
                                 })
          #new_post.image_url = image if image
          new_post.create_location({lat: lat, lon: lon})
          new_post.save
        else
          post.description = fb_event['description']
          post.start_date = start_date
          post.start_time = start_time
          post.end_date = end_date
          post.end_time = end_time
          post.og_url = "https://www.facebook.com/events/#{event['id']}"
          post.og_title = event['name']
          post.og_image = ActionController::Base.helpers.asset_path('facebook-social.svg')
          post.image_url = image if image
          post.create_location({lat: lat, lon: lon}) if lat && lon
          post.save
        end
      end
    end

    #
    # This code subscribes the BCN Facebook App to app user event changes.  In case it ever needs to be re-subscribed.
    # Only need to subscribe to user['events'] once for the Facebook App.
    #
    #@updates = Koala::Facebook::RealtimeUpdates.new(:app_id => FACEBOOK_CONFIG['app_id'],
    #                                                :secret => FACEBOOK_CONFIG['secret'])
    #fb_sub = FacebookSubscription.create(verify_token: (0...50).map { ('a'..'z').to_a[rand(26)] }.join, user: user)
    #@updates.subscribe('user', 'events', 'https://boonecommunitynetwork.com/facebook_subscriptions/', fb_sub.verify_token)

    user.event_sync_time = Time.now
    user.save
  end
end
