var RecentPosts = React.createClass({
  render: function() {
    var posts = this.props.data.map(function(posts){
      return <Post {...posts} />
    });

    return <ul className="posts no-bullet">
       {posts}
      </ul>
  }
})
