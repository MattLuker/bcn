var Post = React.createClass({
  // propTypes: {
  //   id: React.ProtoTypes.number,
  //   title: React.ProtoTypes.string,
  //   description: React.ProtoTypes.string,
  //   created_at: React.ProtoTypes.string,
  //   user: React.ProtoTypes.string,
  //   organization: React.ProtoTypes.string,
  //   image_url: React.PropTypes.string,
  //   comment_count: React.ProtoTypes.number
  // },

  render: function() {
    return (
      <li className="post row post_">
        <div class="row">
          <div class="large-1 columns post-list-image">
          </div>
        </div>
      </li>
    );
  }
});
