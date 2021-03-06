class FacebookSubscriptionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  layout nil

  def index
    puts "facebook_subscriptions index params: #{params}"

    fb_sub = FacebookSubscription.find_by_verify_token(params['hub.verify_token'])
    puts "fb_sub: #{fb_sub.inspect}"
    if fb_sub
      #puts "meet_challenge: #{Koala::Facebook::RealtimeUpdates.meet_challenge(params, fb_sub.verify_token)}"
      challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params, fb_sub.verify_token)
      puts "meet_challenge: #{challenge}"

      render :text => challenge
    else
      render_404
    end
  end

  def create
    logger.info "facebook_subscriptions create params: #{params}"
    uids = FacebookSubscription.new().remove_duplicate_uids(params)
    #Parameters: {"object"=>"user", "entry"=>[{"uid"=>"10152906515550983", "id"=>"10152906515550983", "time"=>1447863939, "changed_fields"=>["events"]}], "facebook_subscription"=>{}
    #
    #curl -H "Content-Type: application/json" -X POST -d '{"object": "user", "entry": [{"uid": "10152906515550983", "id": "10152906515550983", "time": 1447865002, "changed_fields": ["events"]}], "facebook_subscription": {}}' https://www.boonecommunitynetwork.com/facebook_subscriptions/
    #
    #
    logger.info "uids: #{uids}"

    uids.each do |entry|
      user = User.find_by_facebook_id(entry['uid'])

      if user && user.facebook_token
        logger.info "Performing FacebookSyncJob..."
        FacebookSyncJob.perform_now(user.facebook_token, user)
      end
    end

    render :text => 'success'
  end
end
