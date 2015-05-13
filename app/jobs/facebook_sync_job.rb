class FacebookSyncJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Community.where(events_sync_type: 'facebook').each do |community|
      user = User.find(community.created_by)

      # How do I lookup the events for the group/page on Facebook.
      #profile = @graph.get_object(user.facebook_id)

      #FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'],
      # @oauth = Koala::Facebook::OAuth.new(FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'])
      # key = @oauth.get_app_access_token
      #@graph = Koala::Facebook::API.new(key)

      # @oauth = Koala::Facebook::OAuth.new(FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'], '/')
      # @oauth.get_user_info_from_cookies(cookies)
      # @access_token = @facebook_cookies['access_token']
      # @graph = Koala::Facebook::GraphAPI.new(@access_token)

      #puts "args: #{args}"
      #@facebook_cookies ||= Koala::Facebook::OAuth.new(FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret']).get_user_info_from_cookie(args[0])
      #@access_token = @facebook_cookies["access_token"]
      #@graph = Koala::Facebook::GraphAPI.new(@access_token)

      #puts "user.facebook_id: #{user.facebook_id}"

      # Authenticate as the user.

      #"#{events = args[0].get_connection(user.facebook_id, 'events')}"

      #puts "events.inpsect: #{events.inspect}"
      # events.each do |event|
      #   fb_event = @graph.get_object(event['id'])
      #   if fb_event['owner']['name'] == community.name
      #     start_date = Date.parse(event['start_time']) unless event['start_time'].nil?
      #     start_time = Time.parse(event['start_time']) unless event['start_time'].nil?
      #     end_date = Date.parse(event['end_time']) unless event['end_time'].nil?
      #     end_time = Time.parse(event['end_time']) unless event['end_time'].nil?
      #
      #     post = Post.find_by(name: event['name'])
      #
      #     if post.nil?
      #       Post.create({
      #                       name: event['name'],
      #                       description: event['description'],
      #                       start_date: start_date,
      #                       start_time: start_time,
      #                       end_date: end_date,
      #                       end_time: end_time,
      #                       user: user
      #                   })
      #     else
      #       post.description = event['description']
      #       post.start_date = start_date
      #       post.start_time = start_time
      #       post.end_date = end_date
      #       post.end_time = end_time
      #       #post.save
      #     end
      #   end
      # end
    end
  end
end
