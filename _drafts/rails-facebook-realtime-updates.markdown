# Facebook and Rails Event Subscriptions

## Or Real Time Updates 

Using the wonderful [Koala](https://github.com/arsduo/koala) gem you can *”subscribe”* to Facebook events.  This means that when something changes Facebook will send a POST to your server with the details.

It’s your job to configure a server to handle the data.  And by handle the data I mean parse some JSON and update a Post object in the database.  Or at least that’s the workflow for the [BCN](https://github.com/asommer70/bcn) project.  I guess you could update any type of Ruby object you’d like.

**Note:** before diving into this article you should install **koala** into your Rails project via Gemfile, or any other way if that’s possible.

## Controlling Things (Subscriptions/Real Time Updates)

To subscribe for an update you need to send Facebook a unique verification token, and keep track of it, because Facebook will send that in your configured callback URL.  You can then check the **verify_token** with the one you’ve stored to make sure someone isn’t doing something hinky.

Here’s the *index* method for the controller of BCN:

```
  def index
    fb_sub = FacebookSubscription.find_by_verify_token(params['hub.verify_token'])
    if fb_sub
      render :text => Koala::Facebook::RealtimeUpdates.meet_challenge(params, fb_sub.verify_token)
    else
      render_404
    end
  end
```

Notice the **meet_challange** method call.  This is used to respond to Facebook whenever a new subscription is added.  They will check that the **verify_token** you send is correct.

## Creating a Subscription

In the **create** method of the controller I used a call to an ActiveJob in order to do the whole “non-blocking” thing.  The actual code to subscribe to a Facebook event looks like this:

```  
   @updates = Koala::Facebook::RealtimeUpdates.new(:app_id => FACEBOOK_CONFIG['app_id'],
                                                   :secret => FACEBOOK_CONFIG['secret'])
    fb_sub = FacebookSubscription.create(verify_token: (0...50).map { ('a'..'z').to_a[rand(26)] }.join, user: user)
    @updates.subscribe('user', 'events', 'http://bcndev.thehoick.com/facebook_subscriptions/', fb_sub.verify_token)
```

There’s a table **facebook_subscriptions** setup for storing the details about the subscription (mainly the verify_token and user_id that created the Post).  I’m simply creating a random string of characters (I think 50 long) and using that as the token.  Then the **@updats.subscribe** method actually configures things with Facebook.

I think things are working fine, but now that I’m writing this up I realize that I should probably go back and do some more testing.  Can’t ever have enough testing…

## Conclusion

The ability to subscribe to a Facebook event is great when you think about the other option of “polling” Facebook every so often to see if anything has changed.  How efficient for the source to tell you when things are updated.

Hopefully this will be helpful for someone, and I’m sure there may be some updates once the BCN project actually goes live.

Going live should happen pretty soon… hopefully?

Party On!
