---
title:  "Pic Meta With Rails"
date:   2015-09-24 14:30:00
layout: post
categories: rails learning
image: picmeta_cover.jpg
---

## Storing Meta Data

In our last Rails post we downloaded a bunch of funny pics using the [Imgur API](https://api.imgur.com/).  This is pretty fun and useful, but there’s a lot of additional information about each pic that would be cool to save.

There’s a ton of info we can get directly from Imgur.  It’d be great to save it to a database in case we need it later.  

<!--more-->

## SQLite The Greatest Little Database

The [SQLite](https://www.sqlite.org/) library is baked into Rails and is the default database when setup a new project with the **rails** command.  To see the details of your SQLite database open the **config/database.yml** file.  The important lines for development are:


{% highlight ruby %}
default: &default
  adapter: sqlite3
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: db/development.sqlite3
{% endhighlight %}


As you can see Rails will create a development database in **db/development.sqlite3**.  You can open the database outside of rails using the **sqlite3** command line utility.  You can download it [here](https://www.sqlite.org/download.html) if you don’t have it, or see your systems documentation to install it from a binary package.

## Setting Up The Database with Migrations

The Rails, or AcitveRecord really, [migration](http://edgeguides.rubyonrails.org/active_record_migrations.html) feature is tops for setting up a database and also making changes to your tables.  Cause it’s very rare to get things right the first time when setting up your database schema.

Generate a new migration to create the **images** table with the **rails** command:

```
bin/rails g migration create_images_table
```

This will create a new migration file in **db/migrate/20150912122532_create_images_table.rb** where the numbers preceding the **_create_iamges_table.rb** are a timestamp.  Your file will definitely be named differently because you’re in the future…

The contents of the file create a new table because Rails is smart enough to know that from the name we gave the migration:

{% highlight ruby %}
class CreateImagesTable < ActiveRecord::Migration
  def change
    create_table :images_tables do |t|
    end
  end
end
{% endhighlight %}




If you name your migration something like “bobs_great_migration” the file will be be an empty class with the **change** method.  Sometimes that’s perfectly okay.  Also, you can specify your table fields from the command line, but in this case I didn’t take the time to lookup the syntax.

Edit the new migration file and add the following to the **change** method:

{% highlight ruby %}
  create_table :images do |t|
    t.string :imgur_id
    t.string :title
    t.string :topic
    t.string :link
    t.string :description
    t.string :url
    t.integer :imgur_timestamp
    t.integer :width
    t.integer :height
    t.integer :size
    t.timestamps null: false
  end
{% endhighlight %}

Also, note that I adjusted the table name in the **create_table** loop from **images_tables** to **images**.

Now create the new table with the **rake** utility:

```
bin/rake db:migrate
```

When working with migrations you’ll be calling the **db:migrate** task quite a bit.

## Adding Data and Models

To access the data in the database we need a model file.  For the image the model will be basically an empty class because we’ll get all the goodness from ActiveRecord.  Create a new file **app/models/image.rb** with the contents of:

{% highlight ruby %}
class Image < ActiveRecord::Base
 end
{% endhighlight %}

Back in the controller file, **app/controllers/images_controller.rb**, add the following code to the beginning of the **imgur** method:

{% highlight ruby %}
begin
  db_image = Image.find(imgur_id: image['id'])
 rescue
  db_image = Image.new
 end
{% endhighlight %}

This will create a new **Image** object if there already isn’t one in the database.

Change the contents of the **resp[‘data’].each** loop to:

{% highlight ruby %}
  file_name = image['link'].split('/')[-1]
 image_path = Rails.root.join('public', 'images', file_name)
 image_url = ‘/public/images/' + file_name

  puts "image type: #{image['type'].blank?}"

  unless File.exists?(image_path)
    open(image_path.to_s, 'wb') do |file|
      file << open(image['link']).read
    end
  end

  db_image.imgur_id = image['id']
  db_image.title = image['title']
  db_image.topic = image['topic']
  db_image.link = image['link']
  db_image.description = image['description']
  db_image.imgur_timestamp = image['datetime']
  db_image.width = image['width']
  db_image.height = image['height']
  db_image.size = image['size']
  db_image.url = image_url
  db_image.save
{% endhighlight %}


Notice the change in the **image_path** variable it’s now using the **file_name** variable at the end and the new **image_url** variable is a shorted version of the **image_path**.  This is because the URL won’t need the full path to the *public* directory like the file save operation does.

Now refresh the page, or browse to the **http://localhost:3000/imgur** path, and the information should be saved to the datatbase.

## Displaying the Data

While still in the **app/controllers/images_controller.rb** file adjust the **index** method to retrieve the information from the database instead of the file system:

{% highlight ruby %}
def index
  @images = Image.all
 end
{% endhighlight %}


The Foundation [Clearing](http://foundation.zurb.com/docs/components/clearing.html) light box can display a caption for the image in the gallery.  Which is pretty cool and now that we have the extra data from Imgur saved we can display the image title.

Adjust the **app/views/images/index.html.erb** file to have:

{% highlight ruby %}
<br/><br/>

<div class="row">
  <div class="columns large-12">

    <h3>Funy Images</h3>

    <%= link_to 'imgur', imgur_path %>

    <ul class="clearing-thumbs" data-clearing>
      <% @images.each do |image| %>
        <li>
          <a href="<%= image.url %>">
            <img src="<%= image.url %>" class="th" width="200" data-caption="<%= image.title %>"/>
          </a>
        </li>
      <% end %>
    </ul>

  </div>
</div>
{% endhighlight %}

The magic happens in the new **data-caption** attribute on the *img* tag.  The contents of the attribute are displayed in the light box under the image by Foundation.  The other main difference is that the **src** attribute on the *img* and the **href** of the *a* tag are using the **image.url** attribute instead of the previous **image** string.

## Conclusion

Storing data in database is fun.  It’s even more fun with the power of ActiveRecord and Rails behind it.  Not to mention all the Ruby goodness you get with iterators and what not.

Also, another plus is that we don’t have to query Imgur to get the additional details… we can just look  them up in our own database.  Also Too, adding additional fields from Imgur, or from the image itself is easy with Rails migrations.

Party On!
