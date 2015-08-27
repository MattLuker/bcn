---
title:  "Badges and Gamification"
date:   2015-08-26 14:30:00
layout: post
categories: rails bcn
image: badges_cover.jpg
---

## Badges We Don’t Need No Stinkin Badges

I’m not a huge fan of the whole gamification of apps, and web apps, but sometimes it’s fun.  One of the most addicting examples of gamification that I like is the [Treehouse](http://teamtreehouse.com/adamsommer) site/app.  They use a simple badges to signify when you’ve completed a course, but the really useful hook feature is the **points** you get after completing courses, quizzes, and challenges.  For whatever reason it feels good to get more points.

Love to see the points roll over to another 1,000, heh.

So that’s the back story, and I think gamification definitely works for some apps, but it can totally be taken way too far.  For example the [Zurmo](http://zurmo.org/) CRM web app takes it super past the point where it’s fun.  But then again that’s sort of their claim to fame, and maybe some people really like it.

For [BCN](https://github.com/asommer70/bcn) we’ve used a simple badge system to add some gamification and hopefully increase site usage.

<!--more-->
## Rails Gamification

There are some gems out there that add full on gamification and others that add more scaled back features around the gamification idea.

Some are:

* [honor](https://www.ruby-toolbox.com/projects/honor)

* [gioco](https://github.com/joaomdmoura/gioco)

* [merit](https://github.com/merit-gem/merit)

* [activerecord-reputation-system](https://www.ruby-toolbox.com/projects/activerecord-reputation-system)

I tried out a couple of these gems, *honor* and *merit* I think, but each of them required quite a few updates and changes to integrate into BCN.  Since we were nearing “go live” I thought it’d be easier (and simpler) to implement a simple Badge model.

## Badge Model

The Badge model I whipped up is pretty simple, it’s a *habtm* relationship with the User model:

{% highlight ruby %}

create_table :badges do |t|
  t.string :name, index: true
  t.string :rules
  t.string :image
  t.string :image_uid
  t.string :image_name
  t.integer :users
  t.timestamps null: false
end
{% endhighlight %}

Basically the badge is just an image that will be applied to the User’s profile page like this:

{% highlight ruby %}
<div>
  <strong>Badges:</strong>
  <br/><br/>
  <% if @user.badges.length != 0 %>
    <ul class="badges inline-list">
      <% @user.badges.each do |badge| %>
        <li>
          <div class="badge-display">
            <%= link_to badge do %>
              <%= image_tag badge.image.url, class: 'badge-thumb' %> 
           <% end %>
           <br/>
           <%= badge.name %>
          </div>
         </li> 
       <% end %>
     </ul>
   <% else %>
     <p class="grey">No badges at this time, but don't worry we believe in you.</p>
   <% end %>
</div>
{% endhighlight %}

## Badge Job

Sometimes you do a *badge* job at something.  Hoohooheeeheee.

The real magic of the Badge system is the **rules** field.  The rules field is a text field that will be executing using the **eval** method from an ActiveJob.  For that reason in the model I setup a validation to not allow the word destroy in a rule.  I think this should save us from some maliciousness:


{% highlight ruby %}
validates :rules, format: { without: /.*destroy.*/ }
{% endhighlight %}

The meat of the Badge job looks like:

{% highlight ruby %}
def perform(user)
   Badge.all.each do |badge|
     if eval(badge.rules)
       unless badge.users.include?(user)
         badge.users << user
       end
     end
   end
end
{% endhighlight %}

As you can see the job loops through the Badges and **evals** the rules, applies them to the user passed into the parameter, and then adds the badge to the User.  This job is called at certain points from multiple controllers with:

{% highlight ruby %}
ApplyBadgesJob.perform_now(current_user)
{% endhighlight %}

Also, created a **rake** task to run the job and plan on setting it up to execute via **cron** at some point.

## Conclusion

So that’s the gamification that I devised, hacked, etc for the BCN project.  Pretty simple, and we might add additional features, or migrate to something more robust in the future.

I hope it’s something people find fun without being annoying.  The best things in life are not annoying… at least that’s my theory.

Party On!
