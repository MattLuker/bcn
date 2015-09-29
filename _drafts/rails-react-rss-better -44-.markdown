# Better Rails React RSS Reader

## Okay, Slightly More Better

In a [previous post]() we setup an RSS reader for parsing Craigslist jobs postings.  The basic functionality is all there and now it’s time to add some additional things to make the project worth using.

In the conclusion I mentioned it’d be great to get the [Foundation Accordion](http://foundation.zurb.com/docs/components/accordion.html) element for the **Post** model working and to be able to delete a Feed.

It’s the little things in life…

## Accordion (always make me think of Weird Al)

My guess as to why the Accordion element isn’t working is that React has taken over all the event handlers for the component.  This ideas is somewhat backed up by a few Google searches I did to try and find an easy way to solve the problem.  I didn’t find an exact answer so I came up with one of my own.

React has a pretty clever way of handling [DOM Events](https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Event_handlers) all you need to do is add an **onClick** attribute to a component and give it a function.  

So edit **app/assets/javascripts/components/post.js.jsx** to have:

```

var Post = React.createClass({

  handleClick: function() {

    // Find the 'content' div.

    var content = this.getDOMNode().querySelector('.content');

    // Toggle the 'active' class.

    content.classList.toggle('active');

  },

  

  render: function() {

    return <li key={this.props.id} className="accordion-navigation">

      <a onClick={this.handleClick} href={'#post_' + this.props.id}>{this.props.title}</a>

      <div id={'post_' + this.props.id} className="content">

        <p>

          {this.props.description}

        </p>

        <a href={this.props.link} target="_blank" className="button tiny"><i className="fi-link"></i></a>

        &nbsp;&nbsp;

        <span className="date">{this.props.date}</span>

      </div>

    </li>

  }

})

```

Looking at the *a* tag you’ll notice a new **onClick** attribute that has a value of **{this.handleClick}**.  Above the **render** function is the **handleClick** function.  This isn’t too complicated of an event handler.  Basically using the **this.getDOMNode()** method the **querySelector()** method is chained looking for an element with the class **content**.  This will grab the **content** div in that particular li.

The **’active’** class is then toggled on the element.

Pow! The accordion element should now work as Foundation intended.  I’ll come clean, I did play around with triggering an event named **”toggled”** which is what Foundation Accordion is looking for, but I couldn’t get it to work right.  So toggling the **active** class was the next best thing.

## Deleting Feeds

Before we get into destroying stuff, let’s refactor the finding of stuff.  As in removing the duplicate ```@feed = Feed.find(params[:id])** line from the **update**, **edit**, and **show** methods.  

First, in the **app/controllers/feeds_controller.rb** file add another method in the **private** section:

```

    def set_feed

      @feed = Feed.find(params[:id])

    end

```

And at the top of the file under the class definition add:

```

  before_action :set_feed, only: [:show, :edit, :update, :destroy]

```

The **set_feed** method will now be called by the **before_action** filter and set **@feed** for the methods listed in the **only:** array.  Now go ahead and add a **destroy** method above the **private** section:

```

  def destroy

    @feed.destroy

  end

```

Finally, add a **delete** button and a click handler to the component in **app/assets/javascripts/compontents/feed.js.jsx**:

```

var Feed = React.createClass({

  deleteFeed: function() {

    $.ajax({

      url: '/feeds/' + this.props.id,

      type: 'delete',

    }).success(function(data) {

      console.log(data);

      Turbolinks.visit('/');

    })

  },

  render: function() {

    return <li key={this.props.id}>

    <div className="card">

      <div className="image">

      </div>

      <div className="content">

        <span className="title">

          <a href={'/feeds/' + this.props.id}>{this.props.title}</a>

        </span>

        <br/>

        <strong>Query:</strong> {this.props.query}

        <br/>

        <strong>Base URL:</strong> {this.props.base_url}

        <br/><br/>

      </div>

      <div classNameName="action">

        <div classNameName="row">

          <div className="columns small-12">

            <a href={this.props.base_url + '/search/jjj?format=&query=' + this.props.query + '&sort=rel'} className="button tiny" target="_blank">

              <i className="fi-link"></i>

            </a>

            <a href={'/feeds/' + this.props.id + '/edit'} className="button tiny">

              <i className="fi-pencil"></i>

            </a>

            <button className="button tiny alert right" onClick={this.deleteFeed}>

              <i className="fi-trash"></i>

            </button>

          </div>

        </div>

      </div>

    </div>

      </li>

  }

})

```

Notice come other changes with the Feed component.  The link button now points to the Craigslist search page instead of the Feed show page, and the Feed title now links to the Feed show page.  

Makes a little more sense I think.

## Gigs

So the previous version of the app only searched the Craigslist **jobs** postings, but there are often great opportunities in the **gigs** postings as well.  To modify **show** method in **app/controllers/feeds_controller.rb** to search gigs is pretty straight forward:

```

  def show

    @feed = Feed.find(params[:id])

    require 'open-uri'

    require 'nokogiri'

    job_url = "#{@feed.base_url}/search/jjj?format=rss&query=#{@feed.query}&sort=rel"

    gig_url = "#{@feed.base_url}/search/ggg?format=rss&query=#{@feed.query}&sort=rel"

    job_doc = Nokogiri::XML(open(job_url))

    gig_doc = Nokogiri::XML(open(gig_url))

    @posts = []

    job_doc.css('item').each_with_index do |node, idx|

       node.css('title').text

       item = {

         id: idx,

         title: node.css('title').text,

         description: node.css('description').text,

         link: node.css('link').text,

         date: node.at('//dc:date').text

       }

       @posts.push(item)

    end

    gig_doc.css('item').each_with_index do |node, idx|

       node.css('title').text

       item = {

         id: idx,

         title: node.css('title').text,

         description: node.css('description').text,

         link: node.css('link').text,

         date: node.at('//dc:date').text

       }

       @posts.push(item)

    end

  end

```

As you can see the main difference is in the Craigslist URL one has a **jjj** and the other **ggg**, then we’re doing the same Nokogiri parse the XML and loop through the item elements.

It might be useful to add another button to the Feed card on the index page for the **gigs** link in **app/assets/javascripts/compontents/feed.js.jsx**:

```

            <a href={this.props.base_url + '/search/jjj?format=&query=' + this.props.query + '&sort=rel'} className="button tiny" target="_blank">

              <i className="fi-dollar"></i>

            </a>

            <a href={this.props.base_url + '/search/ggg?format=&query=' + this.props.query + '&sort=rel'} className="button tiny" target="_blank">

              <i className="fi-lightbulb"></i>

            </a>

```

Also, notice I changed the icon for the **jobs** link to a dollar sign cause usually jobs have more money… well really I just wanted to keep the buttons small and use a different icon.

## Conclusion

The Craigslist RSS Rails React reader is now quite functional.  I’m starting to get more of a handle on this whole “React is awesome because… “ business.

Will probably have some more React and Rails (or maybe straight up React) posts in the future.

Party On!