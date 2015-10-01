var RecentPosts = React.createClass({
  getInitialState: function() {
    return {
      posts: this.props.data
    }
  },
  render: function() {
    var posts = this.state.posts.map(function(posts){
      return <Post {...posts} key={posts.id} />
    });

    return <ul className="posts no-bullet">
       {posts}
      </ul>
  }
})
