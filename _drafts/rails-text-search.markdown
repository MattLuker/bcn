# Full Text Search with PostgreSQL and Rails

## Why Can't I Find My Keys

Ha, *index* keys?  Or maybe the keys to the universe?

We're talking about search here people, and since the budget is pretty much nonexistent we're going to use the [full text search](http://www.postgresql.org/docs/9.2/static/textsearch.html) feature of PostgreSQL.  Though another good Open Source search engine is [Elasticsearch](https://github.com/elastic/elasticsearch), I figured keep things "lean" and just use the built in stuff.

## Setting Things Up

For [BCN Rails](https://github.com/asommer70/bcn) I followed [this great Thoughtbot post](https://robots.thoughtbot.com/implementing-multi-table-full-text-search-with-postgres) on the subject.  I might go back and do some of the things talked about in [this article](http://blog.lostpropertyhq.com/postgres-full-text-search-is-good-enough/) that Thoughtbot also linked to in their post, but this simple solution works for now.

Instead of using straight SQL to create the view I used a great gem, named [schema_plus](https://github.com/SchemaPlus/schema_plus) that extends the Rails migration capability.  I came across schema_plus from [this article](http://blog.pivotal.io/labs/labs/rails-and-sql-views-part-2-migrations) on creating SQL views with migrations.

## Coding Things Up

For my situation I simplified the SQL view because I didn't want Post objects returned when searching for Comments specifically.  I also added some fields from other tables:

```
create_table :search_views do |t|

          view2 = <<-VIEW2
  SELECT
    posts.id AS searchable_id,
    'Post' AS searchable_type,
    posts.title AS term
  FROM posts

  UNION

  SELECT
    posts.id AS searchable_id,
    'Post' AS searchable_type,
    posts.description AS term
  FROM posts

  UNION
  
  SELECT
    users.id AS searchable_id,
    'User' AS searchable_type,
    users.email AS term
  FROM users
          VIEW2
```
  
You can see the full migration file [here](https://github.com/asommer70/bcn/blob/master/db/migrate/20150611145709_update_search_view.rb).

I also needed to use this line to force the view creation:

```
create_view :searches, view2, force: true
```

And finally drop and re-create a bunch of indexes:

```
remove_index :posts, :title
remove_index :posts, :description
remove_index :comments, :content


execute %q{create index index_posts_on_title on "posts" using gin(to_tsvector('english', title))}
 execute %q{create index index_posts_on_description on "posts" using gin(to_tsvector('english', description))}
execute %q{create index index_comments_on_content on "comments" using 
execute %q{create index index_users_on_username on "users" using gin(to_tsvector('english', username))}
execute %q{create index index_users_on_email on "users" using gin(to_tsvector('english', email))}
```

Once that was done the good ol' ```bin/rake db:migrate``` actually worked.  It took a few times for to get things right.

Now the model is fairly simple:

```
class Search < ActiveRecord::Base
  extend Textacular

  attr_accessor :query

  belongs_to :searchable, polymorphic: true

  def results
    if @query.present?
      self.class.search(@query).preload(:searchable).map(&:searchable).uniq
    else
      Search.none
    end
  end
end
```

Forgot to mention that the [Textacular](https://github.com/textacular/textacular) gem is used for querying the SQL view.  It's covered in the Thoughtbot article.

After all the database heavy lifting setting up a controller index method was pretty snappy:

```
  def index
    @results = Search.new(query: params['query']).results
    @results = @results.select { |r| !r.nil? }
    @results = @results.sort { |a, b| b.class.to_s <=> a.class.to_s }
  end
```

Adding a search field into the Foundation top bar was also a snappy snap snap.  I did use some [Coffee Script](https://github.com/asommer70/bcn/blob/master/app/assets/javascripts/searches.coffee) to bind to the search button and the **enter** key for actually performing the search.  It's pretty standard jQuery stuff.

## Conclusion

A little loopy loop through the returned objects in the erb template and things are good to go as far as displaying the search results.

I've glanced through a few articles where people bemoan the inclusion of a large number of external libraries, but I keep thinking if someone has already solved this problem and packaged it up in a nice little gem why would I not use it?  There is something to understanding how all the pieces fit together, but I think I have a pretty good grasp of things at this point.  

Or I'd like to think that I do.

Party On!